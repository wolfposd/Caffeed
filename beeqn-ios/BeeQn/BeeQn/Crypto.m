//
//  Crypto.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 24.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "Crypto.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation Crypto



+(NSString *)hmac256:(NSString *)plaintext withKey:(NSString *)key
{
    const char* ptr = [plaintext UTF8String];
    const char* keyPtr = [key UTF8String];
    
    unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, keyPtr, strlen(keyPtr), ptr, strlen(ptr), buffer);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x",buffer[i]];
    }
    return output;
}


@end
