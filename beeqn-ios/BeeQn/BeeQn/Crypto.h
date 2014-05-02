//
//  Crypto.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 24.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Crypto : NSObject

/**
 *  Returns an HMAC of given plaintext in Hex-Format given a key to use for SHA256
 *
 *  @param plaintext the plaintext to authenticate
 *  @param key       the key to use
 *
 *  @return a string containing the hmac256 in Hex-Format
 */
+(NSString *)hmac256:(NSString *)plaintext withKey:(NSString *)key;


@end
