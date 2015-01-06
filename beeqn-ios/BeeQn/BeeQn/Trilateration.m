//
//  Trilateration.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 30.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "Trilateration.h"


CoordinateDistance CoordinateDistanceMake(double x , double y, double minD, double maxD)
{
    CoordinateDistance d;
    d.x = x;
    d.y = y;
    d.minDistance = minD;
    d.maxDistance = maxD;
    return d;
}

CoordinateDistanceTriple CoordinateDistanceTripleMake(CoordinateDistance d1, CoordinateDistance d2, CoordinateDistance d3)
{
    CoordinateDistanceTriple t;
    t.d1 = d1;
    t.d2 = d2;
    t.d3 = d3;
    return t;
}

Coordinate CoordinateMake(double x , double y, double distance)
{
    Coordinate c;
    c.x = x;
    c.y = y;
    c.distance = distance;
    return c;
}

Rectangle RectangleMake(double x1, double y1, double x2, double y2)
{
    Rectangle r;
    r.x1 = x1;
    r.x2 = x2;
    r.y1 = y1;
    r.y2 = y2;
    return r;
}
NSString* RectangleToString(Rectangle r)
{
    return [NSString stringWithFormat:@"<%d %d>;<%d %d>", (int)r.x1, (int)r.y1 , (int)r.x2, (int)r.y2 ];
}


NSString* StringFromCoordinate(Coordinate c)
{
    return [NSString stringWithFormat:@"%f %f %f",c.x, c.y, c.distance];
}

Coordinate CoordinateFromString(NSString* st)
{
 NSArray* com =   [st componentsSeparatedByString:@" "];
    
    if(com.count != 3)
    {
        return CoordinateMake(NSNotFound , NSNotFound, NSNotFound);
    }
    else
    {
        return CoordinateMake([com[0] doubleValue], [com[1] doubleValue], [com[2] doubleValue]);
    }
}

BOOL CoordinateIsInRect(Coordinate coord, Rectangle rect)
{
    return rect.x1 <= coord.x &&  coord.x <= rect.x2 && rect.y1 <= coord.y && coord.y <= rect.y2;
}

@implementation Trilateration


+(Coordinate) point:(Coordinate) p1 and:(Coordinate) p2 and:(Coordinate) p3
{
    NSMutableArray* P1 = [[NSMutableArray alloc] initWithCapacity:0];
    [P1 addObject:[NSNumber numberWithDouble:p1.x]];
    [P1 addObject:[NSNumber numberWithDouble:p1.y]];
    
    NSMutableArray* P2 = [[NSMutableArray alloc] initWithCapacity:0];
    [P2 addObject:[NSNumber numberWithDouble:p2.x]];
    [P2 addObject:[NSNumber numberWithDouble:p2.y]];
    
    NSMutableArray* P3 = [[NSMutableArray alloc] initWithCapacity:0];
    [P3 addObject:[NSNumber numberWithDouble:p3.x]];
    [P3 addObject:[NSNumber numberWithDouble:p3.y]];
    
    //this is the distance between all the points and the unknown point
    double DistA = p1.distance; //6.4031;
    double DistB = p2.distance; //4.1231;
    double DistC = p3.distance; //5.6568;
    
    // ex = (P2 - P1)/(numpy.linalg.norm(P2 - P1))
    NSMutableArray *ex = [[NSMutableArray alloc] initWithCapacity:0];
    double temp = 0;
    for (int i = 0; i < [P1 count]; i++)
    {
        double t1 = [[P2 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double t = t1 - t2;
        temp += (t*t);
    }
    for (int i = 0; i < [P1 count]; i++)
    {
        double t1 = [[P2 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double exx = (t1 - t2)/sqrt(temp);
        [ex addObject:[NSNumber numberWithDouble:exx]];
    }
    
    // i = dot(ex, P3 - P1)
    NSMutableArray *p3p1 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [P3 count]; i++) {
        double t1 = [[P3 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double t3 = t1 - t2;
        [p3p1 addObject:[NSNumber numberWithDouble:t3]];
    }
    
    double ival = 0;
    for (int i = 0; i < [ex count]; i++) {
        double t1 = [[ex objectAtIndex:i] doubleValue];
        double t2 = [[p3p1 objectAtIndex:i] doubleValue];
        ival += (t1*t2);
    }
    
    // ey = (P3 - P1 - i*ex)/(numpy.linalg.norm(P3 - P1 - i*ex))
    NSMutableArray *ey = [[NSMutableArray alloc] initWithCapacity:0];
    double p3p1i = 0;
    for (int  i = 0; i < [P3 count]; i++) {
        double t1 = [[P3 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double t3 = [[ex objectAtIndex:i] doubleValue] * ival;
        double t = t1 - t2 -t3;
        p3p1i += (t*t);
    }
    for (int i = 0; i < [P3 count]; i++) {
        double t1 = [[P3 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double t3 = [[ex objectAtIndex:i] doubleValue] * ival;
        double eyy = (t1 - t2 - t3)/sqrt(p3p1i);
        [ey addObject:[NSNumber numberWithDouble:eyy]];
    }
    
    
    // ez = numpy.cross(ex,ey)
    // if 2-dimensional vector then ez = 0
    NSMutableArray *ez = [[NSMutableArray alloc] initWithCapacity:0];
    double ezx;
    double ezy;
    double ezz;
    if ([P1 count] !=3)
    {
        ezx = 0;
        ezy = 0;
        ezz = 0;
    }
    else
    {
        ezx = ([[ex objectAtIndex:1] doubleValue]*[[ey objectAtIndex:2]doubleValue]) - ([[ex objectAtIndex:2]doubleValue]*[[ey objectAtIndex:1]doubleValue]);
        ezy = ([[ex objectAtIndex:2] doubleValue]*[[ey objectAtIndex:0]doubleValue]) - ([[ex objectAtIndex:0]doubleValue]*[[ey objectAtIndex:2]doubleValue]);
        ezz = ([[ex objectAtIndex:0] doubleValue]*[[ey objectAtIndex:1]doubleValue]) - ([[ex objectAtIndex:1]doubleValue]*[[ey objectAtIndex:0]doubleValue]);
    }
    
    [ez addObject:[NSNumber numberWithDouble:ezx]];
    [ez addObject:[NSNumber numberWithDouble:ezy]];
    [ez addObject:[NSNumber numberWithDouble:ezz]];
    
    
    // d = numpy.linalg.norm(P2 - P1)
    double d = sqrt(temp);
    
    // j = dot(ey, P3 - P1)
    double jval = 0;
    for (int i = 0; i < [ey count]; i++) {
        double t1 = [[ey objectAtIndex:i] doubleValue];
        double t2 = [[p3p1 objectAtIndex:i] doubleValue];
        jval += (t1*t2);
    }
    
    // x = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d)
    double xval = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d);
    
    // y = ((pow(DistA,2) - pow(DistC,2) + pow(i,2) + pow(j,2))/(2*j)) - ((i/j)*x)
    double yval = ((pow(DistA,2) - pow(DistC,2) + pow(ival,2) + pow(jval,2))/(2*jval)) - ((ival/jval)*xval);
    
    // z = sqrt(pow(DistA,2) - pow(x,2) - pow(y,2))
    // if 2-dimensional vector then z = 0
    double zval;
    if ([P1 count] !=3)
    {
        zval = 0;
    }
    else
    {
        zval = sqrt(pow(DistA,2) - pow(xval,2) - pow(yval,2));
    }
    
    // triPt = P1 + x*ex + y*ey + z*ez
    NSMutableArray *triPt = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [P1 count]; i++)
    {
        double t1 = [[P1 objectAtIndex:i] doubleValue];
        double t2 = [[ex objectAtIndex:i] doubleValue] * xval;
        double t3 = [[ey objectAtIndex:i] doubleValue] * yval;
        double t4 = [[ez objectAtIndex:i] doubleValue] * zval;
        double triptx = t1+t2+t3+t4;
        [triPt addObject:[NSNumber numberWithDouble:triptx]];
    } 
    
    return CoordinateMake([triPt[0] doubleValue], [triPt[1] doubleValue], 0);
}



@end
