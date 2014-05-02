//
//  BQBeacon.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 15.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BQBeacon.h"

@interface BQBeacon()
@property (nonatomic,retain, readwrite) NSString* UUID;
@property (nonatomic,retain, readwrite) NSNumber* major;
@property (nonatomic,retain, readwrite) NSNumber* minor;
@property (nonatomic, readwrite) BQProximity proximity;
@property (nonatomic, readwrite) double accuracy;
@property (nonatomic, readwrite) NSInteger rssi;
@end


@implementation BQBeacon



+(id) beacon:(CLBeacon*)beacon
{
    return [self beacon:beacon.proximityUUID.UUIDString major:beacon.major minor:beacon.minor proximity:beacon.proximity accuracy:beacon.accuracy rssi:beacon.rssi];
}

+(id) beacon:(NSString*) uuid major:(NSNumber*) major minor:(NSNumber*) minor proximity:(CLProximity) prox accuracy:(double) accuracy rssi:(NSInteger) rssi
{
    
    BQBeacon* result =[BQBeacon new];
    
    result.UUID = uuid;
    result.major = major;
    result.minor = minor;
    result.proximity = (BQProximity)prox;
    result.accuracy = accuracy;
    result.rssi = rssi;
    
    return result;
}

-(void) updateValuesFrom:(BQBeacon*) thisBeacon
{
    self.rssi = thisBeacon.rssi;
    self.proximity = thisBeacon.proximity;
    self.accuracy = thisBeacon.accuracy;
}

-(NSString *) distance
{
    switch(self.proximity)
    {
        case BQProximityUnknown: return @"Unknown";
        case BQProximityFar: return @"Far";
        case BQProximityImmediate : return @"Immediate";
        case BQProximityNear : return @"Near";
        default: return @"Unknown";
    }
}
-(void) updateMeanRSSI:(NSInteger) meanRSSI meanAccuracy:(double) meanAccuracy
{
    self.rssi = meanRSSI;
    self.accuracy = meanAccuracy;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<BQBeacon %@,%@,%@, prox:%@, accuracy:%f", self.UUID,self.major,self.minor, [self distance], self.accuracy];
}

-(BOOL)isEqual:(id)object
{
    @try
    {
        if ([[object class] isSubclassOfClass:[BQBeacon class]])
        {
            BQBeacon* beacon = object;
            BOOL result = [self.UUID isEqualToString:beacon.UUID]
            && [self.minor isEqualToNumber:beacon.minor]
            && [self.major isEqualToNumber:beacon.major];
            
            return result;
        }
    }
    @catch (NSException* exception)
    {
        return false;
    }
    return false;
}

-(NSUInteger)hash
{
    return self.UUID.hash;
}

@end
