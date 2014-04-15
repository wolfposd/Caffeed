//
//  BQBeaconCounter.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 15.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BQBeaconCounter.h"

@interface Count : NSObject
@property (nonatomic, retain) NSMutableArray* rssiValues;
@end

@implementation Count : NSObject
- (id)init
{
    self = [super init];
    if (self)
    {
        self.rssiValues = [NSMutableArray new];
    }
    return self;
}

-(NSInteger) meanRSSI
{
    NSInteger val = 0;
    for (NSNumber* number in self.rssiValues)
    {
        val = val + number.integerValue;
    }
    
    val =  val / [NSNumber numberWithUnsignedInteger:self.rssiValues.count].integerValue;
    return val;
}
@end



@interface BQBeaconCounter()

@property (nonatomic, retain) NSMutableDictionary* beaconsCount;


@end



@implementation BQBeaconCounter

- (id)init
{
    self = [super init];
    if (self) {
        self.beaconsCount = [NSMutableDictionary new];
    }
    return self;
}

-(void) resetCount
{
    self.beaconsCount = [NSMutableDictionary new];
}

-(NSString*) makeIdent:(CLBeacon*) beacon
{
    return  [NSString stringWithFormat:@"%@%@%@",beacon.proximityUUID.UUIDString, beacon.major, beacon.minor];
}


-(void) increaseCountFor:(NSArray*) beacons
{
    for (CLBeacon* beacon in beacons)
    {
        [self increaseCount:beacon];
    }
}

-(void) increaseCount:(CLBeacon*) beacon
{
    NSString* ident = [self makeIdent:beacon];
    Count* count = [self.beaconsCount objectForKey:ident];
    
    if(!count)
    {
        NSLog(@"%@", @"Adding count object");
        count = [Count new];
        [self.beaconsCount setValue:count forKey:ident];
    }
    
    if(beacon.rssi != 0)
    {
        [count.rssiValues addObject:[NSNumber numberWithInteger:beacon.rssi]];
    }
    
}

-(CLBeacon*) closestBeaconFrom:(NSArray*) beacons
{
    CLBeacon* closest = nil;
    NSInteger distance = NSIntegerMin;
    
    for (CLBeacon* beacon in beacons)
    {
        NSString* ident = [self makeIdent:beacon];
        Count* c = [self.beaconsCount objectForKey:ident];
        
        NSInteger mean = c.meanRSSI;
        if(c && mean > distance && mean != 0)
        {
            closest = beacon;
            distance = mean;
            NSLog(@"%@", @"set new closest");
        }
    }
    
    return closest;
}

-(NSInteger) meanRSSI:(CLBeacon*) beacon
{
    Count* count = [self.beaconsCount objectForKey:[self makeIdent:beacon]];
    
    if(count)
    {
        return count.meanRSSI;
    }
    return NSIntegerMin;
}


@end
