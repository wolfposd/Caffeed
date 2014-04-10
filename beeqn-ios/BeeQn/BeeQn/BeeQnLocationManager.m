//
// Created by Wolf Posdorfer on 10.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BeeQnLocationManager.h"
#import "CLBeacon+Equals.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface BeeQnLocationManager () <CLLocationManagerDelegate, CBCentralManagerDelegate>

@property (nonatomic, retain) CLLocationManager* locationManager;
@property (retain, nonatomic) NSMutableArray* uuidRegions;
@property (nonatomic, retain) CBCentralManager* bluetoothManager;


@property (nonatomic) CBCentralManagerState bluetoothstate;
@property (retain, nonatomic) CLBeacon* lastClosestBeacon;
@property (nonatomic) BOOL isBeaconFetchInProgress;
@property (nonatomic) int numDetections;
@end


@implementation BeeQnLocationManager


- (id)init
{
    self = [super init];
    if (self)
    {
        self.isBeaconFetchInProgress = NO;

        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;

        self.uuidRegions = [[NSMutableArray alloc] initWithObjects:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D", nil];

        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(0, 0)];

    }
    return self;

}

- (BOOL)isBluetoothOn
{
    return self.bluetoothstate == CBCentralManagerStatePoweredOn;
}

- (BOOL)isFindingBeaconsPossible
{
    return [CLLocationManager isRangingAvailable];
}

- (BOOL)isLocationServicesEnabled
{
    return [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
}


- (void)startFindingBeacons
{
    self.isBeaconFetchInProgress = YES;
    for (NSString* uuid in self.uuidRegions)
    {
        NSUUID* nsuuid = [[NSUUID alloc] initWithUUIDString:uuid];
        [self.locationManager startRangingBeaconsInRegion:[[CLBeaconRegion alloc] initWithProximityUUID:nsuuid identifier:@"de.beeqn"]];
    }
}

- (void)stopFindingBeacons
{
    if (self.isBeaconFetchInProgress)
    {
        self.numDetections = 0;
        self.lastClosestBeacon = nil;
        self.isBeaconFetchInProgress = NO;
        for (NSString* uuid in self.uuidRegions)
        {
            NSUUID* nsuuid = [[NSUUID alloc] initWithUUIDString:uuid];
            [self.locationManager stopRangingBeaconsInRegion:[[CLBeaconRegion alloc] initWithProximityUUID:nsuuid identifier:@"de.beeqn"]];
        }
    }
}

- (void)startFindingGPS
{
    [self.locationManager startUpdatingLocation];
}

- (void)stopFindingGPS
{
    [self.locationManager stopUpdatingLocation];
}


- (void)updateRegions:(NSArray*)regions
{
    BOOL isInProgress = self.isBeaconFetchInProgress;

    if (isInProgress)
    {
        [self stopFindingBeacons];
    }

    [self.uuidRegions removeAllObjects];
    [self.uuidRegions addObjectsFromArray:regions];

    if (isInProgress)
    {
        [self startFindingBeacons];
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    if ([self.delegate respondsToSelector:@selector(manager:didReceiveError:)])
    {
        [self.delegate manager:self didReceiveError:error];
    }
}


- (void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
{
    if ([self.delegate respondsToSelector:@selector(manager:hasFoundBeacons:)])
    {
        // notify on beacons array found
        [self.delegate manager:self hasFoundBeacons:beacons];
    }

    // only increase count if rssi != 0;
    for (CLBeacon* beacon in beacons)
    {
        if (beacon.rssi != 0)
        {
            [self increaseBeaconFoundCount:beacon];
            break;
        }
    }
}


- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    CLLocation* loc = [locations lastObject];

    if (loc)
    {
        [self.delegate manager:self hasFoundGPS:loc];
    }
}


- (void)increaseBeaconFoundCount:(CLBeacon*)beacon
{

    if ([self.lastClosestBeacon isEqualToBeacon:beacon])
    {
        self.numDetections = self.numDetections + 1;

        NSLog(@"beacon %@ count: %d", beacon.major, self.numDetections);

    }
    else
    {
        self.lastClosestBeacon = beacon;
        self.numDetections = 0;
    }


    if (self.numDetections > 3 && self.isBeaconFetchInProgress)
    {
        // notify delegate about beacon found
        [self.delegate manager:self hasFoundBeacon:beacon];
    }

}



#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager*)central
{
    self.bluetoothstate = central.state;
}


@end


