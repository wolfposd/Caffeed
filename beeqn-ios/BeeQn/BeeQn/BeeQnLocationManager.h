//
// Created by Wolf Posdorfer on 10.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BQBeaconCounter.h"
#import "BQBeacon.h"


#define kModeRangeAllBeacons 0
#define kModeRangeSpecificBeacons 1
#define kModeRangeAllBeaconsForInfinity 2

@protocol BeeQnLocationManagerProtocol;

@interface BeeQnLocationManager : NSObject

@property (nonatomic, weak) NSObject <BeeQnLocationManagerProtocol>* delegate;

@property (nonatomic, readonly) BOOL isBeaconFetchInProgress;

@property (nonatomic, readonly) int currentModeOfOperation;

@property (nonatomic, retain) BQBeaconCounter* beaconCounter;

/**
 *  Is bluetooth currently on?
 *
 *  @return yes or no
 */
- (BOOL)isBluetoothOn;
/**
 *  Is finding Beacons possible? (Mainly due to CLLocationManager permissions)
 *
 *  @return yes or no
 */
- (BOOL)isFindingBeaconsPossible;
/**
 *  Is GPS enabled?
 *
 *  @return Yes or No
 */
- (BOOL)isLocationServicesEnabled;
/**
 *  Starts finding Beacons
 *  The UUIDs are taken from the specified UUIDs when calling updateRegions:
 *
 *  Callbacks will be made to a variety of methods: manager:hasFoundBeacon: , manager:hasFoundBeacons: , manager:hasFoundBeaconsTimes:fromMaximumSearch:
 */
- (void) startFindingBeacons;

/**
 *  Starts finding Beacons for an inifinte amount of time
 *
 * Callbacks will be made to a variety of methods: manager:hasFoundBeacons: , manager:hasFoundBeaconsTimes:fromMaximumSearch:
 */
- (void) startFindingBeaconsInfiniteTime;

/**
 *  Stops finding Beacons
 */
- (void)stopFindingBeacons;

/**
 *  Starts finding GPS
 *  Callbacks will be made to manager:hasFoundGPS:
 */
- (void)startFindingGPS;
/**
 *  Stops finding GPS
 */
- (void)stopFindingGPS;

/**
 * Tell the manager to scan these regions
 *
 * maximum of regions is 20
 *
 * @param regions an NSArray of UUID-Strings
 */
- (void) updateRegions:(NSArray*)regions;

/**
 *  Starts scanning for specific beacons with uuid,major and minor
 *
 *  @param bqbeaconArray an NSArray containing BQBeacon-Objects
 */
- (void)startFindingSpecificBeacons:(NSArray*) bqbeaconArray;

/**
 *  Stops finding specific beacons
 */
- (void)stopFindingSpecificBeacons;

@end


@protocol BeeQnLocationManagerProtocol
@optional
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

/**
 *  the manager has found multiple beacons of type BQBeacon
 *
 *  @param manager the manager
 *  @param beacon  the beacons
 */
- (void)manager:(BeeQnLocationManager*)manager hasFoundBeacons:(NSArray*)beacons;

/**
 *  The manager is currently in the n-th scanning round of m maximum rounds
 *
 *  @param manager the manager
 *  @param times   current scanning round
 *  @param maximum maximum scanning rounds
 */
- (void)manager:(BeeQnLocationManager*)manager hasFoundBeaconsTimes:(int) times fromMaximumSearch:(int) maximum;

/**
 *  The manager has found specific beacons multiple times.
 *  All BQBeacons will have the mean-RSSI value stored.
 *  Good for trilateration
 *
 *  @param manager the manager
 *  @param beacons an array of BQBeacon
 */
-(void)manager:(BeeQnLocationManager *)manager hasFoundSpecificBeacons:(NSArray*) beacons;


/**
 *  the manager has received an error
 *
 *  @param manager the manager
 *  @param beacon  the error thrown
 */
- (void)manager:(BeeQnLocationManager*)manager didReceiveError:(NSError*)error;


@end