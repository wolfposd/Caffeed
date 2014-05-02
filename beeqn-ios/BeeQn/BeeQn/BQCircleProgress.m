//
//  BQCircleProgress.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 15.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BQCircleProgress.h"
#import <CoreText/CoreText.h>
#define PI_TIMES_2  6.28318530717958647692528676655900576

@interface BQCircleProgress ()

@property (nonatomic) int maximum;
@property (nonatomic) int current;

@end

@implementation BQCircleProgress

- (void)colorsInitialize {
    self.backgroundColor = [UIColor clearColor];
    
    self.circleColor = CIRCLE_COLOR_DEFAULT;
    self.circleBackgroundColor = CIRCLE_BACKGROUND_COLOR_DEFAULT;
    self.circleWidth = CIRCLE_WIDTH_DEFAULT;
    self.showProgressText = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self colorsInitialize];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self colorsInitialize];
    }
    
    return self;
}


-(void) update
{
    [self setNeedsDisplay];
}

-(void) setCurrentValue:(int)current maximumValue:(int) max update:(BOOL) update
{
    self.current = current;
    self.maximum = max;
    
    if(update)
    {
        [self update];
    }
}

-(int) currentValue
{
    return self.current;
}
-(int) maximumValue
{
    return self.maximum;
}

-(void)setCurrentValue:(int) current
{
    self.current = current;
}

-(void) setMaximumValue:(int)max
{
    self.maximum = max;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    float radius = CGRectGetWidth(rect)/2.0f - self.circleWidth/2.0f;
    float angleOffset = M_PI_2;
    
    // Background
    CGContextSetLineWidth(context, self.circleWidth);
    CGContextBeginPath(context);
    CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), radius, 0, PI_TIMES_2, 0);
    CGContextSetStrokeColorWithColor(context, [self.circleBackgroundColor CGColor]);
    CGContextStrokePath(context);
    
    // Progress
    CGContextSetLineWidth(context, self.circleWidth);
    CGContextBeginPath(context);
    CGFloat startWinkel = (((CGFloat)self.current) / ((CGFloat)self.maximum) * PI_TIMES_2 - angleOffset);
    CGFloat endWinkel = PI_TIMES_2 - angleOffset;
    CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), radius, startWinkel,  endWinkel, 0);
    CGContextSetStrokeColorWithColor(context, [self.circleColor CGColor]);
    CGContextStrokePath(context);
    
    
    if(self.showProgressText)
    {
        CGAffineTransform transform;
        transform = CGAffineTransformConcat(CGContextGetTextMatrix(context),
                                            CGAffineTransformMake(1.0, 0.0, 0.0,
                                                                  -1.0, 0.0, 0.0));
        CGContextSetTextMatrix(context, transform);
        NSString* string = [NSString stringWithFormat:@"%d/%d",self.current, self.maximum];
        
        
        CTFontRef fontRef=CTFontCreateWithName((CFStringRef)@"Impact", 20.0f, NULL);
        CGColorRef color=[UIColor blackColor].CGColor;
        NSDictionary *attrDictionary=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef, (id)kCTFontAttributeName,
                                      color, (id)kCTForegroundColorAttributeName,  nil];
        
        NSAttributedString *stringToDraw=[[NSAttributedString alloc] initWithString:string attributes:attrDictionary];
        
        
        
        CGRect titleSize = [stringToDraw boundingRectWithSize:CGSizeMake(300.f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        
        
        CTLineRef line=CTLineCreateWithAttributedString((CFAttributedStringRef)stringToDraw);
        CGContextSetTextPosition(context, self.frame.size.width / 2 - titleSize.size.width/2 , self.frame.size.height/2 + 7);
        CTLineDraw(line, context);
        
        CFRelease(line);
        CFRelease(fontRef);
    }
}


@end
