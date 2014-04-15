//
// Created by Wolf Posdorfer on 15.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BQAlert.h"


@interface BQAlert () <UIAlertViewDelegate>

@property (copy) void (^block)(NSInteger);
@property (nonatomic, retain) UIAlertView* alert;

@end

@implementation BQAlert


+ (id)showAlert:(NSString*)title message:(NSString*)message action:(void (^)(NSInteger))block cancelButtonTitle:(NSString*)cancel
           others:(NSString*)otherButtonTitles, ...
{
    BQAlert* bqalert = [BQAlert new];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:bqalert cancelButtonTitle:cancel
                                          otherButtonTitles:otherButtonTitles,nil];

    bqalert.alert = alert;

    bqalert.block = block;

    [alert show];
    
    return bqalert;
}


- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@", @"ATTACK");
    if (self.block)
    {
        self.block(buttonIndex);
    }
}


@end