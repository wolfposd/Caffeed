//
//  BQBeaconCounter.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 15.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQBeacon.h"

@interface BQBeaconCounter : NSObject
/**
 *  Increases the count for the given Beacons
 *
 *  @param beacons BQBeacon Array
 */
-(void) increaseCountFor:(NSArray*) beacons;

/**
 *  Determines the closest Beacon by RSSI from given Beacons
 *
 *  @param beacons array of BQBeacon to look for closest
 *
 *  @return closest Beacon from array
 */
-(BQBeacon*) closestBeaconFrom:(NSArray*) beacons;

/**
 *  Determines the closest Beacon by RSSI
 *
 *  @return closest beacon
 */
-(BQBeacon*) closestBeacon;

/**
 *  Returns the Beacon wiht the smallest accuracy-value
 *
 *  @return closest beacon
 */
-(BQBeacon*) mostAccurateBeacon;

/**
 *  Resets the beaconcounter
 */
-(void) resetCount;

/**
 *  Number of counted beacons
 *
 *  @return 0 to inf
 */
- (NSUInteger) count;

/**
 *  Returns all beacons in this counter
 *
 *  @return BQBeacons set
 */
- (NSSet*) allBeacons;

/**
 *  Returns all beacons sorted by rssi
 *
 *  @return BQBeacons array
 */
-(NSArray*) allBeaconsSorted;

/**
 *  Get the mean value for this beacons RSSI
 *
 *  @param beacon the beacon
 *
 *  @return the mean value
 */
-(NSInteger) meanRSSI:(BQBeacon*) beacon;
/**
 *  get the mean value for this beacons accuracy
 *
 *  @param beacon the beacon
 *
 *  @return some double, accuracy appearently in meters
 */
-(double) meanAccuracy:(BQBeacon*) beacon;


-(BQBeacon*) findBeaconWithInfo:(BQBeacon*) beacon;


-(NSArray*) findBeaconsAccuracyValues:(BQBeacon*) beacon;

-(NSArray*) findBeaconsRSSIValues:(BQBeacon*) beacon;
@end
