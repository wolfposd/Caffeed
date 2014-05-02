//
//  MainViewController.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 09.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "MainViewController.h"
#import "BeeQnService.h"
#import "BQListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BeeQnLocationManager.h"
#import "BQAlert.h"
#import "WebViewViewController.h"
#import "BQCircleProgress.h"

@interface MainViewController () <BeeQnServiceProtocol, BeeQnLocationManagerProtocol>
@property (weak, nonatomic) IBOutlet UITextView* textlabel;
@property (weak, nonatomic) IBOutlet UILabel* longitudeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel* latitudeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isAutoPerformActionSwitch;

@property (retain, nonatomic) BeeQnService* beeqnService;
@property (retain, nonatomic) BeeQnLocationManager* beeqnLocation;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

@property (weak, nonatomic) IBOutlet BQCircleProgress *circleProgress;

@property (nonatomic,retain) id bqAlert;

@end

@implementation MainViewController


- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"BeeQn";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.activityIndicator.hidden = YES;
    self.activityIndicator.color = [UIColor blueColor];
    
    self.isAutoPerformActionSwitch.on = [self isAutoPerformingAction];

    self.activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);

    self.beeqnService = [[BeeQnService alloc] init];
    self.beeqnService.delegate = self;


    self.beeqnLocation = [[BeeQnLocationManager alloc] init];
    self.beeqnLocation.delegate = self;


    UIBarButtonItem* scan = [[UIBarButtonItem alloc] initWithTitle:@"Stop Scan" style:UIBarButtonItemStyleBordered target:self
                                                            action:@selector(barButtonItemScan:)];

    self.navigationItem.rightBarButtonItem = scan;
    
    [self.circleProgress setCurrentValue:0];
    [self.circleProgress setMaximumValue:5];
    self.circleProgress.circleWidth = 16.0f;
    [self.circleProgress update];
    
    
    [self startBeaconFinding];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void) startBeaconFinding
{
    if (self.beeqnLocation.isBluetoothOn && self.beeqnLocation.isFindingBeaconsPossible
        && self.beeqnLocation.isLocationServicesEnabled)
    {
        
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        [self.beeqnLocation startFindingGPS];
        self.statusLabel.text = @"Finding GPS Location";
        self.navigationItem.rightBarButtonItem.title = @"Stop Scan";
    }
    else
    {
        self.navigationItem.rightBarButtonItem.title = @"Start Scan";
        if(!self.beeqnLocation.isBluetoothOn)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable Bluetooth" delegate:self
                              cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else if(!self.beeqnLocation.isFindingBeaconsPossible)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable Location Services" delegate:self
                              cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else if(!self.beeqnLocation.isLocationServicesEnabled)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable GPS" delegate:self
                              cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.beeqnLocation stopFindingBeacons];
}


-(void) barButtonItemScan:(id) sender
{
    if(self.beeqnLocation.isBeaconFetchInProgress)
    {
         self.statusLabel.text = @"Nothing in Progress";
        [self.beeqnLocation stopFindingBeacons];
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        self.navigationItem.rightBarButtonItem.title = @"Start Scan";
    }
    else
    {
        [self.beeqnLocation startFindingGPS];
        self.statusLabel.text = @"Finding GPS Location";
        [self.activityIndicator startAnimating];
        self.activityIndicator.hidden = NO;
        self.navigationItem.rightBarButtonItem.title = @"Stop Scan";
    }
}

- (IBAction)switchValueChanged:(id)sender
{
    if(sender == self.isAutoPerformActionSwitch)
    {
        [self setAutoPerformAction:self.isAutoPerformActionSwitch.isOn];
    }
}

-(BOOL) isAutoPerformingAction
{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"autoperform"];
    if(!obj)
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"autoperform"];
        obj = [NSNumber numberWithBool:YES];
    }
    return [obj boolValue];
}

-(void) setAutoPerformAction:(BOOL) autoperfom
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:autoperfom] forKey:@"autoperform"];
}

#pragma mark BeeQnLocationManagerProtocol

- (void)manager:(BeeQnLocationManager*)manager hasFoundBeacon:(BQBeacon*)beacon
{
    self.navigationItem.rightBarButtonItem.title = @"Start Scan";
    [self.beeqnLocation stopFindingBeacons];
    [self.beeqnService get_BeeQnInformation:beacon.UUID major:beacon.major minor:beacon.minor];
    [self.activityIndicator stopAnimating];
    
    
    NSLog(@"%@", beacon);
}

- (void)manager:(BeeQnLocationManager*)manager hasFoundGPS:(CLLocation*)gpslocation
{
    [manager stopFindingGPS];
    self.longitudeTextLabel.text = [NSString stringWithFormat:@"Longitude: %f", gpslocation.coordinate.longitude];
    self.latitudeTextLabel.text = [NSString stringWithFormat:@"Latitude: %f", gpslocation.coordinate.latitude];


     self.statusLabel.text = @"Finding UUIDs";
    [self.beeqnService get_BeaconListForLocation:gpslocation];
}

- (void)manager:(BeeQnLocationManager*)manager hasFoundBeacons:(NSArray*)beacons
{
    NSMutableString* mutable = [[NSMutableString alloc] initWithString:@""];

    for (BQBeacon* beacon in beacons)
    {
        NSInteger rss = [self.beeqnLocation.beaconCounter meanRSSI:beacon];
        
        [mutable appendFormat:@"%@, %@, %ld, acc:%f\n", beacon.major, beacon.minor, rss, beacon.accuracy];
    }
    self.textlabel.text = [NSString stringWithFormat:@"Found :%lu beacons\n%@", (unsigned long) beacons.count, mutable];
}

-(void)manager:(BeeQnLocationManager *)manager hasFoundBeaconsTimes:(int)times fromMaximumSearch:(int)maximum
{
    [self.circleProgress setCurrentValue:times maximumValue:maximum update:YES];
}

- (void)manager:(BeeQnLocationManager*)manager didReceiveError:(NSError*)error
{
    NSLog(@"BeeQnLocationManagerError: %@", error);
}


#pragma mark - BeeQnService

- (void)service:(id)beeqnservice didFailWithError:(NSError*)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    NSLog(@"%@", error);
}

- (void)service:(id)beeqnservice foundList:(NSArray*)listItems withTitle:(NSString*)title andSize:(BeeQnListSize)size;
{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];


    if(self.isAutoPerformActionSwitch.isOn)
    {
        BQListViewController* con = [[BQListViewController alloc] initWith:listItems title:title size:size];
        [self.navigationController pushViewController:con animated:YES];
    }
    else
    {
        self.bqAlert = [BQAlert showAlert:@"Perform?" message:@"Show the list?" action:^(NSInteger index)
                        {
                            self.bqAlert = nil;
                            
                            if(index == 0)
                            {
                                BQListViewController* con = [[BQListViewController alloc] initWith:listItems title:title size:size];
                                [self.navigationController pushViewController:con animated:YES];
                            }
                        }
                        cancelButtonTitle:@"OK" others:@"Cancel",nil];
    }
   
    //automatically disables ranging beacons
}

- (void)service:(id)beeqnservice foundBeaconsUUIDs:(NSArray*)uuids
{
    self.statusLabel.text = @"Looking for Beacons";
    [self.beeqnLocation updateRegions:uuids];
    
    NSLog(@"%@", uuids);

    if (!self.beeqnLocation.isBeaconFetchInProgress)
    {
        [self.beeqnLocation startFindingBeacons];
    }
}


- (void)service:(id)beeqnservice foundAlert:(NSString*)title message:(NSString*)message
{
    self.bqAlert = [BQAlert showAlert:title message:message action:^(NSInteger index)
                    {
                        self.bqAlert = nil;
                    }
                    cancelButtonTitle:@"OK" others:nil];
}


- (void)service:(id)beeqnservice foundURL:(NSURL*)url
{
    WebViewViewController* web = [[WebViewViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)service:(id)beeqnservice foundCustom:(NSString*)custom
{
    self.bqAlert = [BQAlert showAlert:@"Found custom" message:@"SomeCustomstuff" action:^(NSInteger bt){self.bqAlert = nil;}
                    cancelButtonTitle:@"ok" others: nil];
    //NSLog(@"CUSTOM: %@", custom);
}


@end
