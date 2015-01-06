//
//  Trilateration.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 30.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef struct {
    double x;
    double y;
    double minDistance;
    double maxDistance;

} CoordinateDistance;

CoordinateDistance CoordinateDistanceMake(double x , double y, double minD, double maxD);

typedef struct
{
    CoordinateDistance d1;
    CoordinateDistance d2;
    CoordinateDistance d3;
} CoordinateDistanceTriple;

CoordinateDistanceTriple CoordinateDistanceTripleMake(CoordinateDistance d1, CoordinateDistance d2, CoordinateDistance d3);

typedef struct {
    double x1;
    double y1;
    double x2;
    double y2;
} Rectangle;


typedef struct {
    double x;
    double y;
    double distance;
} Coordinate;

/**
 *  Creates a Coordinate
 *
 *  @param x        x
 *  @param y        y
 *  @param distance distance
 *
 *  @return Coordinate
 */
Coordinate CoordinateMake(double x , double y, double distance);

NSString* StringFromCoordinate(Coordinate c);

Coordinate CoordinateFromString(NSString* st);

Rectangle RectangleMake(double x1, double y1, double x2, double y2);
NSString* RectangleToString(Rectangle r);

BOOL CoordinateIsInRect(Coordinate coord, Rectangle rect);


@interface Trilateration : NSObject


/**
 *  Trilaterates between the 3 points
 *
 *  @param p1 first point
 *  @param p2 second point
 *  @param p3 third point
 *
 *  @return Coordinate between the points
 */
+(Coordinate) point:(Coordinate) p1 and:(Coordinate) p2 and:(Coordinate) p3;

@end
