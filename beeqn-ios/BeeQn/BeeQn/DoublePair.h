//
//  DoublePair.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 05.05.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoublePair : NSObject

@property (nonatomic) double xValue;
@property (nonatomic) double yValue;

+(instancetype) doublePairX:(double)x Y:(double)y;

@end
