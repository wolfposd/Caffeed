//
//  main.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 09.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char* argv[])
{
    @autoreleasepool
    {
        int retval;
        @try
        {
            retval = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException* exception)
        {
            NSLog(@"BOOM! %@", [exception callStackSymbols]);
            @throw;
        }
        return retval;


        //@autoreleasepool {
        //    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        //}
    }
}