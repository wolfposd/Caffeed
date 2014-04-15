//
// Created by Wolf Posdorfer on 15.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BQAlert : NSObject


+ (id)showAlert:(NSString*)title message:(NSString*)message action:(void (^)(NSInteger))block
cancelButtonTitle:(NSString*)cancel others:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end