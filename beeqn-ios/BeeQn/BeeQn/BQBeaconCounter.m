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
@property (nonatomic, retain) NSMutableArray* accuracyValues;
@end

@implementation Count : NSObject
- (id)init
{
    self = [super init];
    if (self)
    {
        self.rssiValues = [NSMutableArray new];
        self.accuracyValues = [NSMutableArray new];
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

-(double) meanAccuracy
{
    double val = 0;
    for (NSNumber* number in self.accuracyValues)
    {
        val = val + number.doubleValue;
    }
    val =  val / [NSNumber numberWithUnsignedInteger:self.accuracyValues.count].integerValue;
    return val;
}
@end

#pragma mark - BQBeaconCounter

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

- (NSUInteger) count
{
    return self.beacons.count;
}

-(NSSet *)allBeacons
{
    return self.beacons;
}

-(NSArray*) allBeaconsSorted
{
    return [self.beacons sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"rssi" ascending:YES]]];
}

-(void) resetCount
{
    [self.beaconsCount removeAllObjects];
    [self.beacons removeAllObjects];
}
/**
 *  Creates an identification for use in dictionary
 *
 *  @param beacon Beacon
 *
 *  @return Identification String
 */
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
    
    if(beacon.rssi != 0)
    {
        [count.rssiValues addObject:[NSNumber numberWithInteger:beacon.rssi]];
        
        NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
        
        [count.rssiValues sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        
        if(beacon.accuracy != NAN )
        {
            [count.accuracyValues addObject:[NSNumber numberWithDouble:beacon.accuracy]];
            [count.accuracyValues sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        }
    }
    
    BQBeacon* reference = [self.beacons member:beacon];
    if(reference)
    {
        // make sure that the Reference inside the SET contains the mean values
        [reference updateMeanRSSI:[count meanRSSI] meanAccuracy:[count meanAccuracy]];
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
        if(c && mean > distance && mean != 0 && mean > -500)
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
        if(c && mean > distance && mean != 0 && mean > -500)
        {
            closest = beacon;
            distance = mean;
        }
    }
    
    return closest;
}

-(BQBeacon *)mostAccurateBeacon
{
    double distance = 100000;
    BQBeacon* closest = nil;
    
    for(BQBeacon* beacon in self.beacons)
    {
        NSString* ident = [self makeIdent:beacon];
        Count* c = [self.beaconsCount objectForKey:ident];
        
        double acc = c.meanAccuracy;
        if(c != nil && acc < distance)
        {
            closest = beacon;
            distance = acc;
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

-(double) meanAccuracy:(BQBeacon*) beacon
{
    Count* count = [self.beaconsCount objectForKey:[self makeIdent:beacon]];
    if(count)
    {
        return count.meanAccuracy;
    }
    return DBL_MAX;
}



-(BQBeacon*) findBeaconWithInfo:(BQBeacon*) beacon
{
    Count* count = [self.beaconsCount objectForKey:[self makeIdent:beacon]];
    if(count)
    {
        return [self.beacons member:beacon];
    }
    else
    {
        return nil;
    }
}

-(NSArray*) findBeaconsAccuracyValues:(BQBeacon*) beacon
{
    Count* count = [self.beaconsCount objectForKey:[self makeIdent:beacon]];
    if(count)
    {
        return count.accuracyValues;
    }
    else
    {
        return nil;
    }
}

-(NSArray*) findBeaconsRSSIValues:(BQBeacon*) beacon
{
    Count* count = [self.beaconsCount objectForKey:[self makeIdent:beacon]];
    if(count)
    {
        return count.rssiValues;
    }
    else
    {
        return nil;
    }
}


@end
