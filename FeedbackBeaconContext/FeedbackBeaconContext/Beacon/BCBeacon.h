//
//  BCBeacon.h
//  BeaconContext
//
//  Created by Wolf Posdorfer on 28.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, BCBeaconSeenType) {
    BCBeaconSeenTypeEnter,
    BCBeaconSeenTypeExit,
    BCBeaconSeenTypeUnknown
};


@interface BCBeacon : NSObject

@property (nonatomic,strong) NSString* name;

@property (nonatomic,readonly,strong) NSString* uuid;
@property (nonatomic,readonly,strong) NSNumber* major;
@property (nonatomic,readonly,strong) NSNumber* minor;
@property (nonatomic,readonly,strong) NSDate* seen;
@property (nonatomic,readonly) BCBeaconSeenType type;


+(BCBeacon*) beaconWith:(NSString*) uuid major:(NSNumber*) major minor:(NSNumber*) minor;

+(BCBeacon*) beaconWith:(NSString*) UUID major:(NSNumber*) major minor:(NSNumber*) minor seen:(NSDate*) seen type:(BCBeaconSeenType) type;


-(NSString*) uuidNormalized;

-(NSString*) typeNormalized;

-(NSString*) seenNormalized;

@end
