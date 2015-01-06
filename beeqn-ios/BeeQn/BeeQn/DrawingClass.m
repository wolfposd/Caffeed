//
//  DrawingClass.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 05.05.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "DrawingClass.h"
#import "BCCoordinate.h"

@implementation DrawingClass



+(NSArray*) matchingCoordinates:(NSArray*) arrayOfBCCoordinates inImage:(UIImage* ) image;
{
    int width = image.size.width;
    int height = image.size.height;
    
    NSMutableArray* result = [NSMutableArray new];
    
//    if(true)
//    {
//        BOOL isBetween = YES;
//        int x = 270;
//        int y = 265;
//        for(BCCoordinate* cc in arrayOfBCCoordinates)
//        {
//            if(![cc isBetweenDistancesX:x Y:y])
//            {
//                isBetween = NO;
//                NSLog(@"%@ %@", @"is not between", cc);
//                
//            }
//            NSLog(@"%@", @"\n");
//        }
//        if(isBetween)
//        {
//            NSLog(@"%@", @"IS BETWEEN FINALLY");
//        }
//        else
//        {
//            NSLog(@"%@", @"is not between");
//        }
//    }
//    
//    return result;
    
    
    
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
    
    NSLog(@"matching coordinates count: %lu", result.count);
    
    return result;
}


+(UIImage *)image:(UIImage *)image drawAllPossibleLocationsOnImage:(NSArray *)arrayOfBCCoordinate
{
    int width = image.size.width;
    int height = image.size.height;
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    
    for(BCCoordinate* cc in arrayOfBCCoordinate)
    {
        CGContextFillRect(context, CGRectMake(cc.x, height - cc.y, 2, 2));
    }
    
    CGContextTranslateCTM(context, 0, image.size.height);
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}


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
        int x = coord.x - coord.distance;
        int y = coord.y + coord.distance;
        
        CGRect circleRect = CGRectMake(x, height - y, coord.distance*2, coord.distance*2);
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
        int x = coord.x - coord.distance;
        int y = coord.y + coord.distance;
        
        CGRect circleRect = CGRectMake(x, height - y, coord.distance*2, coord.distance*2);
        CGContextSetFillColorWithColor(context, circleColor.CGColor);
        CGContextFillEllipseInRect(context, circleRect);
    }
    
    CGContextTranslateCTM(context, 0, image.size.height);
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
    
}


+(UIImage*) image:(UIImage*) image drawRectangle:(CGRect) rectangle
{
    return [self image:image drawRectangle:rectangle width:1 color:[UIColor blackColor]];
}

+(UIImage*) image:(UIImage*) image drawRectangle:(CGRect) rectangle width:(float) width;
{
    return [self image:image drawRectangle:rectangle width:width color:[UIColor blackColor]];
}

+(UIImage*) image:(UIImage*) image drawRectangle:(CGRect) rectangle width:(float) width color:(UIColor*) color
{
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, imageHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    rectangle.origin.y = imageHeight - rectangle.origin.y;
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextStrokeRectWithWidth(context, rectangle, width);
    
    
    CGContextTranslateCTM(context, 0, image.size.height);
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

@end
