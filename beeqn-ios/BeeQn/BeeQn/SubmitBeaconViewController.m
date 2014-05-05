//
//  SubmitBeaconViewController.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 24.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "SubmitBeaconViewController.h"
#import "BeeQn.h"
#import "Crypto.h"
#import "NSString+Base64.h"

@interface SubmitBeaconViewController ()<BeeQnServiceProtocol,BeeQnLocationManagerProtocol>
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet BQCircleProgress *circleProgress;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic) CLLocationCoordinate2D currentCoordinate;

@property(nonatomic,retain) BeeQn* beeqn;

@end

@implementation SubmitBeaconViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Submit iBeacon";
        
        self.beeqn = [[BeeQn alloc] initWith:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
#ifdef DEBUG
    self.accountField.text = @"wolf@posdorfer.de";
    self.passwordField.text = @"jYFhzt85Yz1eHTde8";
#endif
    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
     [self.beeqn.locatioManager startFindingGPS];
    self.statusLabel.text = @"Looking for GPS";
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.beeqn.locatioManager stopFindingBeacons];
    [self.beeqn.locatioManager stopFindingGPS];
}

#pragma mark - IBActions

- (IBAction)sendButtonAction:(id)sender
{
    
//    [self sendBeacons:@[
//                        [BQBeacon beacon:@"10000000-0000-0000-0000-000000000000" major:@1 minor:@2 proximity:CLProximityImmediate accuracy:0.9 rssi:-72],
//                        [BQBeacon beacon:@"10000000-0000-0000-0000-000000000000" major:@2 minor:@3 proximity:CLProximityImmediate accuracy:0.9 rssi:-72],
//                        [BQBeacon beacon:@"10000000-0000-0000-0000-000000000000" major:@3 minor:@4 proximity:CLProximityImmediate accuracy:0.9 rssi:-72]
//                        ]
//     ];
    
    [self sendBeacons:self.beeqn.locatioManager.beaconCounter.allBeaconsSorted];
}


-(void) sendBeacons:(NSArray*) bqBeacons
{
    [self.beeqn.serviceManager put_BeaconsInDB:bqBeacons user:self.accountField.text key:self.passwordField.text location:self.currentCoordinate];
}



#pragma mark - BeeQnService

-(void)manager:(BeeQnLocationManager *)manager hasFoundGPS:(CLLocation *)gpslocation
{
    [manager stopFindingGPS];
    
    self.currentCoordinate = gpslocation.coordinate;
    
    
    self.statusLabel.text = @"Looking for UUIDs";
    [self.beeqn.serviceManager get_BeaconListForLocation:gpslocation];
}

-(void)manager:(BeeQnLocationManager *)manager hasFoundBeacons:(NSArray *)beacons
{
    self.statusLabel.text = [NSString stringWithFormat:@"has found beacons: %d", (int)beacons.count];
}


-(void)manager:(BeeQnLocationManager *)manager hasFoundBeaconsTimes:(int)times fromMaximumSearch:(int)maximum
{
    [self.circleProgress setCurrentValue:times maximumValue:maximum update:YES];
    
    if(times >= maximum)
    {
        [self.circleProgress setCurrentValue:maximum maximumValue:maximum update:YES];
        [self.beeqn.locatioManager stopFindingBeacons];
        self.statusLabel.text = [self.statusLabel.text stringByAppendingString:@"\nDone Finding"];
    }
}

-(void)service:(id)beeqnservice foundBeaconsUUIDs:(NSArray *)uuids
{
    self.statusLabel.text = @"Scanning iBeacons";
    [self.beeqn.locatioManager updateRegions:uuids];
    [self.beeqn.locatioManager startFindingBeacons];
}


-(void)service:(id)beeqnservice insertedBeaconsWithResult:(NSArray *)result
{
    int count = (int)result.count;
    int successes = 0;
    for(NSDictionary* dict in result)
    {
        NSNumber* success = [dict objectForKey:@"successfullinsert"];
        
        if(success.intValue != 0)
        {
            successes++;
        }
    }
    
    self.statusLabel.text =  [NSString stringWithFormat:@"Inserted %d/%d",successes,count];
}



@end
