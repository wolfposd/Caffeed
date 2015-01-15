//
//  BeaconOrderer.h
//  FeedbackBeaconContext
//
//  Created by Wolf Posdorfer on 29.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCBeacon.h"

@interface BeaconOrderer : NSObject

-(void) addBeacon:(BCBeacon*) beacon;


-(NSArray*) savedBeacons;


-(int) amountOfBeaconEnters;
-(int) amountOfBeaconExits;

/**
 *  removes all entries
 */
-(void) clear;

@end
