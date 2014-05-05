//
//  DebugViewController.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 23.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "DebugViewController.h"

#import "MainViewController.h"
#import "IndoorTrackingViewController.h"
#import "SubmitBeaconViewController.h"
#import "SingleBeaconTrackingViewController.h"

@interface DebugViewController ()

@end

@implementation DebugViewController


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.title = @"BeeQn";
    }
    return self;
}

- (IBAction)findiBeaconAction:(id)sender
{
    [self.navigationController pushViewController:[[MainViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
}

- (IBAction)indoortrackingAction:(id)sender
{
    [self.navigationController pushViewController:[[IndoorTrackingViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
}
- (IBAction)submitiBeaconAction:(id)sender
{
    [self.navigationController pushViewController:[[SubmitBeaconViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
}
- (IBAction)singleBeaconTrackingAction:(id)sender
{
     [self.navigationController pushViewController:[[SingleBeaconTrackingViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
}

@end
