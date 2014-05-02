//
// Created by Wolf Posdorfer on 10.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BeeQnLocationManager.h"
#import <CoreBluetooth/CoreBluetooth.h>


#define kModeRangeAllBeacons 0
#define kModeRangeSpecificBeacons 1

@interface BeeQnLocationManager () <CLLocationManagerDelegate, CBCentralManagerDelegate>

@property (nonatomic, retain) CLLocationManager* locationManager;
@property (retain, nonatomic) NSMutableArray* uuidRegions;
@property (nonatomic, retain) CBCentralManager* bluetoothManager;


@property (nonatomic) CBCentralManagerState bluetoothstate;

@property (nonatomic,readwrite) BOOL isBeaconFetchInProgress;

@property (nonatomic) int numDetections;

@property (nonatomic) int maximumNumberBeaconDetections;


@property(nonatomic,retain) NSArray* specificUUIDRegions;


@property (nonatomic) int currentModeOfOperation;

@end


@implementation BeeQnLocationManager


#define MAXIMUM_BEACON_SEARCHES_DEFAULT 10
#define FACTOR_FOR_BEACON_FIND_MAX 4

- (id)init
{
    self = [super init];
    if (self)
    {
        self.maximumNumberBeaconDetections = MAXIMUM_BEACON_SEARCHES_DEFAULT;
        self.currentModeOfOperation = kModeRangeAllBeacons;
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
    self.currentModeOfOperation = kModeRangeAllBeacons;
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
    
    
     self.maximumNumberBeaconDetections = MAXIMUM_BEACON_SEARCHES_DEFAULT * (int)regions.count;
    if (isInProgress)
    {
        [self startFindingBeacons];
    }
}


- (void)startFindingSpecificBeacons:(NSArray*) bqbeaconArray
{
    
    self.currentModeOfOperation = kModeRangeSpecificBeacons;
    self.isBeaconFetchInProgress = YES;
    self.maximumNumberBeaconDetections = MAXIMUM_BEACON_SEARCHES_DEFAULT * (int)bqbeaconArray.count;
    
    self.specificUUIDRegions = bqbeaconArray;
    
    for(BQBeacon* beacon in self.specificUUIDRegions)
    {
        NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:beacon.UUID];
        NSString* identi = [NSString stringWithFormat:@"de.beeqn.%@%@%@",uuid,beacon.major,beacon.minor];
        [self.locationManager startRangingBeaconsInRegion:
         [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:beacon.major.unsignedIntValue minor:beacon.minor.unsignedIntValue identifier:identi]];
    }
}


- (void)stopFindingSpecificBeacons
{
    for(BQBeacon* beacon in self.specificUUIDRegions)
    {
        NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:beacon.UUID];
        NSString* identi = [NSString stringWithFormat:@"de.beeqn.%@%@%@",uuid,beacon.major,beacon.minor];
        [self.locationManager startRangingBeaconsInRegion:
         [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:beacon.major.unsignedIntValue minor:beacon.minor.unsignedIntValue identifier:identi]];
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
    if(beacons.count > 0)
    {
        NSMutableArray* newBQ = [NSMutableArray new];
        
        // Convert CLBeacon to BQBeacon because of equalsBullshit
        for(CLBeacon* beacon in beacons)
        {
            [newBQ addObject:[BQBeacon beacon:beacon]];
        }
        
        [self insertBeaconsInCounter:newBQ];
        
        if(self.currentModeOfOperation == kModeRangeAllBeacons)
        {
            if ([self.delegate respondsToSelector:@selector(manager:hasFoundBeacons:)])
            {
                // notify on beacons array found
                NSArray* sortedAllBeacons = [self.beaconCounter.allBeacons
                                             sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"rssi" ascending:YES]]];
                
                [self.delegate manager:self hasFoundBeacons:sortedAllBeacons];
            }
        }
        
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
    
    if (loc && [self.delegate respondsToSelector:@selector(manager:hasFoundGPS:)])
    {
        [self.delegate manager:self hasFoundGPS:loc];
    }
}


-(void) insertBeaconsInCounter:(NSArray*) beacons
{
    [self.beaconCounter increaseCountFor:beacons];
    self.numDetections = self.numDetections + 1;
}


- (void)checkIfNumberDetectionsNeedNotify:(NSArray*) beacons
{
    if(self.isBeaconFetchInProgress)
    {
       
        int search = (int) self.beaconCounter.count * FACTOR_FOR_BEACON_FIND_MAX;
        search = search  > self.maximumNumberBeaconDetections ? self.maximumNumberBeaconDetections : search;
        
        
        // NOTIFY DELEGATE  5 / 10 detections
        if([self.delegate respondsToSelector:@selector(manager:hasFoundBeaconsTimes:fromMaximumSearch:)])
        {
            [self.delegate manager:self hasFoundBeaconsTimes:self.numDetections fromMaximumSearch:search ];
        }
        
        
        if (self.numDetections >= search && self.isBeaconFetchInProgress)
        {
            // notify delegate about beacon found
            if(self.currentModeOfOperation == kModeRangeAllBeacons && [self.delegate respondsToSelector:@selector(manager:hasFoundBeacon:)])
            {
                BQBeacon* beacon =[self.beaconCounter closestBeacon];
                if(beacon)
                {
                    [self.delegate manager:self hasFoundBeacon:beacon];
                }
            }
            else if (self.currentModeOfOperation == kModeRangeSpecificBeacons)
            {
                [self sendNotificationToDelegateSpecificBeaconsMaximumCountReached:self.beaconCounter.allBeacons];
            }
        }
    }
    
}

-(void) sendNotificationToDelegateSpecificBeaconsMaximumCountReached:(NSSet*) oldBQBeacon
{
    if([self.delegate respondsToSelector:@selector(manager:hasFoundSpecificBeacons:)])
    {
        NSMutableArray* newArray = [NSMutableArray new];
        
        for(BQBeacon* beacon in oldBQBeacon)
        {
            NSInteger rssi = [self.beaconCounter meanRSSI:beacon];
            double accu = [self.beaconCounter meanAccuracy:beacon];
            
            BQBeacon* newB = [BQBeacon beacon:beacon.UUID major:beacon.major minor:beacon.minor proximity:(CLProximity)beacon.proximity accuracy:accu rssi:rssi];
            [newArray addObject:newB];
        }
        
        [newArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"rssi" ascending:YES]]];
        
        [self.delegate manager:self hasFoundSpecificBeacons:newArray];
    }
}



#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager*)central
{
    self.bluetoothstate = central.state;
}


@end


