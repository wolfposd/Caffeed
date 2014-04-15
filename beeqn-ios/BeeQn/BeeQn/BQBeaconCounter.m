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
    
    if(val != 0)
        return val;
    else
        return NSIntegerMin;
}
@end



@interface BQBeaconCounter()

@property (nonatomic, retain) NSMutableDictionary* beaconsCount;
@property (nonatomic, retain) NSMutableSet* beacons;


@end



@implementation BQBeaconCounter

- (id)init
{
    self = [super init];
    if (self) {
        self.beaconsCount = [NSMutableDictionary new];
        self.beacons = [NSMutableSet new];
    }
    return self;
}



-(void) resetCount
{
    [self.beaconsCount removeAllObjects];
    [self.beacons removeAllObjects];
}

-(NSString*) makeIdent:(BQBeacon*) beacon
{
    return  [NSString stringWithFormat:@"%@%@%@",beacon.UUID, beacon.major, beacon.minor];
}

-(void) increaseCountFor:(NSArray*) beacons
{
    [self.beacons addObjectsFromArray:beacons];
    
    for (BQBeacon* beacon in beacons)
    {
        [self increaseCount:beacon];
    }
}

-(void) increaseCount:(BQBeacon*) beacon
{
    NSString* ident = [self makeIdent:beacon];
    Count* count = [self.beaconsCount objectForKey:ident];
    
    if(!count)
    {
        count = [Count new];
        [self.beaconsCount setValue:count forKey:ident];
    }
    
    BQBeacon* reference = [self.beacons member:beacon];
    if(reference)
    {
        // make sure that the Reference inside the SET contains the latest RSSI,proxi,accuracy values
        [reference updateValuesFrom:beacon];
    }
    
    if(beacon.rssi != 0)
    {
        [count.rssiValues addObject:[NSNumber numberWithInteger:beacon.rssi]];
    }
    
}

-(BQBeacon*) closestBeaconFrom:(NSArray*) beacons
{
    BQBeacon* closest = nil;
    NSInteger distance = NSIntegerMin;
    
    for (BQBeacon* beacon in beacons)
    {
        NSString* ident = [self makeIdent:beacon];
        Count* c = [self.beaconsCount objectForKey:ident];
        
        NSInteger mean = c.meanRSSI;
        if(c && mean > distance && mean != 0)
        {
            closest = beacon;
            distance = mean;
        }
    }
    
    return closest;
}

-(BQBeacon*) closestBeacon
{
    BQBeacon* closest = nil;
    NSInteger distance = NSIntegerMin;
    
    for (BQBeacon* beacon in self.beacons)
    {
        NSString* ident = [self makeIdent:beacon];
        Count* c = [self.beaconsCount objectForKey:ident];
        
        NSInteger mean = c.meanRSSI;
        if(c && mean > distance && mean != 0)
        {
            closest = beacon;
            distance = mean;
        }
    }
    
    return closest;
}

-(NSInteger) meanRSSI:(BQBeacon*) beacon
{
    Count* count = [self.beaconsCount objectForKey:[self makeIdent:beacon]];
    
    if(count)
    {
        return count.meanRSSI;
    }
    return NSIntegerMin;
}


@end
