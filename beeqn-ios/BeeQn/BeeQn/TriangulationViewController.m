//
//  TriangulationViewController.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 09.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//


#define DEBUG_DRAW_CIRCLES YES


#import "Trilateration.h"
#import "TriangulationViewController.h"
#import "BeeQn.h"
#import "DrawingClass.h"
#import "BCCoordinate.h"

@interface TriangulationViewController ()<BeeQnServiceProtocol>

@property (nonatomic,strong) BeeQnService* service;

@property (nonatomic,strong) UIImage* image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TriangulationViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[BeeQnService alloc] init];
    self.service.delegate = self;
    
    [self.service get_FloorPlanFor:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" major:@5329 minor:@10936];
    
}


-(void)service:(id)beeqnservice foundFloorData:(id)floorData
{
    
    NSLog(@"%@", floorData);
    
    
    self.image = [floorData objectForKey:@"imagedata"];
    
    CGRect bounds = CGRectMake(0, self.image.size.height, self.image.size.width,self.image.size.height);
    
    NSLog(@"w:%f h:%f", self.image.size.width, self.image.size.height);
    
    [self updateImage:[DrawingClass image:self.image drawRectangle:bounds width:1]];
    
    
    
    [self measureStuff];

    
}

-(void) testingDrawing
{
    
    
    [self updateImage:[DrawingClass image:self.image drawDistanceCircleOfBeacon:CoordinateMake(100, 100, 50)]];
    
    
    [self updateImage:[DrawingClass image:self.image drawRectangle:CGRectMake(100, 100, 50, 50)]];
    
    
}


-(void) calculateWithRealDat:(id)floorData
{
    // TODO REIMPLEMENT THIS SHIT
    
    NSArray* beacons = [floorData objectForKey:@"beacons"];
    NSMutableArray* stringLocations = [NSMutableArray new];
    
    double scale = [[floorData objectForKey:@"scale"] doubleValue];
    
    NSArray* accuracies = @[@9,@3,@6];
    
    for(int i = 0; i < beacons.count; i++)
    {
        id beacon = beacons[i];
        double x = [[beacon objectForKey:@"x"] doubleValue];
        double y = [[beacon objectForKey:@"y"] doubleValue];
        
        NSNumber* num = accuracies[i];
        Coordinate c = CoordinateMake(x, y, num.doubleValue);
        
        [stringLocations addObject:StringFromCoordinate(c)];
        [self paintBeaconPositionOnFloorX:x andY:y];
    }
    
    
    if(stringLocations.count == 3)
    {
        [self drawBeaconsOnFloor:stringLocations withScale:scale color:[UIColor redColor]];
        
        Coordinate c =
        [Trilateration point:CoordinateFromString(stringLocations[0])
                         and:CoordinateFromString(stringLocations[1])
                         and:CoordinateFromString(stringLocations[2])];
        
        // draw
        
        NSLog(@"%@", StringFromCoordinate(c));
        
        [self updateImage:[DrawingClass image:self.image drawDistanceCircleOfBeacon:CoordinateMake(c.x, c.y, 20) color:[UIColor blueColor]]];
        
        //self.floorImageView.image = [self addPosition:self.floorImage coordinate:CoordinateMake(200, 200, 20)];
        
        
        
        
        NSMutableArray* locations = [NSMutableArray new];
        
        
        NSArray* distancesPlus = @[
                                   @[@(8 / scale),@(10 / scale)],
                                   @[@(2 / scale),@(4 / scale)],
                                   @[@(5 / scale),@(7 / scale)]
                                   ];
        for(int i = 0; i < 3; i++)
        {
            Coordinate cc = CoordinateFromString(stringLocations[i]);
            BCCoordinate* bcc = [BCCoordinate coordinateWithX:cc.x y:cc.y];
            
            bcc.distances = distancesPlus[i];
            
            [locations addObject:bcc];
            
            
            cc.distance = [distancesPlus[i][0] doubleValue];
            [self updateImage:[DrawingClass image:self.image drawDistanceCircleOfBeacon:cc color:[UIColor blueColor]]];
            cc.distance = [distancesPlus[i][1] doubleValue];
            [self updateImage:[DrawingClass image:self.image drawDistanceCircleOfBeacon:cc color:[UIColor blueColor]]];
            
        }
        
        
        //UIImage* image = [DrawingClass image:self.image drawAllPossibleLocationsOnImageArray:locations];
        //[self updateImage:image];
    }
}



-(void) measureStuff // hier stuff für MA ausarbeitung
{
    double SCALE = 0.0144;
    
    // ECHTE WERTE:
    // 4.5 und 1.5 und 3
    
    // BEACON WERTE:
    // 4 und 1.5 und 2.5
    
    NSArray* beaconsArray = @[ // distance in meter
                              [BCCoordinate coordinateWithX:25  y:85  distance: 4 / SCALE],
                              [BCCoordinate coordinateWithX:360 y:335 distance: 1.5 / SCALE],
                              [BCCoordinate coordinateWithX:360 y:85  distance: 2.5 / SCALE],
                              ];
    
    NSArray* distancesPlus = @[
                               @[@(2.5 / SCALE),@(6 / SCALE)],
                               @[@(0.7 / SCALE),@(2.4 / SCALE)],
                               @[@(1.7 / SCALE),@(3.5 / SCALE)]
                               ];
    
    [beaconsArray[0] setDistances:distancesPlus[0]];
    [beaconsArray[1] setDistances:distancesPlus[1]];
    [beaconsArray[2] setDistances:distancesPlus[2]];
    
    for(BCCoordinate* c in beaconsArray)
    {
        [self paintBeaconPositionOnFloorX:c.x andY:c.y];
    }
    
    
    [self drawCoordinatesOnFloor:beaconsArray];
    
    Coordinate trilaterationPoint = [Trilateration point:[beaconsArray[0] toCoordinate] and:[beaconsArray[1] toCoordinate]
                                                     and:[beaconsArray[2] toCoordinate]];
    
    NSLog(@"Calculated Point x: %f  y:%f", trilaterationPoint.x, trilaterationPoint.y);
    
    
    //[self updateImage:[DrawingClass image:self.image drawDistanceCircleOfBeacon:CoordinateMake(trilaterationPoint.x, trilaterationPoint.y, 5) color:[UIColor purpleColor]]];
    
    NSArray* matchingCoordinates = [self matchingCoordinates:beaconsArray inImage:self.image];
    
    //[self updateImage:[DrawingClass image:self.image drawAllPossibleLocationsOnImage:matchingCoordinates]];
    
    NSDictionary* closest = [self closestCoordinate:matchingCoordinates beacons:beaconsArray];
    
    if(closest)
    {
        for(int i = 1800 ; i < 1900; i+=10)
        {
            [self updateImage:[DrawingClass image:self.image drawAllPossibleLocationsOnImage:closest[[NSNumber numberWithInt:i]]]];
        }
        

        //NSLog(@"%@", closest);
    }
    else{
        NSLog(@"%@", @"No closest");
    }
}


-(NSArray*) matchingCoordinates:(NSArray*) arrayOfBCCoordinates inImage:(UIImage* ) image;
{
    int width = image.size.width;
    int height = image.size.height;
    
    NSMutableArray* result = [NSMutableArray new];
    
    for(int x = 0; x < width; x++)
    {
        for(int y = 0; y < height; y++)
        {
            BOOL isBetween = YES;
            for(BCCoordinate* cc in arrayOfBCCoordinates)
            {
                if(![cc isBetweenDistancesX:x Y:y])
                {
                    isBetween = NO;
                    break;
                }
            }
            if(isBetween)
            {
                [result addObject:[BCCoordinate coordinateWithX:x y:y]];
            }
        }
    }
    return result;
}

-(NSDictionary*) closestCoordinate:(NSArray*) matchingCoordinates beacons:(NSArray*) beacons
{
    
    NSLog(@"modulovalue %d", ((int)((int)775.123123) / 10) * 10);
    
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    BCCoordinate* result = nil;
    double distance = 2000000;
    
    
    for(BCCoordinate* coord in matchingCoordinates)
    {
        double mydist = 0;
        
        for(int i = 0; i < beacons.count; i++)
        {
            double modul = 0;
            switch (i) {
                case 0:
                    modul = 1;
                    break;
                case 1:
                    modul = 3;
                    break;
                case 2:
                    modul = 2;
                    break;
                default:
                    break;
            }
            
            BCCoordinate* beacon = beacons[i];
            mydist += [beacon distanceTo:coord] * (modul);
        }
        
        for(BCCoordinate* beacon in beacons)
        {
            mydist += [beacon distanceTo:coord];
        }
        
        if(mydist < distance)
        {
            distance = mydist;
            result = coord;
        }
        else if(mydist == distance)
        {
            NSLog(@"duplicate %@", coord);
        }
        
        NSNumber* num=[NSNumber numberWithInt:((int)((int)mydist) / 10) * 10 ];
        NSMutableArray* ar = dict[num];
        if(!ar)
        {
            ar = [NSMutableArray new];
            dict[num] = ar;
        }
        [ar addObject:coord];
    }
    
    NSLog(@"distance %f closest: %@", distance, result);
    return dict;
}



-(void) updateImage:(UIImage*) image
{
    self.image = image;
    self.imageView.image = self.image;
}

#pragma mark - Painting of Circles and Beacons

-(void) paintSingleBeaconCircleOnFloor:(double) accuracy scale:(double) scale x:(double)x y:(double)y
{
    if(DEBUG_DRAW_CIRCLES)
    {
        Coordinate temp = CoordinateMake(x, y , accuracy);
        [self drawBeaconsOnFloor:@[StringFromCoordinate(temp)] withScale:scale color:[UIColor magentaColor]];
    }
}

-(void) paintBeaconPositionOnFloorX:(double)x andY:(double)y
{
    [self updateImage: [DrawingClass image:self.image drawPositionOfBeacon:CoordinateMake(x, y, 5)]];
}

-(void) drawBeaconsOnFloor:(NSArray*) coordinateStrings withScale:(double) scale color:(UIColor*) color
{
    if(DEBUG_DRAW_CIRCLES)
    {
        UIImage* image = self.image;
        
        for(NSString* string in coordinateStrings)
        {
            Coordinate coordinate =  CoordinateFromString(string);
            
            double distance = coordinate.distance;
            
            coordinate = CoordinateMake(coordinate.x, coordinate.y, distance / scale);
            image = [DrawingClass image:image drawDistanceCircleOfBeacon:coordinate color:color];
        }
        [self updateImage:image];
    }
    
}


-(void) drawCoordinatesOnFloor:(NSArray*) arrayOfBCCoordinate
{
    
    UIImage* image = self.image;
    
    for(BCCoordinate* coordinate in arrayOfBCCoordinate)
    {
        
        [self paintBeaconPositionOnFloorX:coordinate.x andY:coordinate.y];
        
        image = [DrawingClass image:image drawDistanceCircleOfBeacon:CoordinateMake(coordinate.x, coordinate.y, coordinate.distance)
                              color:[UIColor redColor]];
        if(coordinate.distances.firstObject != coordinate.distances.lastObject)
        {
            NSNumber* first = coordinate.distances.firstObject;
            NSNumber* last = coordinate.distances.lastObject;
            image = [DrawingClass image:image drawDistanceCircleOfBeacon:CoordinateMake(coordinate.x, coordinate.y, first.doubleValue) color:[UIColor blueColor]];
            image = [DrawingClass image:image drawDistanceCircleOfBeacon:CoordinateMake(coordinate.x, coordinate.y, last.doubleValue) color:[UIColor blueColor]];
        }
    }
    
    [self updateImage:image];
}


@end
