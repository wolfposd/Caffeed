//
//  FileLog.h
//  FeedbackBeaconContext
//
//  Created by Wolf Posdorfer on 29.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileLog : NSObject

/**
 *  Writes the String to the File Log
 *
 *  @param string any string
 */
+(void) log:(NSString*) string;


+(void) printLogToConsole;

@end
