//
//  ViewController.m
//  FeedbackBeaconContext
//
//  Created by Wolf Posdorfer on 28.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "ViewController.h"

#import "BCBeaconContextViewController.h"
#import "FeedbackBeaconContext-Swift.h"


@interface ViewController ()

@end

@implementation ViewController

-(void) viewDidAppear:(BOOL)animated
{
    
//    FeedbackSheet* sheet = [[FeedbackSheet alloc] initWithTitle:@"title" ID:3 pages:[NSMutableArray new]];
//    
//    FeedbackSheetPageTableViewController* table = [[FeedbackSheetPageTableViewController alloc] initWithNibName:@"FeedbackSheetPageTableViewController" bundle:nil];
//    
//    FeedbackSheetViewController* controller = [[FeedbackSheetViewController alloc] initWithNibName:@"FeedbackSheetViewController" bundle:nil];
//    controller.pageTVC = table;
//    controller.view = table.view;
//    
//    [controller prepareSheet:sheet];
//    
//    NSLog(@"%@", controller);
//    
//    [self presentViewController: controller animated:NO completion:NULL];
//    
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController: [[BCBeaconContextViewController alloc] init]];
    
    [self presentViewController:nav animated:NO completion:NULL];
}

@end
