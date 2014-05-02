//
//  BQCircleProgress.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 15.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CIRCLE_COLOR_DEFAULT [UIColor blueColor]
#define CIRCLE_BACKGROUND_COLOR_DEFAULT [UIColor lightGrayColor]
#define CIRCLE_WIDTH_DEFAULT 8.0f


@interface BQCircleProgress : UIView


/// The color of the circle indicating the remaining amount of time - default is CIRCLE_COLOR_DEFAULT.
@property (nonatomic, strong) UIColor *circleColor;

/// The color of the circle indicating the expired amount of time - default is CIRCLE_BACKGROUND_COLOR_DEFAULT.
@property (nonatomic, strong) UIColor *circleBackgroundColor;

/// The thickness of the circle color - default is CIRCLE_WIDTH_DEFAULT.
@property (nonatomic, assign) CGFloat circleWidth;

/**
 *  The Progresstext - default ist TRUE
 */
@property (nonatomic) BOOL showProgressText;

-(int) currentValue;
-(int) maximumValue;

-(void) setMaximumValue:(int) max;

-(void) setCurrentValue:(int) current;

-(void) setCurrentValue:(int) current maximumValue:(int) max update:(BOOL) update;

-(void) update;

@end
