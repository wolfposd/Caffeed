//
//  BorderButton.m
//  Underwriter
//
//  Created by Wolf Posdorfer on 24.01.14.
//
//

#import "BorderButton.h"

@implementation BorderButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.layer.borderWidth = 1;
    self.layer.borderColor = self.titleLabel.textColor.CGColor; //[UIColor blueColor].CGColor;
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}


@end
