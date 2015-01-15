//
//  BCBeacon.m
//  BeaconContext
//
//  Created by Wolf Posdorfer on 28.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BCBeacon.h"

@interface BCBeacon ()

@property (nonatomic,readwrite,strong) NSString* uuid;
@property (nonatomic,readwrite,strong) NSNumber* major;
@property (nonatomic,readwrite,strong) NSNumber* minor;
@property (nonatomic,readwrite,strong) NSDate* seen;
@property (nonatomic,readwrite) BCBeaconSeenType type;
@end



@implementation BCBeacon


+(BCBeacon*) beaconWith:(NSString*) uuid major:(NSNumber*) major minor:(NSNumber*) minor
{
   return [self beaconWith:uuid major:major minor:minor seen:[NSDate date] type:BCBeaconSeenTypeUnknown];
}

+(BCBeacon*) beaconWith:(NSString*) uuid major:(NSNumber*) major minor:(NSNumber*) minor seen:(NSDate*) seen type:(BCBeaconSeenType) type
{
    BCBeacon* b = [[BCBeacon alloc] init];
    
    b.uuid = uuid;
    
    b.major = major;
    if(!b.major)
    {
        b.major = [NSNumber numberWithInt:0];
    }
    
    b.minor = minor;
    if(!b.minor)
    {
        b.minor = [NSNumber numberWithInt:0];
    }
    
    b.type = type;
    b.seen = seen;
    return b;
}



-(NSString *)seenNormalized
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:self.seen];
}

-(NSString *)typeNormalized
{
    switch(self.type)
    {
        case BCBeaconSeenTypeEnter: return @"enter";
        case BCBeaconSeenTypeExit: return @"exit";
        default:
        case BCBeaconSeenTypeUnknown: return @"unknown";
    }
}


-(NSString*) uuidNormalized
{
    return [self.uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"Beacon: %@-%@-%@ %@ %@", self.uuidNormalized, self.major, self.minor, self.seenNormalized, self.typeNormalized];
}

@end
