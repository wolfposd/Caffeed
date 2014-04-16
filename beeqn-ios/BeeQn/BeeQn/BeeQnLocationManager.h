//
// Created by Wolf Posdorfer on 10.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BQBeaconCounter.h"
#import "BQBeacon.h"

@protocol BeeQnLocationManagerProtocol;

@interface BeeQnLocationManager : NSObject

@property (nonatomic, weak) NSObject <BeeQnLocationManagerProtocol>* delegate;

@property(nonatomic, readonly) BOOL isBeaconFetchInProgress;

@property (nonatomic, retain) BQBeaconCounter* beaconCounter;

- (BOOL)isBluetoothOn;

- (BOOL)isFindingBeaconsPossible;

- (BOOL)isLocationServicesEnabled;

- (void)startFindingBeacons;

- (void)stopFindingBeacons;

/**
 *  Starts finding GPS
 *  Callbacks will be made to manager:hasFoundGPS:
 */
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
- (void)manager:(BeeQnLocationManager*)manager hasFoundBeacon:(BQBeacon*)beacon;

/**
 *  the manager has found a GPS-Location
 *
 *  @param manager the manager
 *  @param beacon  the gps-location
 */
- (void)manager:(BeeQnLocationManager*)manager hasFoundGPS:(CLLocation*)gpslocation;

@optional
/**
 *  the manager has found multiple beacons of type BQBeacon
 *
 *  @param manager the manager
 *  @param beacon  the beacons
 */
- (void)manager:(BeeQnLocationManager*)manager hasFoundBeacons:(NSArray*)beacons;

- (void)manager:(BeeQnLocationManager*)manager hasFoundBeaconsTimes:(int) times fromMaximumSearch:(int) maximum;

/**
 *  the manager has received an error
 *
 *  @param manager the manager
 *  @param beacon  the error thrown
 */
- (void)manager:(BeeQnLocationManager*)manager didReceiveError:(NSError*)error;


@end