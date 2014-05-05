//
//  DoublePair.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 05.05.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "DoublePair.h"

@implementation DoublePair

+(instancetype) doublePairX:(double)x Y:(double)y
{
    DoublePair* dp = [[DoublePair alloc] init];
    dp.xValue = x;
    dp.yValue = y;
    return dp;
}


- (BOOL)isEqual:(id)other
{
    if (other == self)
    {
        return YES;
    }
    else if ([[other class] isSubclassOfClass:[self class]])
    {
        DoublePair* otherP = other;
        BOOL xsame = (int)self.xValue == (int)otherP.xValue;
        BOOL ysame = (int)self.yValue == (int)otherP.yValue;
       
        return xsame && ysame;
    }
    else
    {
        return NO;
    }
}

- (NSUInteger)hash
{
    return (NSUInteger) self.xValue;
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"%d %d", (int)self.xValue, (int)self.yValue];
}

@end
