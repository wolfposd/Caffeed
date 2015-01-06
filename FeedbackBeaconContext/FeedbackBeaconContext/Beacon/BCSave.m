//
//  BCSave.m
//  BeaconContext
//
//  Created by Wolf Posdorfer on 01.07.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BCSave.h"
#import "Crypto.h"
#import "NSString+Base64.h"


#define DEFAULTKEY @"key"

@implementation BCSave

static NSString* baseURL = @"http://beeqn.informatik.uni-hamburg.de/rest.php/";


+(void)saveString:(NSString *)string
{
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:DEFAULTKEY];
}

+(void) appendString:(NSString*) string
{
    string = [[self loadString] stringByAppendingString:string];
    
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:DEFAULTKEY];
}


+(NSString*) loadString
{
    NSString* string = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTKEY];
    
    return string != nil ? string: @"";
}


-(void) storeTestingDataOnline:(NSString*)data
{
    NSString* user = @"wolf@posdorfer.de";
    
    NSString* key = @"jYFhzt85Yz1eHTde8";
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:user forKey:@"user.account"];
    [dict setObject:data forKey:@"data"];
    
    NSError* error;
    NSData* jsonObjectData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    
    NSString* jsonContentBase64 = [NSString base64StringFromData:jsonObjectData];
    
    NSString* hash= [Crypto hmac256:jsonContentBase64 withKey:key];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@testData/verify/%@",baseURL,hash]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    [request setHTTPMethod:@"PUT"];
    
    [request setHTTPBody:[[NSString stringWithFormat:@"%@", jsonContentBase64] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if(data)
         {
             
         }
         else
         {
             
         }
     }];
}

@end
