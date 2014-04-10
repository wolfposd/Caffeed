//
//  CLBeacon+Equals.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 10.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "CLBeacon+Equals.h"

@implementation CLBeacon (Equals)


- (BOOL)isEqualToBeacon:(id)other
{
    @try
    {
        if ([[other class] isSubclassOfClass:[self class]])
        {
            CLBeacon* beacon = other;


            return [self.proximityUUID.UUIDString isEqualToString:beacon.proximityUUID.UUIDString]
                    && [self.minor isEqualToNumber:beacon.minor]
                    && [self.major isEqualToNumber:beacon.major];

        }
    }
    @catch (NSException* exception)
    {
        return false;
    }


    return false;
}


@end
