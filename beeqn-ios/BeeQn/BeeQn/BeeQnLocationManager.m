//
// Created by Wolf Posdorfer on 10.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BeeQnLocationManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BeeQnLocationManager () <CLLocationManagerDelegate, CBCentralManagerDelegate>

@property (nonatomic, retain) CLLocationManager* locationManager;
@property (retain, nonatomic) NSMutableArray* uuidRegions;
@property (nonatomic, retain) CBCentralManager* bluetoothManager;


@property (nonatomic) CBCentralManagerState bluetoothstate;

@property (nonatomic,readwrite) BOOL isBeaconFetchInProgress;

@property (nonatomic) int numDetections;


@end


@implementation BeeQnLocationManager


static const int MAXIMUM_BEACON_SEARCHES = 10;
static const int FACTOR_FOR_BEACON_FIND_MAX = 4;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.numDetections = 0;
        self.beaconCounter = [BQBeaconCounter new];
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
    return self.bluetoothstate == CBCentralManagerStatePoweredOn || self.bluetoothstate == CBCentralManagerStateUnknown;
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
    self.numDetections = 0;
    self.isBeaconFetchInProgress = YES;
    for (NSString* uuid in self.uuidRegions)
    {
        NSUUID* nsuuid = [[NSUUID alloc] initWithUUIDString:uuid];
        NSString* identi = [NSString stringWithFormat:@"de.beeqn.%@",uuid];
        [self.locationManager startRangingBeaconsInRegion:[[CLBeaconRegion alloc] initWithProximityUUID:nsuuid identifier:identi]];
    }
}

- (void)stopFindingBeacons
{
    self.numDetections = 0;
    if (self.isBeaconFetchInProgress)
    {
        self.isBeaconFetchInProgress = NO;
        for (NSString* uuid in self.uuidRegions)
        {
            NSUUID* nsuuid = [[NSUUID alloc] initWithUUIDString:uuid];
            NSString* identi = [NSString stringWithFormat:@"de.beeqn.%@",uuid];
            [self.locationManager stopRangingBeaconsInRegion:[[CLBeaconRegion alloc] initWithProximityUUID:nsuuid identifier:identi]];
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
    
    // Convert CLBeacon to BQBeacon because of equalsBullshit
    NSMutableArray* newBQ = [NSMutableArray new];
    for(CLBeacon* beacon in beacons)
    {
        [newBQ addObject:[BQBeacon beacon:beacon]];
    }
    
    [self.beaconCounter increaseCountFor:newBQ];
    
    if ([self.delegate respondsToSelector:@selector(manager:hasFoundBeacons:)] && beacons.count > 0)
    {
        // notify on beacons array found
        [self.delegate manager:self hasFoundBeacons:newBQ];
    }
    
    if(newBQ && newBQ.count > 0)
    {
        [self checkIfNumberDetectionsNeedNotify:newBQ];
    }
}

-(NSArray*) sortBeaconArray:(NSArray*) array
{
    return [array sortedArrayUsingComparator:^(id obj1, id obj2)
               {
                   NSInteger rss1 = [self.beaconCounter meanRSSI:obj1];
                   NSInteger rss2 = [self.beaconCounter meanRSSI:obj2];
                   if (rss1 <  rss2)
                   {
                       return (NSComparisonResult)NSOrderedDescending;
                   }
                   else if (rss1 > rss2)
                   {
                       return (NSComparisonResult)NSOrderedAscending;
                   }
                   else
                   {
                       return (NSComparisonResult)NSOrderedSame;
                   }
               }];
}


- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    CLLocation* loc = [locations lastObject];
    
    if (loc)
    {
        [self.delegate manager:self hasFoundGPS:loc];
    }
}


- (void)checkIfNumberDetectionsNeedNotify:(NSArray*) beacons
{
    self.numDetections = self.numDetections + 1;
    
    
    int search = (int) beacons.count * FACTOR_FOR_BEACON_FIND_MAX;
    search = search  > MAXIMUM_BEACON_SEARCHES ? MAXIMUM_BEACON_SEARCHES : search;
    
    if([self.delegate respondsToSelector:@selector(manager:hasFoundBeaconsTimes:fromMaximumSearch:)])
    {
        [self.delegate manager:self hasFoundBeaconsTimes:self.numDetections fromMaximumSearch:search ];
    }
    
    
    if (self.numDetections >= search && self.isBeaconFetchInProgress)
    {
        // notify delegate about beacon found
        BQBeacon* beacon =[self.beaconCounter closestBeacon];
        if(beacon)
        {
            [self.delegate manager:self hasFoundBeacon:beacon];
        }
    }
    
}



#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager*)central
{
    self.bluetoothstate = central.state;
}


@end


