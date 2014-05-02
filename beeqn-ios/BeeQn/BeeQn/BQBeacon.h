//
//  BQBeacon.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 15.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



typedef NS_ENUM(NSInteger, BQProximity) {
    BQProximityUnknown,
    BQProximityImmediate,
    BQProximityNear,
    BQProximityFar
};

@interface BQBeacon : NSObject

@property (nonatomic,retain, readonly) NSString* UUID;
@property (nonatomic,retain, readonly) NSNumber* major;
@property (nonatomic,retain, readonly) NSNumber* minor;
@property (nonatomic, readonly) BQProximity proximity;
@property (nonatomic, readonly) double accuracy;
@property (nonatomic, readonly) NSInteger rssi;

/**
 *  Creates a new BQBeacon Object from given CLBeacon
 *
 *  @param beacon the CLBeacon to convert
 *
 *  @return a new BQBeacon
 */
+(id) beacon:(CLBeacon*)beacon;

/**
 *  Creates a new BQBeacon Object from given values
 *
 *  @param uuid     The UUID-String
 *  @param major    major value
 *  @param minor    minor value
 *  @param prox     proximity value (enum)
 *  @param accuracy the accuracy value
 *  @param rssi     the rssi value
 *
 *  @return a new BQBeacon
 */
+(id) beacon:(NSString*) uuid major:(NSNumber*) major minor:(NSNumber*) minor proximity:(CLProximity) prox accuracy:(CLLocationAccuracy) accuracy rssi:(NSInteger) rssi;

/**
 *  Returns the distance value as String
 *
 *  @return Immediate,Near,Far or Unknown
 */
-(NSString *) distance;

/**
 *  updates a BQBeacon's values with the given values
 *
 *  @param thisBeacon BQBeacon to copy values from
 */
-(void) updateValuesFrom:(BQBeacon*) thisBeacon;

-(void) updateMeanRSSI:(NSInteger) meanRSSI meanAccuracy:(double) meanAccuracy;

@end
