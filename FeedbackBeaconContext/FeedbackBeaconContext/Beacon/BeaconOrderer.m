//
//  BeaconOrderer.m
//  FeedbackBeaconContext
//
//  Created by Wolf Posdorfer on 29.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BeaconOrderer.h"

#import "FileLog.h"

@interface BeaconOrderer ()

@property (nonatomic,strong) NSMutableArray* beacons;

@end

@implementation BeaconOrderer


- (instancetype)init
{
    self = [super init];
    if (self) {
        _beacons = [NSMutableArray new];
    }
    return self;
}


-(void)addBeacon:(BCBeacon *)beacon
{
    BCBeacon* lastObject = self.beacons.lastObject;
    
    if(lastObject)
    {
        if(lastObject.type == BCBeaconSeenTypeEnter && beacon.type == BCBeaconSeenTypeExit)
        {
            [FileLog log:[NSString stringWithFormat:@"1:Adding Beacon %@", beacon.name]];
            [self.beacons addObject:beacon];
        }
        else if(beacon.type == BCBeaconSeenTypeEnter)
        {
            [FileLog log:[NSString stringWithFormat:@"2:Adding Beacon %@", beacon.name]];
            [self.beacons addObject:beacon];
        }
        else
        {
            [FileLog log:[NSString stringWithFormat:@"NOT ADDING 1:Beacon %@", beacon.name]];
            [FileLog log: beacon.description];
        }
    }
    else if(beacon.type == BCBeaconSeenTypeEnter)
    {
        [FileLog log:[NSString stringWithFormat:@"3:Adding Beacon %@ ", beacon.name]];
        [self.beacons addObject:beacon];
    }
    else
    {
        [FileLog log:[NSString stringWithFormat:@"NOT ADDING 2:Beacon %@", beacon.name]];
        [FileLog log: beacon.description];
    }
}

-(NSArray*) savedBeacons
{
    return self.beacons;
}



-(int)amountOfBeaconEnters
{
    return [self amountOfBeaconType:BCBeaconSeenTypeEnter];
}

-(int)amountOfBeaconExits
{
    return [self amountOfBeaconType:BCBeaconSeenTypeExit];
}

-(int) amountOfBeaconType:(BCBeaconSeenType) type
{
    int amount = 0;
    for(BCBeacon* beacon in self.beacons)
    {
        if(beacon.type == type)
        {
            amount++;
        }
    }
    return amount;
}

-(void) clear
{
    [self.beacons removeAllObjects];
}


@end
