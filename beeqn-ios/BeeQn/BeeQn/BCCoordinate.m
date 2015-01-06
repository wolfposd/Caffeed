//
//  BCCoordinate.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 09.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BCCoordinate.h"

@implementation BCCoordinate


-(id) initWithX:(double) x y:(double)y distance:(double) distance
{
    self = [super init];
    if(self)
    {
        _x = x;
        _y = y;
        _distance = distance;
        _distances = @[[NSNumber numberWithDouble:distance],[NSNumber numberWithDouble:distance]];
    }
    return self;
}

-(id) initWithX:(double) x y:(double)y
{
    self = [self initWithX:x y:y distance:0];
    return self;
}


+(id) coordinateWithX:(double) x y:(double)y
{
    return [[BCCoordinate alloc] initWithX:x y:y distance:0];
}

+(id) coordinateWithX:(double) x y:(double)y distance:(double) distance
{
    return [[BCCoordinate alloc] initWithX:x y:y distance:distance];
}

-(CoordinateDistance) toCoordinateDistance
{
    return CoordinateDistanceMake(self.x, self.y,
                                  ((NSNumber*)self.distances.firstObject).doubleValue,
                                  ((NSNumber*)self.distances.lastObject).doubleValue);
}
-(Coordinate) toCoordinate
{
    return CoordinateMake(self.x, self.y, self.distance);
}

-(BOOL) isBetweenDistancesX:(int) x Y:(int)y
{
    double dist = sqrt( pow((self.x - x),2.0) + pow((self.y - y),2.0));
    double first = [self.distances.firstObject doubleValue];
    double last = [self.distances.lastObject doubleValue];

    if(first <= dist && dist <= last)
    {
        return true;
    }
    else
    {
        return false;
    }
}

-(double) distanceTo:(BCCoordinate*) coord
{
    double dist = sqrt( pow((self.x - coord.x),2.0) + pow((self.y - coord.y),2.0));
    return dist;
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"Coordinate: [%f,%f] d:%f (%@<%@)", self.x,self.y, self.distance, self.distances.firstObject, self.distances.lastObject];
}

@end
