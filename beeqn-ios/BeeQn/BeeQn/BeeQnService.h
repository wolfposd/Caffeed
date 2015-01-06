//
// Created by Wolf Posdorfer on 09.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum
{
    kNoError = 0,
    kNoInfoOnServerForBeacon = 100
}
BeeQnErrorCodes;



typedef enum
{
    kListSizeSmall = 44,
    kListSizeBig = 80
} BeeQnListSize;

/**
 *  The Delegate Protocol
 */
@protocol BeeQnServiceProtocol
@optional

/**
 *  The Service has experienced an Error
 *
 *  @param beeqnservice sender
 *  @param error        experienced Error
 */
- (void)service:(id)beeqnservice didFailWithError:(NSError*)error;

- (void)service:(id)beeqnservice foundCustom:(NSString*)custom;

- (void)service:(id)beeqnservice foundList:(NSArray*)listItems withTitle:(NSString*)title andSize:(BeeQnListSize)size;

- (void)service:(id)beeqnservice foundURL:(NSURL*)url;

- (void)service:(id)beeqnservice foundFloorData:(id) floorData;

- (void)service:(id)beeqnservice insertedBeaconsWithResult:(NSArray*) result;

- (void)service:(id)beeqnservice insertedTestDataWithResult:(NSData*) result;

/**
 *  Service has found a List of UUIDS.
 *
 *  These can be used for scanning.
 *
 *  @param beeqnservice the service
 *  @param uuids        NSArray of NSString
 */
- (void)service:(id)beeqnservice foundBeaconsUUIDs:(NSArray*)uuids;

- (void)service:(id)beeqnservice foundAlert:(NSString*) title message:(NSString*) message;

@end

/**
 *  The Beeqn service for contacting the BeeQn-Server
 */
@interface BeeQnService : NSObject


@property (nonatomic, weak) NSObject <BeeQnServiceProtocol>* delegate;

/**
 *  Fetches a UUID List for the closest locatons
 *
 *  Callbacks will be made to service:foundBeaconsUUIDs:
 *
 *  @param location the GPS-Location
 */
- (void)get_BeaconListForLocation:(CLLocation*)location;

/**
 *  Fetches the Information to be displayed by the App
 *
 *  This can be a number of things: List, Big-List, Alert, Website, Custom, etc...
 *
 *  @param UUID  UUID of Beacon
 *  @param major major of Beacon
 *  @param minor minor of Beacon
 */
- (void)get_BeeQnInformation:(NSString*)UUID major:(NSNumber*)major minor:(NSNumber*)minor;

/**
 *  Fetches the Floorplan for given Beacon
 *
 *  @param UUID  UUID of Beacon
 *  @param major major of Beacon
 *  @param minor minor of Beacon
 */
- (void)get_FloorPlanFor:(NSString*) UUID major:(NSNumber*)major minor:(NSNumber*)minor;

/**
 *  Inserts given array of Beacons into the Database
 *
 *  Callbacks will be made to: service:(id)beeqnservice insertedBeaconsWithResult:(NSArray*) result;
 *
 *  @param beacons  an array of BQBeacon
 *  @param user     the User-Account from BeeQn-Service
 *  @param key      the Application-Key from BeeQn-Service
 *  @param location the GPS-Location of these Beacons
 */
- (void)put_BeaconsInDB:(NSArray*) beacons user:(NSString*) user key:(NSString*) key location:(CLLocationCoordinate2D) location;

/**
 *  Inserts the given data-string into the Database
 *
 *  @param data some string
 *  @param user the User-Account
 *  @param key  the Application-Key
 */
-(void) put_TestingData:(NSString*)data user:(NSString*) user key:(NSString*) key;


@end