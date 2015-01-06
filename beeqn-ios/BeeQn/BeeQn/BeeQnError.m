//
// Created by Wolf Posdorfer on 10.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BeeQnError.h"


@interface BeeQnError ()
@property (nonatomic, retain, readwrite) NSString* locDec;
@end


@implementation BeeQnError

+ (BeeQnError*)errorWith:(int)code message:(NSString*)message
{
    BeeQnError* error = [[BeeQnError alloc] initWithDomain:@"beeqn" code:code userInfo:nil];
    error.locDec = message;
    return error;
}


-(NSString *)localizedDescription
{
    return self.locDec;
}

@end

