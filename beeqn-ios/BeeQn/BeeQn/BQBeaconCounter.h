//
//  BQBeaconCounter.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 15.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BQBeaconCounter : NSObject

-(void) increaseCountFor:(NSArray*) beacons;

-(CLBeacon*) closestBeaconFrom:(NSArray*) beacons;


-(void) resetCount;

-(NSInteger) meanRSSI:(CLBeacon*) beacon;

@end
