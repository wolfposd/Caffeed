//
//  PSBorderButton.m
//  ProScan
//
//  Created by Wolf Posdorfer on 13.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "PSBorderButton.h"

@implementation PSBorderButton

- (void)drawRect:(CGRect)rect
{
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = self.titleLabel.textColor.CGColor; //[UIColor blueColor].CGColor;
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}
@end
