//
//  PresentationViewController.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 09.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "PresentationViewController.h"
#import "BeeQn.h"


@interface PresentationViewController ()<BeeQnLocationManagerProtocol, BeeQnServiceProtocol>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet PSBorderButton *startStopButton;
@property (retain, nonatomic) BeeQnService* beeqnService;
@property (retain, nonatomic) BeeQnLocationManager* beeqnLocation;

@property (nonatomic) BOOL isFetching;


@end

@implementation PresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFetching = false;
    
    self.beeqnService = [[BeeQnService alloc] init];
    self.beeqnService.delegate = self;
    
    self.beeqnLocation = [[BeeQnLocationManager alloc] init];
    self.beeqnLocation.delegate = self;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.activityIndicator.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - stuff

- (IBAction)startStopButtonTouchUpInside:(id)sender
{
    if(!self.isFetching)
    {
        [self startFetching:sender];
    }
    else
    {
        [self stopFetching:sender];
    }
  
    
}


-(void) startFetching:(id) sender
{
    [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    self.isFetching = YES;
    NSLog(@"%@", @"Start Fetching");
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    [self.beeqnLocation startFindingBeacons];
    
}


-(void) stopFetching:(id) sender
{
    [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    self.isFetching = NO;
    NSLog(@"%@", @"Stop Fetching");
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    
    [self.beeqnLocation stopFindingBeacons];
}



#pragma mark - BeeQnProtocols

-(void)manager:(BeeQnLocationManager *)manager hasFoundBeacon:(BQBeacon *)beacon
{
    NSLog(@"%@", @"close found");
    NSLog(@"%@", beacon.description);
    
    
    [self stopFetching:nil];
    [self.beeqnService get_BeeQnInformation:beacon.UUID major:beacon.major minor:beacon.minor];
    
}

-(void)manager:(BeeQnLocationManager *)manager hasFoundBeacons:(NSArray *)beacons
{
    NSLog(@"%@", beacons);
}

-(void)manager:(BeeQnLocationManager *)manager hasFoundBeaconsTimes:(int)times fromMaximumSearch:(int)maximum
{
    NSLog(@"Run %d / %d", times, maximum);
}


-(void)service:(id)beeqnservice foundList:(NSArray *)listItems withTitle:(NSString *)title andSize:(BeeQnListSize)size
{
    NSLog(@"%@", @"found list");
    BQListViewController* con = [[BQListViewController alloc] initWith:listItems title:title size:size];
    [self.navigationController pushViewController:con animated:YES];
}


-(void)service:(id)beeqnservice didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

@end
