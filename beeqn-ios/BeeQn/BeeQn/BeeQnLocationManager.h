//
// Created by Wolf Posdorfer on 10.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol BeeQnLocationManagerProtocol;

@interface BeeQnLocationManager : NSObject

@property (nonatomic, weak) NSObject <BeeQnLocationManagerProtocol>* delegate;

- (BOOL)isBluetoothOn;

- (BOOL)isFindingBeaconsPossible;

- (BOOL)isLocationServicesEnabled;

- (void)startFindingBeacons;

- (void)stopFindingBeacons;

- (void)startFindingGPS;

- (void)stopFindingGPS;

/**
 * Tell the manager to scan these regions
 *
 * maximum of regions is 20
 *
 * @param regions an NSArray of UUID-Strings
 */
- (void)updateRegions:(NSArray*)regions;

@end


@protocol BeeQnLocationManagerProtocol

/**
 *  the manager has found a beacon multiple times close by
 *
 *  @param manager the manager
 *  @param beacon  the beacon found
 */
- (void)manager:(BeeQnLocationManager*)manager hasFoundBeacon:(CLBeacon*)beacon;

/**
 *  the manager has found a GPS-Location
 *
 *  @param manager the manager
 *  @param beacon  the gps-location
 */
- (void)manager:(BeeQnLocationManager*)manager hasFoundGPS:(CLLocation*)gpslocation;

@optional
/**
 *  the manager has found multiple beacons
 *
 *  @param manager the manager
 *  @param beacon  the beacons
 */
- (void)manager:(BeeQnLocationManager*)manager hasFoundBeacons:(NSArray*)beacons;

/**
 *  the manager has received an error
 *
 *  @param manager the manager
 *  @param beacon  the error thrown
 */
- (void)manager:(BeeQnLocationManager*)manager didReceiveError:(NSError*)error;


@end