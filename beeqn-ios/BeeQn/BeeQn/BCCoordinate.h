//
//  BCCoordinate.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 09.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trilateration.h"

@interface BCCoordinate : NSObject


@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) double distance;
@property (nonatomic, retain) NSArray* distances;


-(id) initWithX:(double) x y:(double)y;
-(id) initWithX:(double) x y:(double)y distance:(double) distance;


+(id) coordinateWithX:(double) x y:(double)y;
+(id) coordinateWithX:(double) x y:(double)y distance:(double) distance;



-(CoordinateDistance) toCoordinateDistance;

-(Coordinate) toCoordinate;


-(BOOL) isBetweenDistancesX:(int) x Y:(int)y;



-(double) distanceTo:(BCCoordinate*) coord;

@end
