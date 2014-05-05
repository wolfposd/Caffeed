//
//  DrawingClass.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 05.05.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "DrawingClass.h"

@implementation DrawingClass

+(UIImage*) image:(UIImage*) image drawPositionOfBeacon:(Coordinate) coordinate
{
    return [self image:image drawPositionOfBeacon:coordinate color:[UIColor redColor]];
}


+(UIImage*) image:(UIImage*) image drawPositionOfBeacon:(Coordinate) coordinate color:(UIColor*) color
{
    return [self drawEllipseOnImage:image withCoordinate:CoordinateMake(coordinate.x, coordinate.y, 5) andColor:color];
}


+(UIImage*) image:(UIImage*) image drawDistanceCircleOfBeacon:(Coordinate) coordinate
{
    return [self drawEllipseOnImage:image withCoordinate:coordinate andColor:[UIColor blueColor]];
}

+(UIImage*) image:(UIImage*) image drawDistanceCircleOfBeacon:(Coordinate) coordinate color:(UIColor*) color
{
   return [self drawEllipseOnImage:image withCoordinate:coordinate andColor:color];
}

+(UIImage*) image:(UIImage *)image drawPointOnImage:(Coordinate) coordinate color:(UIColor*) color
{
    return [self drawFilledEllipseOnImage:image withCoordinate:coordinate andColor:color];
}

/**
 *  Draws an ellipse with coordinate and color
 *
 *  @param image       image to draw on
 *  @param coord       coordinate where to draw, distance being the radius
 *  @param circleColor the color
 *
 *  @return the image
 */
+(UIImage *) drawEllipseOnImage:(UIImage*) image withCoordinate:(Coordinate) coord andColor:(UIColor*) circleColor
{
    int width = image.size.width;
    int height = image.size.height;
    
    UIGraphicsBeginImageContext(image.size);
    
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
    }
    
	CGContextTranslateCTM(context, 0, image.size.height);
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return retImage;
}

+(UIImage *) drawFilledEllipseOnImage:(UIImage*) image withCoordinate:(Coordinate) coord andColor:(UIColor*) circleColor
{
    int width = image.size.width;
    int height = image.size.height;
    
    UIGraphicsBeginImageContext(image.size);
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    
    if(coord.x >= 0 && coord.x < width && coord.y >= 0 && coord.y < height)
    {
        int x = coord.x - coord.distance/2;
        int y = coord.y + coord.distance/2;
        
        CGRect circleRect = CGRectMake(x, height - y, coord.distance, coord.distance);
        CGContextSetFillColorWithColor(context, circleColor.CGColor);
        CGContextFillEllipseInRect(context, circleRect);
    }
    
	CGContextTranslateCTM(context, 0, image.size.height);
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return retImage;
    
}

@end
