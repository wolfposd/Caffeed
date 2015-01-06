//
//  DrawingClass.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 05.05.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trilateration.h"

/**
 *  Provides drawing mechanisms on Images
 */
@interface DrawingClass : NSObject



/**
 *  Draws all possible matching positions on an image
 *
 *  @param image   image to draw on
 *  @param arrayOfBCCoordinate the array of BCCoordinates
 *
 *  @return modified image
 */
+(UIImage*) image:(UIImage*) image drawAllPossibleLocationsOnImage:(NSArray*) arrayOfBCCoordinate;



/**
 *  Draws a red little circle on the image
 *
 *  @param image      the image to draw on
 *  @param coordinate the position to draw at, will ignore distance
 *
 *  @return the modified image
 */
+(UIImage*) image:(UIImage*) image drawPositionOfBeacon:(Coordinate) coordinate;


+(UIImage*) image:(UIImage*) image drawPositionOfBeacon:(Coordinate) coordinate color:(UIColor*) color;

/**
 *  Draws a point on an image
 *
 *  @param image      image
 *  @param coordinate coordinate, distance beeing radius of circle
 *  @param color      color
 *
 *  @return modified image
 */
+(UIImage*) image:(UIImage *)image drawPointOnImage:(Coordinate) coordinate color:(UIColor*) color;

/**
 *  Draws a blue circle around the given x,y coordinate
 *
 *  @param image      image to draw on
 *  @param coordinate coordinate
 *
 *  @return the modified image
 */
+(UIImage*) image:(UIImage*) image drawDistanceCircleOfBeacon:(Coordinate) coordinate;

/**
 *  Draws a circle around fiven x,y coordinate with given color and distance as radius
 *
 *  @param image      image to draw on
 *  @param coordinate coordinate to draw at
 *  @param color      color of circle
 *
 *  @return modified image
 */
+(UIImage*) image:(UIImage*) image drawDistanceCircleOfBeacon:(Coordinate) coordinate color:(UIColor*) color;


/**
 *  Draws a rectangle
 *
 *  @param image     image to draw on
 *  @param rectangle coordinates to use
 *
 *  @return modified image
 */
+(UIImage*) image:(UIImage*) image drawRectangle:(CGRect) rectangle;
+(UIImage*) image:(UIImage*) image drawRectangle:(CGRect) rectangle width:(float) width;
+(UIImage*) image:(UIImage*) image drawRectangle:(CGRect) rectangle width:(float) width color:(UIColor*) color;

@end
