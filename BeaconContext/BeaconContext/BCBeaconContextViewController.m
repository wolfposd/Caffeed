//
//  BCBeaconContextViewController.m
//  BeaconContext
//
//  Created by Wolf Posdorfer on 28.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BCBeaconContextViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface BCBeaconContextViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) CLLocationManager* locationManager;

@end

@implementation BCBeaconContextViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self stopMonitoring];
    
    
    UIBackgroundRefreshStatus st = [[UIApplication sharedApplication] backgroundRefreshStatus];
    
    switch (st) {
        case UIBackgroundRefreshStatusAvailable : NSLog(@"%@", @"Background Available");break;
        case UIBackgroundRefreshStatusDenied: NSLog(@"%@", @"Background Denied");break;
        case UIBackgroundRefreshStatusRestricted: NSLog(@"%@", @"Background Restricted");break;
        default: NSLog(@"%@", @"default");break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) checkStateOfRegions
{
    [self checkStateTouchUpInside:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void) stopMonitoring
{
    for(CLRegion* reg in self.locationManager.monitoredRegions)
    {
        NSLog(@"Stop monitoring for: %@", reg.identifier);
        [self.locationManager stopMonitoringForRegion:reg];
    }
}

-(void) startMonitoring
{
    [self.activityIndicator startAnimating];
    
    [self localNotification:@"Started monitoring"];
    
    
    // B9407F30-F5F8-466E-AFF9-25556B57FE6D 44787 34420 esti007
    // B9407F30-F5F8-466E-AFF9-25556B57FE6D 18475 24286 esti008
    // B9407F30-F5F8-466E-AFF9-25556B57FE6D 48148 31883 esti009
    
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
//    CLBeaconRegion* esti007 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:44787 minor:34420 identifier:@"esti007"];
    CLBeaconRegion* esti008 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:18475 minor:24286 identifier:@"esti008"];
    CLBeaconRegion* esti009 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:48148 minor:31883 identifier:@"esti009"];
    
    // CLBeaconRegion* reg1= [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"testregion"];
    // CLBeaconRegion* reg2 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 minor:1 identifier:@"testregion1"];
    
    for(CLBeaconRegion* region in @[esti008, esti009])
    {
        region.notifyEntryStateOnDisplay = YES;
        region.notifyOnEntry = YES;
        region.notifyOnExit = YES;
        
        [self.locationManager startMonitoringForRegion:region];
        [self.locationManager requestStateForRegion:region];
        // [self.locationManager startRangingBeaconsInRegion:region];
    }
    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    
    NSString* nsstate;
    switch(state)
    {
        case CLRegionStateInside: nsstate = @"inside";
            break;
        case CLRegionStateOutside: nsstate = @"outside";
            break;
        default: nsstate = @"unknown";
            break;
    }
    NSLog(@"Determining State: %@ forRegion: %@", nsstate , region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if(beacons.count > 0)
    {
        NSLog(@"%@ region: %@", @"Did Range Beacons", region.identifier);
        for(CLBeacon* beacon in beacons)
        {
            NSLog(@"Beacon: %@ %@ %@", beacon.proximityUUID.UUIDString, beacon.major, beacon.minor);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"%@ %@", @"Ranging Beacons failed", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self localNotification:@"Entered Region"];
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self localNotification:@"Exited Region"];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed with error: %@", error);
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Monitoring failed with error: %@", error);
    NSLog(@"in region: %@", region.identifier);
    
    
    if(error.code == kCLErrorRegionMonitoringDenied)
    {
        NSLog(@"%@", @"kCLErrorRegionMonitoringDenied");
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSString* sstatus;
    
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined: sstatus = @"NotDetermined";
            break;
        case kCLAuthorizationStatusRestricted: sstatus = @"StatusRestricted";
            break;
        case kCLAuthorizationStatusDenied: sstatus = @"StatusDenied";
            break;
        case kCLAuthorizationStatusAuthorized: sstatus = @"StatusAuthorized";
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: sstatus = @"StatusAuthorizedWhenInUse";
            break;
        default: sstatus = @"unknown";
            break;
    }
    
    NSLog(@"Changed Authorization status: %@", sstatus);
}


- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSString* not = [NSString stringWithFormat:@"startMonitor: %@", region.identifier];
    NSLog(@"%@", not);
}

-(void) localNotification:(NSString*) string
{
    NSLog(@"%@ -> %@", @"Firing Local Notification", string);
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = string;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

#pragma mark - IBActions

- (IBAction)startMonitoringTouchUpInside:(id)sender
{
    [self startMonitoring];
}

- (IBAction)checkStateTouchUpInside:(id)sender
{
    for(CLRegion* reg in self.locationManager.monitoredRegions)
    {
        NSLog(@"Checking state for: %@", reg.identifier);
        [self.locationManager requestStateForRegion:reg];
    }
    
}


@end
