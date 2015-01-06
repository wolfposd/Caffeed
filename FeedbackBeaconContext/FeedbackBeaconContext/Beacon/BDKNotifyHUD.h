//
//  BDKNotifyHUD.h
//  iSturesy
//
//  Created by Wolf Posdorfer on 10.03.13.
//  Copyright (c) 2013 Wolf Posdorfer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBDKNotifyHUDDefaultWidth 130.0f
#define kBDKNotifyHUDDefaultHeight 100.0f

/**
 *  Notify HUD
 */
@interface BDKNotifyHUD : UIView

@property (nonatomic) CGFloat destinationOpacity;
@property (nonatomic) CGFloat currentOpacity;
@property (nonatomic) UIView *iconView;
@property (nonatomic) CGFloat roundness;
@property (nonatomic) BOOL bordered;
@property (nonatomic) BOOL isAnimating;

@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) NSString *text;

+ (id)notifyHUDWithView:(UIView *)view text:(NSString *)text;
+ (id)notifyHUDWithView:(UIView *)view text:(NSString *)text frame:(CGRect) frame;

+ (id)notifyHUDWithImage:(UIImage *)image text:(NSString *)text;
+ (id)notifyHUDWithImage:(UIImage *)image text:(NSString *)text frame:(CGRect) frame;


+ (id)notifyHUDWithText:(NSString*) text;

- (id)initWithView:(UIView *)view text:(NSString *)text;
- (id)initWithImage:(UIImage *)image text:(NSString *)text;
- (id)initWithImage:(UIImage *)image text:(NSString *)text frame:(CGRect) frame;

- (void)setImage:(UIImage *)image;

/**
 *  Presents a hud with a given duration
 *
 *  @param duration   duration to present
 *  @param speed      speed in seconds for fade/present
 *  @param completion block executed after completion
 */
- (void)presentWithDuration:(CGFloat)duration speed:(CGFloat)speed completion:(void (^)(void))completion;

/**
 *  Align the HUD centering in given view
 *
 *  @param superView center hud here
 */
-(void) centerHUD:(UIView*) superView;

/**
 *  Presents the HUD with given speed
 *
 *  @param speed      speed in seconds
 *  @param completion block executed after completion
 */
-(void) presentWithSpeed:(CGFloat) speed onCompletion:(void (^)(void))completion;

/**
 *  Fade the HUD with given speed
 *
 *  @param speed      speed in seconds
 *  @param completion block executed after completion
 */
-(void) fadeWithSpeed:(CGFloat) speed onCompletion:(void (^)(void))completion;

@end