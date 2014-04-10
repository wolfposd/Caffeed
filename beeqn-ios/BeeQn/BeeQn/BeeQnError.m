//
// Created by Wolf Posdorfer on 10.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BeeQnError.h"


@interface BeeQnError ()
@property (nonatomic, retain) NSString* localizedDescription;
@end


@implementation BeeQnError

+ (BeeQnError*)errorWith:(int)code message:(NSString*)message
{
    BeeQnError* error = [[BeeQnError alloc] initWithDomain:@"beeqn" code:code userInfo:nil];
    error.localizedDescription = message;
    return error;
}

@end

