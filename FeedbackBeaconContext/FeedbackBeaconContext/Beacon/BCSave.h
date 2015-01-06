//
//  BCSave.h
//  BeaconContext
//
//  Created by Wolf Posdorfer on 01.07.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCSave : NSObject


+(void) appendString:(NSString*) string;

+(void) saveString:(NSString*) string;


+(NSString*) loadString;

@end
