//
//  BCBeaconContextViewController.m
//  BeaconContext
//
//  Created by Wolf Posdorfer on 28.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "BCBeaconContextViewController.h"
#import "FeedbackSheetGet.h"
#import "BeaconOrderer.h"
#import "FileLog.h"
#import "FeedbackSheetGet.h"
#import "FSTableViewController.h"

@interface BCBeaconContextViewController ()<CLLocationManagerDelegate, FeedbackSheetGetDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) CLLocationManager* locationManager;

@property (nonatomic, strong) FeedbackSheetGet* feedbacksheetget;

@property (nonatomic, strong) NSMutableDictionary* beaconOrderer;



@end

@implementation BCBeaconContextViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _beaconOrderer = [NSMutableDictionary new];
        _feedbacksheetget = [FeedbackSheetGet new];
        _feedbacksheetget.delegate = self;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self stopMonitoring];
    
    
    self.title = @"Debug Mode";
    
    [FileLog log:@"Starting Application Log\n-------------------------------------------------------------\n"];
 
    UIBackgroundRefreshStatus st = [[UIApplication sharedApplication] backgroundRefreshStatus];
    
    switch (st)
    {
        case UIBackgroundRefreshStatusAvailable:
            NSLog(@"%@", @"Background Available");
            break;
        case UIBackgroundRefreshStatusDenied:
            NSLog(@"%@", @"Background Denied");
            break;
        case UIBackgroundRefreshStatusRestricted:
            NSLog(@"%@", @"Background Restricted");
            break;
        default:
            NSLog(@"%@", @"default");
            break;
    }
    
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    
    
    
    // [self checkFacebook];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




-(void) checkFacebook
{
    ACAccountStore* accountStore = [[ACAccountStore alloc] init];
    ACAccountType* facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierFacebook];
    
    [accountStore requestAccessToAccountsWithType:facebookAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:facebookAccountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount* facebookAccount = arrayOfAccounts.lastObject;
                 
                 SLRequest *facebookRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodPOST
                                                                           URL:[NSURL URLWithString:@"https://graph.facebook.com/me/feed"]
                                                                    parameters:[NSDictionary dictionaryWithObject:@"post" forKey:@"message"]];
                [facebookRequest setAccount:facebookAccount];
                 
                 
                 [facebookRequest performRequestWithHandler:^(NSData* data, NSHTTPURLResponse* response, NSError* error)
                 {
                     NSLog(@"DATA: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                     NSLog(@"RESP: %@", response);
                     NSLog(@"ERORR: %@", error);
                 }];
             }
         }
        
     }];
    
}


-(void)checkStateOfRegions
{
    [self checkStateTouchUpInside:nil];
}



-(void) addBeaconEvent:(CLRegion*) region event:(BCBeaconSeenType) type
{
    CLBeaconRegion* beaconregion = (CLBeaconRegion*)region;
    
    BCBeacon* beacon = [BCBeacon beaconWith:beaconregion.proximityUUID.UUIDString major:beaconregion.major minor:beaconregion.minor seen:[NSDate date] type:type];
    
    beacon.name = region.identifier;
    
    BeaconOrderer* order = [self.beaconOrderer objectForKey:region.identifier];
    
    [order addBeacon:beacon];
}


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

    // B9407F30-F5F8-466E-AFF9-25556B57FE6D 18475 24286 esti008
    // B9407F30-F5F8-466E-AFF9-25556B57FE6D 48148 31883 esti009
    // B9407F30-F5F8-466E-AFF9-25556B57FE6D 32018 41230	esti010
    
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    CLBeaconRegion* esti008 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:18475 minor:24286 identifier:@"esti008"];
    CLBeaconRegion* esti009 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:48148 minor:31883 identifier:@"esti009"];
    CLBeaconRegion* esti010 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:32018 minor:41230 identifier:@"esti010"];
    
    for(CLBeaconRegion* region in @[esti008, esti009, esti010])
    {
        region.notifyEntryStateOnDisplay = YES;
        region.notifyOnEntry = YES;
        region.notifyOnExit = YES;
        
        [self.beaconOrderer setObject:[BeaconOrderer new] forKey:region.identifier];
        
        [self.locationManager startMonitoringForRegion:region];
        [self.locationManager requestStateForRegion:region];
        // [self.locationManager startRangingBeaconsInRegion:region];
    }
    
}


-(BOOL) didRegionAlreadyTriggerEnter:(CLRegion*) region
{
    BeaconOrderer* order = [self.beaconOrderer objectForKey:region.identifier];
    if(order)
    {
        BCBeacon* beacon = order.savedBeacons.lastObject;
        if(!beacon)
        {
            return false;
        }
        return true;
    }
    return false;
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
    NSLog(@"Determining State: %@ for Region: %@", nsstate , region.identifier);
    
    if(state == CLRegionStateInside && ![self didRegionAlreadyTriggerEnter:region])
    {
        [self locationManager:nil didEnterRegion:region];
    }
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
    [self localNotification:[NSString stringWithFormat:@"Entered Region: %@",region.identifier]];
    
    [self addBeaconEvent:region event:BCBeaconSeenTypeEnter];
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self localNotification:[NSString stringWithFormat:@"Exited Region: %@",region.identifier]];
    
    [self addBeaconEvent:region event:BCBeaconSeenTypeExit];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed with error: %@", error);
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Monitoring failed with error: %@", error);
    if(error.code == kCLErrorRegionMonitoringDenied)
    {
        NSLog(@"%@", @"Region monitoring denied");
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
    NSString* not = [NSString stringWithFormat:@"didStartMonitoringForRegion: %@", region.identifier];
    NSLog(@"%@", not);
}

-(void) localNotification:(NSString*) string
{
    
    [FileLog log:[NSString stringWithFormat:@"Firing Local Notification -> %@", string]];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = string;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

#pragma mark - FeedbackSheetGetDelegate
-(void)feedbacksheetget:(id)get downloadFailure:(NSError *)error
{
    [FileLog log:error.description];
}
-(void)feedbacksheetget:(id)get downloadSuccess:(FeedbackSheet *)feedbacksheet
{
    [FileLog log:@"success getting sheet, now displaying"];
    FSTableViewController* fst = [[FSTableViewController alloc] initWithSheet:feedbacksheet];
    [self performSelectorOnMainThread:@selector(pushController:) withObject:fst waitUntilDone:NO];
}

-(void) pushController:(id) controller
{
   [self.navigationController pushViewController:controller animated:YES];
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
- (IBAction)showOrderTouchUpInside:(id)sender
{
    [FileLog log:@"Showing Order:"];
    for(NSString* key in self.beaconOrderer.allKeys)
    {
        NSArray* savedBeacons = [[self.beaconOrderer objectForKey:key] savedBeacons];
        
        [FileLog log:[NSString stringWithFormat:@"Region: %@ , saved: %lu", key, (unsigned long)savedBeacons.count]];
        for(BCBeacon* beacon in savedBeacons)
        {
            [FileLog log:beacon.description];
        }
    }
}
- (IBAction)submitTouchUpInside:(id)sender
{
 
    
    NSString* contextjson = @"{\"beacons\":[{\"uuid\":\"B9407F30F5F8466EAFF925556B57FE6D\",\"major\":48148,\"minor\":31883,\"seen\":\"2014-10-10 12:09:09\",\"type\":\"enter\"},{\"uuid\":\"B9407F30F5F8466EAFF925556B57FE6D\",\"major\":48148,\"minor\":31883,\"seen\":\"2014-10-10 12:25:09\",\"type\":\"exit\"},{\"uuid\":\"B9407F30F5F8466EAFF925556B57FE6D\",\"major\":48148,\"minor\":31883,\"seen\":\"2014-10-10 15:09:09\",\"type\":\"exit\"},{\"uuid\":\"B9407F30F5F8466EAFF925556B57FE6D\",\"major\":48148,\"minor\":31883,\"seen\":\"2014-10-10 14:25:09\",\"type\":\"enter\"},{\"uuid\":\"B9407F30F5F8466EAFF925556B57FE6D\",\"major\":1,\"minor\":2,\"seen\":\"2014-10-10 15:09:09\",\"type\":\"exit\"},{\"uuid\":\"B9407F30F5F8466EAFF925556B57FE6D\",\"major\":1,\"minor\":2,\"seen\":\"2014-10-10 14:25:09\",\"type\":\"enter\"}]}";
    
    
    [self.feedbacksheetget loadSheetForContext:contextjson];
}


@end
