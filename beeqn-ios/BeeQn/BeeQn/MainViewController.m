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

@interface MainViewController () <BeeQnServiceProtocol, BeeQnLocationManagerProtocol>
@property (weak, nonatomic) IBOutlet UILabel* textlabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeTextLabel;

@property (retain, nonatomic) BeeQnService* beeqnService;
@property (retain, nonatomic) BeeQnLocationManager* beeqnLocation;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

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
    self.activityIndicator.color = [UIColor blackColor];
    
   self.activityIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
    self.beeqnService = [[BeeQnService alloc] init];
    self.beeqnService.delegate = self;


    self.beeqnLocation = [[BeeQnLocationManager alloc] init];
    self.beeqnLocation.delegate = self;


    // FETCH UUID FOR GPS
    NSString* uuid = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    [self.beeqnLocation updateRegions:@[uuid]];

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
        [self.beeqnLocation startFindingBeacons];

        [self.beeqnLocation startFindingGPS];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable Location Services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{

    NSLog(@"%@", @"view did disappear");

    [super viewDidDisappear:animated];
    [self.beeqnLocation stopFindingBeacons];
}



#pragma mark BeeQnLocationManagerProtocol

- (void)manager:(BeeQnLocationManager*)manager hasFoundBeacon:(CLBeacon*)beacon
{
    NSLog(@"FOUND BEACON: %@\n %f", beacon, beacon.accuracy);
    [self.beeqnLocation stopFindingBeacons];
    [self.beeqnService fetchBeeQnInformation:beacon.proximityUUID.UUIDString major:beacon.major minor:beacon.minor];
}

- (void)manager:(BeeQnLocationManager*)manager hasFoundGPS:(CLLocation*)gpslocation
{
    [manager stopFindingGPS];
    self.longitudeTextLabel.text = [NSString stringWithFormat:@"Longitude: %f", gpslocation.coordinate.longitude];
    self.latitudeTextLabel.text = [NSString stringWithFormat:@"Latitude: %f", gpslocation.coordinate.latitude];
}

- (void)manager:(BeeQnLocationManager*)manager hasFoundBeacons:(NSArray*)beacons
{
    NSMutableString* mutable = [[NSMutableString alloc] initWithString:@""];

    for (CLBeacon* beacon in beacons)
    {
        [mutable appendFormat:@"%@, %@, %ld, acc:%f\n", beacon.major, beacon.minor, (long) beacon.rssi, beacon.accuracy];
    }
    self.textlabel.text = [NSString stringWithFormat:@"Found :%lu beacons\n%@", (unsigned long) beacons.count, mutable];
}

- (void)manager:(BeeQnLocationManager*)manager didReceiveError:(NSError*)error
{

}




#pragma mark - BeeQnService

- (void)service:(id)beeqnservice didFailWithError:(NSError*)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't fetch stuff" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)service:(id)beeqnservice foundList:(NSArray*)listItems withTitle:(NSString*)title andSize:(BeeQnListSize) size;
{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    
    
    BQListViewController* con = [[BQListViewController alloc] initWith:listItems title:title size:size];
    [self.navigationController pushViewController:con animated:YES];
    //automatically disables ranging beacons
}


@end
