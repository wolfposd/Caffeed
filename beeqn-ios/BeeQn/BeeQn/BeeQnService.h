//
// Created by Wolf Posdorfer on 09.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum
{
    kListSizeSmall = 44,
    kListSizeBig = 80
} BeeQnListSize;


@protocol BeeQnServiceProtocol


@optional

- (void)service:(id)beeqnservice didFailWithError:(NSError*)error;

- (void)service:(id)beeqnservice foundCustom:(NSString*)custom;

- (void)service:(id)beeqnservice foundList:(NSArray*)listItems withTitle:(NSString*)title andSize:(BeeQnListSize)size;

- (void)service:(id)beeqnservice foundURL:(NSURL*)url;

/**
 *  Service has found a List of UUIDS
 *
 *  @param beeqnservice the service
 *  @param uuids        NSArray of NSString
 */
- (void)service:(id)beeqnservice foundBeaconsUUIDs:(NSArray*)uuids;

- (void)service:(id)beeqnservice foundAlert:(NSString*) title message:(NSString*) message;

@end


@interface BeeQnService : NSObject


@property (nonatomic, weak) NSObject <BeeQnServiceProtocol>* delegate;

/**
 *  Fetches a UUID List for the closest locatons
 *
 *  Callbacks will be made to service:foundBeaconsUUIDs:
 *
 *  @param location the GPS-Location
 */
- (void)fetchBeaconListForLocation:(CLLocation*)location;


- (void)fetchBeeQnInformation:(NSString*)UUID major:(NSNumber*)major minor:(NSNumber*)minor;


@end