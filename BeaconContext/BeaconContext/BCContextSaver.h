//
//  BCContextSaver.h
//  BeaconContext
//
//  Created by Wolf Posdorfer on 28.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCBeacon.h"

/**
 *  Saves Context Information from various sources
 */
@interface BCContextSaver : NSObject

/**
 *  A BeaconEvent was found
 *
 *  @param beacon the beacon event, with timestamp and type
 */
-(void) foundBeacon:(BCBeacon*) beacon;


/**
 *  Information about the user where aqcuired
 *
 *  @param name  the type of information, e.g. "username"
 *  @param value the value of the information
 */
-(void) foundUserInformation:(NSString*) name value:(NSString*) value;

/**
 *  Returns the json-String for sending to remote
 *
 *  @return JSON or nil
 */
-(NSString*) jsonString;

@end
