//
//  BQBeaconCounter.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 15.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BQBeacon.h"

@interface BQBeaconCounter : NSObject

-(void) increaseCountFor:(NSArray*) beacons;

-(BQBeacon*) closestBeaconFrom:(NSArray*) beacons;

-(BQBeacon*) closestBeacon;

-(void) resetCount;

-(NSInteger) meanRSSI:(BQBeacon*) beacon;

@end
