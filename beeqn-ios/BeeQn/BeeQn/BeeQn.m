//
//  BeeQn.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 24.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BeeQn.h"

@implementation BeeQn

-(instancetype) initWith:(NSObject<BeeQnLocationManagerProtocol,BeeQnServiceProtocol>*) delegate
{
    self = [super init];
    if(self)
    {
        self.serviceManager = [[BeeQnService alloc] init];
        self.locatioManager = [[BeeQnLocationManager alloc] init];
        
        self.serviceManager.delegate = delegate;
        self.locatioManager.delegate = delegate;
    }
    return self;
}


@end
