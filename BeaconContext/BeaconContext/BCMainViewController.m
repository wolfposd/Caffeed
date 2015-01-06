//
//  BCMainViewController.m
//  BeaconContext
//
//  Created by Wolf Posdorfer on 01.07.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BCMainViewController.h"
#import "BCBeaconMonitor.h"
#import "BCSave.h"

#import <CoreLocation/CoreLocation.h>

@interface BCMainViewController ()<BCBeaconMonitorDelegate>

@property (nonatomic,retain) BCBeaconMonitor* beaconMonitor;
@property (weak, nonatomic) IBOutlet UITextView *textview;

@property(nonatomic,retain) NSDateFormatter* formatter;
@property (weak, nonatomic) IBOutlet UIButton *startButton;


@property (nonatomic) BOOL isRunning;

@end

@implementation BCMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.beaconMonitor = [[BCBeaconMonitor alloc] init];
        self.beaconMonitor.delegate = self;
        
        
        self.formatter = [[NSDateFormatter alloc] init];
        self.formatter.dateFormat = @"HH:mm:ss";
        self.isRunning = NO;
        
    }
    return self;
}

- (IBAction)clearButtonPressed:(id)sender
{
    self.textview.text = @"";
}

- (IBAction)startButtonPressed:(id)sender
{
    if(self.isRunning)
    {
        [self.beaconMonitor stopBeaconRegion];
        
        NSString* string =[NSString stringWithFormat:@"%@\n%@ %@", self.textview.text, [self.formatter stringFromDate:[NSDate date]],@"Stopping"];
        
        [BCSave saveString:string];
        
        self.textview.text =  string;
    }
    else
    {
        [self.beaconMonitor startBeaconRegion];
        
        NSString* string =[NSString stringWithFormat:@"%@\n%@ %@", self.textview.text, [self.formatter stringFromDate:[NSDate date]],@"Starting"];
        
        [BCSave saveString:string];
        
        self.textview.text =  string;
    }
    
    self.isRunning = !self.isRunning;
    
   [self.startButton setTitle: self.isRunning? @"STOP" : @"START" forState:UIControlStateNormal];
    
}
- (IBAction)loadButtonPressed:(id)sender
{
    self.textview.text = [@"LOAD" stringByAppendingString:[BCSave loadString]];
}


-(void)enterRegion:(id)region
{
    [self localNotification:@"Enter Region"];
    
    [self appendTextToView:@"enterRegion"];
}

-(void)exitRegion:(id)region
{
    [self localNotification:@"Exit Region"];
    
    [self appendTextToView:@"exitRegion"];

    
    
    
}

-(void)state:(NSInteger)state forRegion:(id)region
{
    NSString* stateString = state == 0 ? @"Unknown" : (state == 1 ? @"enter" : @"exit");
    
    [self appendTextToView:[NSString stringWithFormat:@"state:%@ region:%@", stateString,region]];
}

-(void)rangedBeacons:(NSArray *)beacons
{
    //[self localNotification:[NSString stringWithFormat:@"Ranging: %ld",beacons.count]];
    
    NSMutableString* ranges = [NSMutableString new];
    
    for(CLBeacon* beacon in beacons)
    {
        [ranges appendFormat:@"acc:%f \n",beacon.accuracy ];
    }
    
    [self appendTextToView:ranges];
    
    [self appendTextToView:[NSString stringWithFormat:@"rangingBeacons: %ld", (unsigned long)beacons.count]];
}

-(void)locationWasUpdated
{
    NSLog(@"%@", @"Location was updated");
    [self.beaconMonitor startRanging];
    [NSThread sleepForTimeInterval:4.0f];
    [self.beaconMonitor stopRanging];
}

-(void) appendTextToView:(NSString*) string
{
    string =  [NSString stringWithFormat:@"%@\n%@ %@", self.textview.text, [self.formatter stringFromDate:[NSDate date]],string];
    self.textview.text = string;
    [BCSave saveString:string];

}

-(void) localNotification:(NSString*) string
{
    NSLog(@"%@", @"Firing Local Notification");
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = string;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


#pragma mark - IBActions


@end
