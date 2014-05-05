//
//  SingleBeaconTrackingViewController.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 05.05.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "SingleBeaconTrackingViewController.h"
#import "BeeQn.h"

@interface SingleBeaconTrackingViewController ()<BeeQnLocationManagerProtocol,BeeQnServiceProtocol>

@property (nonatomic,retain) BeeQn* beeqn;

@property (weak, nonatomic) IBOutlet UITextField *distanceTextField;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;
@property (weak, nonatomic) IBOutlet BQCircleProgress *circleProgress;

@end

@implementation SingleBeaconTrackingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.beeqn = [[BeeQn alloc] initWith:self];
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    self.distanceTextField.text = @"1";
}

#pragma mark - IBActions

- (IBAction)tapGestureRecognized:(id)sender
{
    [self.distanceTextField resignFirstResponder];
    [self.outputTextView resignFirstResponder];
}
- (IBAction)startStopAction:(id)sender
{
    
    if(self.beeqn.locatioManager.isBeaconFetchInProgress)
    {
        [self.beeqn.locatioManager stopFindingBeacons];
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setObject:self.outputTextView.text forKey:@"measures"];
        [dict setObject:self.distanceTextField.text forKey:@"distance"];
        
        [self.beeqn.serviceManager put_TestingData:[dict description] user:@"wolf@posdorfer.de" key:@"jYFhzt85Yz1eHTde8"];
    }
    else
    {
        self.outputTextView.text = @"";
        [self.beeqn.locatioManager startFindingGPS];
    }
    
}

#pragma mark - iBeacon

-(void)manager:(BeeQnLocationManager *)manager hasFoundGPS:(CLLocation *)gpslocation
{
    [manager stopFindingGPS];
    [self.beeqn.serviceManager get_BeaconListForLocation:gpslocation];
}

-(void)service:(id)beeqnservice foundBeaconsUUIDs:(NSArray *)uuids
{
    [self.beeqn.locatioManager startFindingBeaconsInfiniteTime];
}

-(void)manager:(BeeQnLocationManager *)manager hasFoundBeacons:(NSArray *)beacons
{
    NSString* text = self.outputTextView.text;
    
    for(BQBeacon* beacon in beacons)
    {
        
        NSString* beaconString = [NSString stringWithFormat:@"%@, %@, %@, %ld, %f\n", beacon.UUID, beacon.major, beacon.minor, (long)beacon.rssi, beacon.accuracy];
        
        text = [text stringByAppendingString:beaconString];
    }
    
    
    self.outputTextView.text = text;
}

-(void)manager:(BeeQnLocationManager *)manager hasFoundBeaconsTimes:(int)times fromMaximumSearch:(int)maximum
{
    [self.circleProgress setCurrentValue:times maximumValue:times update:YES];
}


@end
