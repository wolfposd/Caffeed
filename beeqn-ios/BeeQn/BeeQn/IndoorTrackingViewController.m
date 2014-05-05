//
//  IndoorTrackingViewController.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 23.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "IndoorTrackingViewController.h"
#import "BeeQnService.h"
#import "BeeQnLocationManager.h"
#import "BQCircleProgress.h"

#import "Trilateration.h"
#import "DrawingClass.h"
#import "DoublePair.h"


#define DEBUG_DRAW_CIRCLES YES


@interface IndoorTrackingViewController ()<BeeQnLocationManagerProtocol, BeeQnServiceProtocol>
@property (retain, nonatomic) BeeQnService* beeqnService;
@property (retain, nonatomic) BeeQnLocationManager* beeqnLocation;
@property (weak, nonatomic) IBOutlet BQCircleProgress *circleProgress;
@property (weak, nonatomic) IBOutlet UIImageView *floorImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (retain, nonatomic) NSDictionary* floorPlan;
@property (retain, nonatomic) NSString* lastHash;
@property (retain, nonatomic) UIImage* floorImage;

@end

@implementation IndoorTrackingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.beeqnService = [[BeeQnService alloc] init];
        self.beeqnService.delegate = self;
        
        
        self.beeqnLocation = [[BeeQnLocationManager alloc] init];
        self.beeqnLocation.delegate = self;
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.circleProgress setCurrentValue:0];
    [self.circleProgress setMaximumValue:5];
    self.circleProgress.circleWidth = 16.0f;
    [self.circleProgress update];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.beeqnLocation startFindingGPS];
}

#pragma mark - Calculations

-(void) checkForMatchingPoints
{
    NSMutableArray* xvals = [NSMutableArray new];
    NSMutableArray* yvals = [NSMutableArray new];
    
    NSMutableArray* beacons = [NSMutableArray new];
    NSMutableArray* coordinatesForBeaconsAsString = [NSMutableArray new];
    
    for(NSDictionary* dict in [self.floorPlan objectForKey:@"beacons"])
    {
        NSNumber* x = [dict objectForKey:@"x"];
        NSNumber* y = [dict objectForKey:@"y"];
        
        [xvals addObject:x];
        [yvals addObject:y];
        
        [beacons addObject:[self makeBeaconObject:dict]];
        
        [coordinatesForBeaconsAsString addObject:StringFromCoordinate(CoordinateMake(x.doubleValue, y.doubleValue, -1))];
    }
    NSArray* sorters =  @[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]];
    
    [xvals sortUsingDescriptors:sorters];
    [yvals sortUsingDescriptors:sorters];
    
    double x1 = [xvals.firstObject doubleValue];
    double x2 = [xvals.lastObject doubleValue];
    
    double y1 = [yvals.lastObject doubleValue];
    double y2 = [yvals.firstObject doubleValue];
    
    Rectangle bounds = RectangleMake(x1,y1,x2,y2);
    
    NSArray* copy0 = [NSArray arrayWithArray: [self findBeaconAccuraciesFrom:beacons[0]]];
    NSArray* copy1 = [NSArray arrayWithArray: [self findBeaconAccuraciesFrom:beacons[1]]];
    NSArray* copy2 = [NSArray arrayWithArray: [self findBeaconAccuraciesFrom:beacons[2]]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^()
                   {
                       [self performPermutationCalculation:bounds
                             coordinatesForBeaconsAsString:coordinatesForBeaconsAsString copy2:copy2 copy1:copy1 copy0:copy0];
                   }
                   );
}
- (void)performPermutationCalculation:(Rectangle)bounds coordinatesForBeaconsAsString:(NSMutableArray *)coordinatesForBeaconsAsString copy2:(NSArray *)copy2 copy1:(NSArray *)copy1 copy0:(NSArray *)copy0
{
    NSMutableSet* set = [NSMutableSet new];
    
    for(NSNumber* doubleValue0 in copy0)
    {
        for(NSNumber* doubleValue1 in copy1)
        {
            for(NSNumber* doubleValue2 in copy2)
            {
                Coordinate c0 = CoordinateFromString(coordinatesForBeaconsAsString[0]);
                Coordinate c1 = CoordinateFromString(coordinatesForBeaconsAsString[1]);
                Coordinate c2 = CoordinateFromString(coordinatesForBeaconsAsString[2]);
                c0.distance = doubleValue0.doubleValue;
                c1.distance = doubleValue1.doubleValue;
                c2.distance = doubleValue2.doubleValue;
                
                Coordinate result = [Trilateration point:c0 and:c1 and:c2];
                
                if(CoordinateIsInRect(result, bounds))
                {
                    [set addObject:[DoublePair doublePairX:result.x Y:result.y]];
                }
            }
        }
    }
    
    
    UIImage* image = self.floorImage;
    
    for(DoublePair* p in set)
    {
        image = [DrawingClass image:image drawPointOnImage:CoordinateMake(p.xValue, p.yValue, 25) color:[UIColor cyanColor]];
    }
    
    [self performSelectorOnMainThread:@selector(updateStatusLabelOnMainThread:) withObject:[set description] waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(paintPointCloudOnMainThread:) withObject:image waitUntilDone:NO];
}

-(void) paintPointCloudOnMainThread:(UIImage*) newImage
{
    self.floorImage = newImage;
    self.floorImageView.image = newImage;
}

-(void) updateStatusLabelOnMainThread:(NSString*) text
{
    self.statusLabel.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]{}()\n"]];
}

#pragma mark - utility methods

-(BQBeacon*) makeBeaconObject:(NSDictionary*) dict
{
    id formatter =  [[NSNumberFormatter alloc] init];
    NSString* uuid = [dict objectForKey:@"UUID"];
    NSNumber* maj = [formatter numberFromString:[dict objectForKey:@"major"]];
    NSNumber* min = [formatter numberFromString:[dict objectForKey:@"minor"]];
    
    return [BQBeacon beacon:uuid major:maj minor:min proximity:0 accuracy:0 rssi:0];
}

-(NSArray*) findBeaconAccuraciesFrom:(BQBeacon*) beacon
{
    return [self.beeqnLocation.beaconCounter findBeaconsAccuracyValues:beacon];
}

-(NSArray*) findBeaconAccuraciesFromBeaconJSON:(NSDictionary*) dict
{
    return [self.beeqnLocation.beaconCounter findBeaconsAccuracyValues:[self makeBeaconObject:dict]];
}

-(Coordinate) coordinateForBeacon:(BQBeacon*) beacon
{
    id formatter =  [[NSNumberFormatter alloc] init];
    NSArray* array = [self.floorPlan objectForKey:@"beacons"];
    
    for(NSDictionary* dict in array)
    {
        NSString* uuid = [dict objectForKey:@"UUID"];
        NSNumber* maj = [formatter numberFromString:[dict objectForKey:@"major"]];
        NSNumber* min = [formatter numberFromString:[dict objectForKey:@"minor"]];
        
        if([beacon.UUID isEqualToString:uuid] && maj.intValue == beacon.major.intValue && min.intValue == beacon.minor.intValue)
        {
            double x = [[dict objectForKey:@"x"] doubleValue];
            double y = [[dict objectForKey:@"y"] doubleValue];
            
            return CoordinateMake(x, y, -1);
        }
    }
    return CoordinateMake(NSNotFound, NSNotFound, NSNotFound);
}



#pragma mark - BeeQnLocation and Service

-(void)manager:(BeeQnLocationManager *)manager hasFoundBeaconsTimes:(int)times fromMaximumSearch:(int)maximum
{
    if(self.beeqnLocation.currentModeOfOperation == kModeRangeAllBeacons)
    {
      [self.circleProgress setCurrentValue:times maximumValue:10 update:YES];
    }
    else if(self.beeqnLocation.currentModeOfOperation == kModeRangeAllBeaconsForInfinity)
    {
        [self.circleProgress setCurrentValue:times maximumValue:100 update:YES];
    }
    
}

-(void)manager:(BeeQnLocationManager *)manager hasFoundBeacons:(NSArray *) beacons
{
    
    if(self.circleProgress.currentValue >= 10 && self.beeqnLocation.currentModeOfOperation == kModeRangeAllBeacons)
    {
        [self.beeqnLocation stopFindingBeacons];
        
        NSLog(@"%@", beacons);
        
        for(BQBeacon* beacon in beacons)
        {
            [self.beeqnService get_FloorPlanFor:beacon.UUID major:beacon.major minor:beacon.minor];
        }
        
        [self.circleProgress setCurrentValue:10 maximumValue:10 update:YES];
    }
    else if(self.beeqnLocation.currentModeOfOperation == kModeRangeAllBeaconsForInfinity)
    {
        double scale = [[self.floorPlan objectForKey:@"scale"] doubleValue];
        for(BQBeacon* beacon in beacons)
        {
            Coordinate c = [self coordinateForBeacon:beacon];
            
            [self paintSingleBeaconCircleOnFloor:beacon scale:scale x:c.x y:c.y];
        }
        if(self.circleProgress.currentValue == 2 || self.circleProgress.currentValue % 20 == 0)
        {
            NSLog(@"%@", @"starting calculation");
            
            [self checkForMatchingPoints];
            [self.beeqnLocation.beaconCounter resetCount];
        }
        
    }
    // FETCH FLOOR INFORMATION FOR BEACONS!!!
}

- (void)manager:(BeeQnLocationManager*)manager hasFoundGPS:(CLLocation*)gpslocation
{
    [self.beeqnLocation stopFindingGPS];
    [self.beeqnService get_BeaconListForLocation:gpslocation];
}


-(void)service:(id)beeqnservice foundBeaconsUUIDs:(NSArray *)uuids
{
    [self.beeqnLocation updateRegions:uuids];
    [self.beeqnLocation startFindingBeacons];
}

-(void)service:(id)beeqnservice foundFloorData:(id)floorData
{
    if(floorData)
    {
        //NSLog(@"%@", floorData);
        
        if(![self.lastHash isEqualToString:[floorData objectForKey:@"hash"]])
        {
            self.lastHash = [floorData objectForKey:@"hash"];
            self.floorPlan = floorData;
            
            
            self.floorImage = [self.floorPlan objectForKey:@"imagedata"];
            self.floorImageView.image =self.floorImage;
            
            
            
            id formatter =  [[NSNumberFormatter alloc] init];
            NSArray* beacons = [floorData objectForKey:@"beacons"];
            NSMutableArray* locations = [NSMutableArray new];
            
            double scale = [[floorData objectForKey:@"scale"] doubleValue];
            
            for(id beacon in beacons)
            {
                NSString* uuid = [beacon objectForKey:@"UUID"];
                NSNumber* maj = [formatter numberFromString:[beacon objectForKey:@"major"]];
                NSNumber* min = [formatter numberFromString:[beacon objectForKey:@"minor"]];
                BQBeacon* bqbeacon = [self.beeqnLocation.beaconCounter findBeaconWithInfo:[BQBeacon beacon:uuid major:maj minor:min proximity:0 accuracy:0 rssi:0]];
                
                double x = [[beacon objectForKey:@"x"] doubleValue];
                double y = [[beacon objectForKey:@"y"] doubleValue];
               
                Coordinate c = CoordinateMake(x, y,  bqbeacon.accuracy);
                
                [locations addObject:StringFromCoordinate(c)];
                [self paintBeaconPositionOnFloorX:x andY:y];
                [self paintAllBeaconCirclesOnFloorWitMedianAndMean:bqbeacon scale:scale x:x y:y];
            }
            
            if(locations.count == 3)
            {
                [self drawBeaconsOnFloor:locations withScale:scale color:[UIColor redColor]];
                
                //Coordinate c =  [Trilateration point: CoordinateFromString(locations[0]) and:CoordinateFromString(locations[1]) and:CoordinateFromString(locations[2])];
                
                // draw
                //self.floorImageView.image = [self addPosition:self.floorImageView.image coordinate:CoordinateMake(c.x / scale, c.y/scale, 20)];
                //self.floorImageView.image = [self addPosition:self.floorImage coordinate:CoordinateMake(200, 200, 20)];
                
            }
        }
     
        [self.beeqnLocation startFindingBeaconsInfiniteTime];
    }
}


#pragma mark - Painting of Circles and Beacons

-(void) paintSingleBeaconCircleOnFloor:(BQBeacon*) bqbeacon scale:(double) scale x:(double)x y:(double)y
{
    if(DEBUG_DRAW_CIRCLES)
    {
        Coordinate temp = CoordinateMake(x, y , bqbeacon.accuracy);
        [self drawBeaconsOnFloor:@[StringFromCoordinate(temp)] withScale:scale color:[UIColor magentaColor]];
    }
}

-(void) paintAllBeaconCirclesOnFloorWitMedianAndMean:(BQBeacon*) bqbeacon scale:(double)scale x:(double) x y:(double)y
{
    if(DEBUG_DRAW_CIRCLES)
    {
        NSArray* accuracies = [self.beeqnLocation.beaconCounter findBeaconsAccuracyValues:bqbeacon];
        for(NSNumber* accu in accuracies)
        {
            Coordinate temp = CoordinateMake(x, y , accu.doubleValue);
            [self drawBeaconsOnFloor:@[StringFromCoordinate(temp)] withScale:scale color:[UIColor blueColor]];
        }
        
        NSNumber* median = accuracies[accuracies.count / 2];
        [self drawBeaconsOnFloor:@[StringFromCoordinate(CoordinateMake(x, y , median.doubleValue))] withScale:scale color:[UIColor purpleColor]];
    }

}

-(void) paintBeaconPositionOnFloorX:(double)x andY:(double)y
{
    self.floorImage = [DrawingClass image:self.floorImage drawPositionOfBeacon:CoordinateMake(x, y, 0)];
    self.floorImageView.image = self.floorImage;
}


-(void) drawBeaconsOnFloor:(NSArray*) coordinateStrings withScale:(double) scale color:(UIColor*) color
{
    if(DEBUG_DRAW_CIRCLES)
    {
        UIImage* image = self.floorImage;
        
        for(NSString* string in coordinateStrings)
        {
            Coordinate coordinate =  CoordinateFromString(string);
            
            double distance = coordinate.distance;
            
//            if(distance > 10)
//            {
//                distance /= 2.5;
//            }
//            else if(distance > 8)
//            {
//                distance /= 1.8;
//            }
            //        else if(c.distance > 4)
            //        {
            //            distance = distance / 2;
            //        }
            
            coordinate = CoordinateMake(coordinate.x, coordinate.y, distance / scale);
            image = [DrawingClass image:image drawDistanceCircleOfBeacon:coordinate color:color];
        }
        
        self.floorImage = image;
        self.floorImageView.image = image;
    }
    
}


@end
