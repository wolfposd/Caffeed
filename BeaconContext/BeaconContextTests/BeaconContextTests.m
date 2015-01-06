//
//  BeaconContextTests.m
//  BeaconContextTests
//
//  Created by Wolf Posdorfer on 01.07.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "BCContextSaver.h"
#import "BCBeacon.h"


@interface BeaconContextTests : XCTestCase

@end

@implementation BeaconContextTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testContextSaver
{
    
    NSString* uuid= @"00000000-0000-0000-0000-000000000000";
    
    BCContextSaver* saver = [BCContextSaver new];
    
    for(int i = 0; i < 10; i++)
    {
        NSNumber* num = [NSNumber numberWithInt:i];
        BCBeacon* beacon = [BCBeacon beaconWith:uuid major:num minor:num seen:[NSDate new] type:BCBeaconSeenTypeEnter];
        BCBeacon* beacon2 = [BCBeacon beaconWith:uuid major:num minor:num seen:[NSDate new] type:BCBeaconSeenTypeExit];

        [saver foundBeacon:beacon];
        [saver foundBeacon:beacon2];
    }
    
    
    NSLog(@"%@", saver.jsonString);
    
}

@end
