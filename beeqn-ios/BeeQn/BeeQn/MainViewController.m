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

@interface MainViewController () <BeeQnServiceProtocol, BeeQnLocationManagerProtocol>
@property (weak, nonatomic) IBOutlet UILabel* textlabel;
@property (weak, nonatomic) IBOutlet UILabel* longitudeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel* latitudeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (retain, nonatomic) BeeQnService* beeqnService;
@property (retain, nonatomic) BeeQnLocationManager* beeqnLocation;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;


@property (nonatomic,retain) id bqAlert;

@end

@implementation MainViewController


- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.activityIndicator.hidden = YES;
    self.activityIndicator.color = [UIColor blueColor];

    self.activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);

    self.beeqnService = [[BeeQnService alloc] init];
    self.beeqnService.delegate = self;


    self.beeqnLocation = [[BeeQnLocationManager alloc] init];
    self.beeqnLocation.delegate = self;


    UIBarButtonItem* scan = [[UIBarButtonItem alloc] initWithTitle:@"Scan" style:UIBarButtonItemStyleBordered target:self
                                                            action:@selector(barButtonItemScan:)];

    self.navigationItem.leftBarButtonItem = scan;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@", @"View did Appear");


    if (self.beeqnLocation.isBluetoothOn && self.beeqnLocation.isFindingBeaconsPossible
            && self.beeqnLocation.isLocationServicesEnabled)
    {

        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        [self.beeqnLocation startFindingGPS];
        self.statusLabel.text = @"Finding GPS Location";
    }
    else
    {
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
    NSLog(@"%@", @"view did disappear");

    [self.beeqnLocation stopFindingBeacons];
    [super viewDidDisappear:animated];
}


-(void) barButtonItemScan:(id) sender
{

    if(self.beeqnLocation.isBeaconFetchInProgress)
    {
         self.statusLabel.text = @"Nothing in Progress";
        [self.beeqnLocation stopFindingBeacons];
        [self.activityIndicator stopAnimating];
    }
    else
    {
        [self.beeqnLocation startFindingGPS];
        self.statusLabel.text = @"Finding GPS Location";
        [self.activityIndicator startAnimating];
    }
}

#pragma mark BeeQnLocationManagerProtocol

- (void)manager:(BeeQnLocationManager*)manager hasFoundBeacon:(BQBeacon*)beacon
{
    NSLog(@"FOUND BEACON: %@\n %f", beacon, beacon.accuracy);
    [self.beeqnLocation stopFindingBeacons];
    [self.beeqnService fetchBeeQnInformation:beacon.UUID major:beacon.major minor:beacon.minor];
    [self.activityIndicator stopAnimating];
}

- (void)manager:(BeeQnLocationManager*)manager hasFoundGPS:(CLLocation*)gpslocation
{
    [manager stopFindingGPS];
    self.longitudeTextLabel.text = [NSString stringWithFormat:@"Longitude: %f", gpslocation.coordinate.longitude];
    self.latitudeTextLabel.text = [NSString stringWithFormat:@"Latitude: %f", gpslocation.coordinate.latitude];


     self.statusLabel.text = @"Finding UUIDs";
    [self.beeqnService fetchBeaconListForLocation:gpslocation];
}

- (void)manager:(BeeQnLocationManager*)manager hasFoundBeacons:(NSArray*)beacons
{

    NSLog(@"%@ %lu", @"has found beacons", (unsigned long) beacons.count);
    NSMutableString* mutable = [[NSMutableString alloc] initWithString:@""];

    for (BQBeacon* beacon in beacons)
    {
        NSInteger rss = [self.beeqnLocation.beaconCounter meanRSSI:beacon];
        
        [mutable appendFormat:@"%@, %@, %ld, acc:%f\n", beacon.major, beacon.minor, rss, beacon.accuracy];
    }
    self.textlabel.text = [NSString stringWithFormat:@"Found :%lu beacons\n%@", (unsigned long) beacons.count, mutable];
}

- (void)manager:(BeeQnLocationManager*)manager didReceiveError:(NSError*)error
{

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


    BQListViewController* con = [[BQListViewController alloc] initWith:listItems title:title size:size];
    [self.navigationController pushViewController:con animated:YES];
    //automatically disables ranging beacons
}

- (void)service:(id)beeqnservice foundBeaconsUUIDs:(NSArray*)uuids
{
    self.statusLabel.text = @"Looking for Beacons";
    [self.beeqnLocation updateRegions:uuids];

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
    NSLog(@"URL: %@", url);
}

- (void)service:(id)beeqnservice foundCustom:(NSString*)custom
{
    NSLog(@"CUSTOM: %@", custom);

}


@end
