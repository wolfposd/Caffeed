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
@property (nonatomic,readwrite,strong) NSString* seen;
@property (nonatomic,readwrite,strong) NSString* type;
@end



@implementation BCBeacon


+(BCBeacon*) beaconWith:(NSString*) uuid major:(NSNumber*) major minor:(NSNumber*) minor
{
    BCBeacon* b = [[BCBeacon alloc] init];
    b.major = major;
    b.minor = minor;
    b.uuid = uuid;
    return b;
}

+(BCBeacon*) beaconWith:(NSString*) uuid major:(NSNumber*) major minor:(NSNumber*) minor seen:(NSDate*) seen type:(BCBeaconSeenType) type
{
    BCBeacon* b = [[BCBeacon alloc] init];
    b.major = major;
    b.minor = minor;
    b.uuid = uuid;
    
    [b setSeenDate:seen];
    [b setTypeString:type];
    return b;
}


-(void) setSeenDate:(NSDate*) seendate
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.seen = [formatter stringFromDate:seendate];
}


-(void) setTypeString:(BCBeaconSeenType) type
{
    switch(type)
    {
        case BCBeaconSeenTypeEnter: self.type = @"enter";
            break;
        case BCBeaconSeenTypeExit: self.type = @"exit";
            break;
        default:
        case BCBeaconSeenTypeUnknown: self.type = @"unknown";
            break;
    }
}


-(NSString*) uuidNormalized
{
    return [self.uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
