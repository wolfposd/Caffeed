//
//  BCBeaconMonitor.h
//  BeaconContext
//
//  Created by Wolf Posdorfer on 01.07.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BCBeaconMonitorDelegate <NSObject>

@optional

/**
 *  BeaconMonitor has Entered a Region
 *
 *  @param region CLRegion object
 */
-(void) enterRegion:(id) region;

/**
 *  BeaconMonitor has Exited a Region
 *
 *  @param region CLRegion object
 */
-(void) exitRegion:(id) region;

/**
 *  BeaconMonitor has determined State
 *
 *  @param state CLRegionState
 *  @param region CLRegion
 */
-(void) state:(NSInteger) state forRegion:(id)region;

/**
 *  BeaconMonitor has ranged beacons
 *
 *  @param beacons Array of CLBeacon
 */
-(void) rangedBeacons:(NSArray*) beacons;

/**
 *  The Location has changed
 */
-(void) locationWasUpdated;
@end



@interface BCBeaconMonitor : NSObject

@property (nonatomic, weak) id<BCBeaconMonitorDelegate> delegate;

-(void) startBeaconRegion;

-(void) stopBeaconRegion;

-(void) startRanging;

-(void) stopRanging;

@end


