//
// Created by Wolf Posdorfer on 10.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BeeQnError : NSError

+ (BeeQnError*)errorWith:(int)code message:(NSString*)message;

@end