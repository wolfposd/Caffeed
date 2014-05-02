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


@interface IndoorTrackingViewController ()<BeeQnLocationManagerProtocol, BeeQnServiceProtocol>
@property (retain, nonatomic) BeeQnService* beeqnService;
@property (retain, nonatomic) BeeQnLocationManager* beeqnLocation;
@property (weak, nonatomic) IBOutlet BQCircleProgress *circleProgress;
@property (weak, nonatomic) IBOutlet UIImageView *floorImageView;

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


-(void)manager:(BeeQnLocationManager *)manager hasFoundBeaconsTimes:(int)times fromMaximumSearch:(int)maximum
{
    [self.circleProgress setCurrentValue:times maximumValue:10 update:YES];
}

-(void)manager:(BeeQnLocationManager *)manager hasFoundBeacons:(NSArray *) beacons
{
    if(self.circleProgress.currentValue >= 10)
    {
        [self.beeqnLocation stopFindingBeacons];
        
        NSLog(@"%@", beacons);
        
        for(BQBeacon* beacon in beacons)
        {
            [self.beeqnService get_FloorPlanFor:beacon.UUID major:beacon.major minor:beacon.minor];
        }
        
        [self.circleProgress setCurrentValue:10 maximumValue:10 update:YES];
    }
    // FETCH FLOOR INFORMATION FOR BEACONS!!!
}

-(void)manager:(BeeQnLocationManager *)manager hasFoundBeacon:(BQBeacon *)beacon
{
    //DO NOTHING
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
               
                Coordinate c = CoordinateMake(x * scale , y * scale,  bqbeacon.accuracy);
                
                [locations addObject:StringFromCoordinate(c)];
                
                [self paintBeaconCirclesonFloor:bqbeacon scale:scale x:x y:y];
            }
            
            if(locations.count == 3)
            {
                [self drawBeaconsOnFloor:locations withScale:scale color:[UIColor redColor]];
                
                //Coordinate c =  [Trilateration point: CoordinateFromString(locations[0]) and:CoordinateFromString(locations[1]) and:CoordinateFromString(locations[2])];
                
                // draw
                //self.floorImageView.image = [self addPosition:self.floorImageView.image coordinate:CoordinateMake(c.x / scale, c.y/scale, 20)];
                 self.floorImageView.image = [self addPosition:self.floorImage coordinate:CoordinateMake(200, 200, 20)];
                
            }
        }
        
    }
}

-(void) paintBeaconCirclesonFloor:(BQBeacon*) bqbeacon scale:(double)scale x:(double) x y:(double)y
{
    
    NSArray* accuracies = [self.beeqnLocation.beaconCounter findBeaconsAccuracyValues:bqbeacon];
    for(NSNumber* accu in accuracies)
    {
        Coordinate temp = CoordinateMake(x * scale, y *scale, accu.doubleValue);
        [self drawBeaconsOnFloor:@[StringFromCoordinate(temp)] withScale:scale color:[UIColor blueColor]];
    }
    
    NSNumber* median = accuracies[accuracies.count / 2];
    [self drawBeaconsOnFloor:@[StringFromCoordinate(CoordinateMake(x * scale, y *scale, median.doubleValue))] withScale:scale color:[UIColor blackColor]];

}


-(void) drawBeaconsOnFloor:(NSArray*) coordinateStrings withScale:(double) scale color:(UIColor*) color
{
    UIImage* image = self.floorImage;
    
    for(NSString* string in coordinateStrings)
    {
        Coordinate c =  CoordinateFromString(string);

        double distance = c.distance;
        
        
        if(distance > 10)
        {
            distance /= 2.5;
        }
        else if(distance > 8)
        {
            distance /= 1.8;
        }
//        else if(c.distance > 4)
//        {
//            distance = distance / 2;
//        }
        
        c = CoordinateMake(c.x/scale, c.y/scale, distance / scale);
        
       // NSLog(@"Painting Circle: %@", StringFromCoordinate(c));
        
        image =  [self drawEllipseOnImage:image withCoordinate:c andColor:color];
    }
    
    self.floorImage = image;
    self.floorImageView.image = image;
    
}


-(UIImage *) drawEllipseOnImage:(UIImage*) image withCoordinate:(Coordinate) coord andColor:(UIColor*) circleColor
{
    int width = image.size.width;
    int height = image.size.height;
    
    UIGraphicsBeginImageContext(image.size);
    
	// draw original image into the context
	//[image drawAtPoint:CGPointZero];
    
	// get the context for CoreGraphics
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    
    if(coord.x >= 0 && coord.x < width && coord.y >= 0 && coord.y < height)
    {
        int x = coord.x - coord.distance/2;
        int y = coord.y + coord.distance/2;

        CGRect circleRect = CGRectMake(x, height - y, coord.distance, coord.distance);
        CGContextSetStrokeColorWithColor(context, circleColor.CGColor);
        CGContextStrokeEllipseInRect(context, circleRect);
        CGContextStrokeEllipseInRect(context, CGRectMake(coord.x, height - coord.y, 5, 5));
    }
    
	CGContextTranslateCTM(context, 0, image.size.height);
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return retImage;

}

-(UIImage *)addPosition:(UIImage *)image coordinate:(Coordinate) coord
{
    int width = image.size.width;
    int height = image.size.height;
    
    UIGraphicsBeginImageContext(image.size);
    
	// draw original image into the context
	[image drawAtPoint:CGPointZero];
    
	// get the context for CoreGraphics
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    
    if(coord.x >= 0 && coord.x < width && coord.y >= 0 && coord.y < height)
    {
        CGRect circleRect = CGRectMake(coord.x, coord.y, coord.distance, coord.distance);

        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextFillEllipseInRect(context, circleRect);
        //CGContextStrokeEllipseInRect(ctx, circleRect);
    }
    
	CGContextTranslateCTM(context, 0, image.size.height);
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return retImage;
    
}


@end
