//
//  BCBeaconMonitor.m
//  BeaconContext
//
//  Created by Wolf Posdorfer on 01.07.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BCBeaconMonitor.h"
#import <CoreLocation/CoreLocation.h>

@interface BCBeaconMonitor ()<CLLocationManagerDelegate>

@property(nonatomic,retain) CLLocationManager* locationManager;

@property (nonatomic,retain) NSMutableArray* monitoredRegions;

@end


@implementation BCBeaconMonitor


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.delegate = self;
        
        self.monitoredRegions = [NSMutableArray new];
        
        // NSUUID* uuid2 = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
        NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:@"00000000-0000-0000-0000-000000000000"];
        [self registerBeaconRegionWithUUID:uuid andIdentifier:@"somevalue"];
        
        
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [self.locationManager setDistanceFilter:2];
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)registerBeaconRegionWithUUID:(NSUUID *)proximityUUID andIdentifier:(NSString*)identifier
{
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:identifier];
    
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;
    
    beaconRegion.notifyEntryStateOnDisplay = YES;
    
    NSLog(@"Registered Region: %@ %@ %@", beaconRegion.proximityUUID ,beaconRegion.major, beaconRegion.minor);
    
    [self.monitoredRegions addObject:beaconRegion];
}

-(void) startBeaconRegion
{
    for(CLBeaconRegion* region in self.monitoredRegions)
    {
        [self.locationManager startMonitoringForRegion:region];
    }
}


-(void) stopBeaconRegion
{
    for(id region in self.monitoredRegions)
    {
       [self.locationManager stopMonitoringForRegion:region];
    }
}

-(void)startRanging
{
    NSLog(@"%@", @"Started Ranging");
    for(id region in self.monitoredRegions)
    {
        [self.locationManager startRangingBeaconsInRegion:region];
    }
}

-(void) stopRanging
{
    for(id region in self.monitoredRegions)
    {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
}


-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(!self.delegate)
    {
        NSLog(@"%@", @"No delegate");
        return;
    }
    
    [self.delegate state:state forRegion:region];
}


-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
    if(!self.delegate)
    {
        NSLog(@"%@", @"No delegate");
        return;
    }
    NSLog(@"Entering Region: %@", region);
    [self.delegate enterRegion:region];
}


-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
    if(!self.delegate)
    {
        NSLog(@"%@", @"No delegate");
        return;
    }
    NSLog(@"Exiting Region: %@", region);
    [self.delegate exitRegion:region];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(rangedBeacons:)])
    {
        [self.delegate rangedBeacons:beacons];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(locationWasUpdated)])
    {
        for(CLLocation* loc in locations)
        {
            NSLog(@"Location Update: lat:%f long:%f", loc.coordinate.latitude, loc.coordinate.longitude);
        }
        [self.delegate locationWasUpdated];
    }
}


@end
