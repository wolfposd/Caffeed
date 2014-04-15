//
//  BQBeacon.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 15.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



typedef NS_ENUM(NSInteger, BQProximity) {
    BQProximityUnknown,
    BQProximityImmediate,
    BQProximityNear,
    BQProximityFar
};

@interface BQBeacon : NSObject

@property (nonatomic,retain, readonly) NSString* UUID;
@property (nonatomic,retain, readonly) NSNumber* major;
@property (nonatomic,retain, readonly) NSNumber* minor;
@property (nonatomic, readonly) BQProximity proximity;
@property (nonatomic, readonly) double accuracy;
@property (nonatomic, readonly) NSInteger rssi;


+(id) beacon:(CLBeacon*)beacon;
+(id) beacon:(NSString*) uuid major:(NSNumber*) major minor:(NSNumber*) minor proximity:(CLProximity) prox accuracy:(CLLocationAccuracy) accuracy rssi:(NSInteger) rssi;

-(NSString *) distance;


-(void) updateValuesFrom:(BQBeacon*) thisBeacon;

@end
