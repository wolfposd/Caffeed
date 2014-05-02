//
// Created by Wolf Posdorfer on 09.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "BeeQnService.h"
#import "BeeQnListItem.h"
#import "BeeQnError.h"
#import "NSString+Base64.h"
#import "BQBeacon.h"
#import "Crypto.h"


@implementation BeeQnService


static NSString* ACTION_INFO = @"action_info";
static NSString* ACTION_TYPE = @"action_type";
static NSString* baseURL = @"http://beeqn.informatik.uni-hamburg.de/rest.php/";


#pragma mark - Beacon information by uuid/major/minor

- (void)get_BeeQnInformation:(NSString*)UUID major:(NSNumber*)major minor:(NSNumber*)minor
{

    NSString* path = [NSString stringWithFormat:@"%@beaconsinfo/%@/major/%@/minor/%@", baseURL, UUID, major, minor];


    NSURLRequest* request = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:path] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
            ^(NSURLResponse* response, NSData* data, NSError* connectionError)
            {
                if (!connectionError && data)
                {
                    [self handleData:data];
                }
                else
                {
                    [self sendError:connectionError];
                }
            }];

}


- (void)handleData:(NSData*)data
{
    NSError* error;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    if (!error && dict)
    {
        [self handleDictionary:dict];
    }
    else
    {
        [self sendError:error];
    }
}


- (void)sendError:(NSError*)error
{
    if ([self.delegate respondsToSelector:@selector(service:didFailWithError:)])
    {
        [self performOnMain:^()
         {
             [self.delegate service:self didFailWithError:error];
         }];
    }
}


- (void)handleDictionary:(NSDictionary*)dictionary
{

    if ([dictionary objectForKey:@"error"])
    {
        [self sendError:[BeeQnError errorWith:100 message:@"No information for this iBeacon specified"]];
    }
    else
    {
        NSString* actiontype = [dictionary objectForKey:ACTION_TYPE];
        if (actiontype)
        {
            if ([actiontype isEqualToString:@"list"])
            {
                [self handleListItems:dictionary];
            }
            else if ([actiontype isEqualToString:@"url"])
            {
                [self handleURL:dictionary];
            }
            else if ([actiontype isEqualToString:@"alert"])
            {
                [self handleAlert:dictionary];
            }
            else
            {
                [self handleCustom:dictionary];
            }
        }
    }
}

- (void)handleAlert:(NSDictionary*)dictionary
{
    NSDictionary* alert = [self makeJSONDictionary:[dictionary objectForKey:ACTION_INFO]];

    NSString* title = [alert objectForKey:@"title"];
    NSString* message = [alert objectForKey:@"message"];

    if([self.delegate respondsToSelector:@selector(service:foundAlert:message:)])
    {
        [self performOnMain:^()
         {
             [self.delegate service:self foundAlert:title message:message];
         }];
    }

}

- (void)handleListItems:(NSDictionary*)dictionary
{
    NSDictionary* list = [self makeJSONDictionary:[dictionary objectForKey:ACTION_INFO]];
    if (list)
    {
        NSString* listTitle = [list objectForKey:@"title"];

        NSString* listType = [list objectForKey:@"type"];
        BeeQnListSize listSize = [@"big" isEqualToString:listType] ? kListSizeBig : kListSizeSmall;


        NSArray* dictArray = [list objectForKey:@"values"];

        NSMutableArray* listitems = [[NSMutableArray alloc] init];

        for (NSDictionary* value in dictArray)
        {
            NSString* title = [value objectForKey:@"title"];
            NSString* desc = [value objectForKey:@"description"];
            NSURL* url = [[NSURL alloc] initWithString:[value objectForKey:@"url"]];

            BeeQnListItem* listItem = [BeeQnListItem listitem:title detail:desc destinationURL:url];

            NSString* imagedata = [value objectForKey:@"imagedata"];
            if (imagedata)
            {
                NSURL* url = [[NSURL alloc] initWithString:imagedata];
                NSData* imageData = [NSData dataWithContentsOfURL:url];
                listItem.image = [UIImage imageWithData:imageData];
            }


            [listitems addObject:listItem];
        }

        if ([self.delegate respondsToSelector:@selector(service:foundList:withTitle:andSize:)])
        {
            [self performOnMain:^
            {
                [self.delegate service:self foundList:listitems withTitle:listTitle andSize:listSize];
            }];
        }

    }
    else
    {
        [self sendError:[BeeQnError errorWith:15 message:@"couldn't parse list"]];
    }
}

- (void)handleURL:(NSDictionary*)dictionary
{
    NSURL* url = [dictionary valueForKey:ACTION_INFO];
    if ([self.delegate respondsToSelector:@selector(service:foundURL:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.delegate service:self foundURL:url];
        });
    }
}


- (void)handleCustom:(NSDictionary*)dictionary
{
    NSString* custom = [dictionary valueForKey:ACTION_INFO];
    if ([self.delegate respondsToSelector:@selector(service:foundCustom:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.delegate service:self foundCustom:custom];
        });
    }

}



#pragma mark - UUID by GPS

- (void)get_BeaconListForLocation:(CLLocation*)location
{
    NSString* path = [NSString stringWithFormat:@"%@uuidbylocation/longitude/%f/latitude/%f", baseURL, location.coordinate.longitude, location.coordinate.latitude];

    NSURLRequest* request = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:path] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
            ^(NSURLResponse* response, NSData* data, NSError* connectionError)
            {
                if (!connectionError && data)
                {
                    [self handleGPSData:data];
                }
                else
                {
                    [self sendError:connectionError];
                }
            }];

}

- (void)handleGPSData:(NSData*)gpsdata
{

    NSArray* uuids = [self makeJSONArray:gpsdata];

    if (uuids && [self.delegate respondsToSelector:@selector(service:foundBeaconsUUIDs:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.delegate service:self foundBeaconsUUIDs:uuids];
        });
    }
}

- (void)get_FloorPlanFor:(NSString*) UUID major:(NSNumber*)major minor:(NSNumber*)minor
{
    //://beeqn.informatik.uni-hamburg.de/rest.php/floorinformation/uuid/B9407F30-F5F8-466E-AFF9-25556B57FE6D/major/48604/minor/372
    
    NSString* path = [NSString stringWithFormat:@"%@floorinformation/uuid/%@/major/%@/minor/%@",baseURL,UUID,major,minor];
    NSURLRequest* request = [NSURLRequest requestWithURL:[[NSURL alloc] initWithString:path] cachePolicy:
                             NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if (!connectionError && data)
         {
             [self handleFloorData:data];
         }
         else
         {
             [self sendError:connectionError];
         }
     }];
    
}

-(void) handleFloorData:(NSData*) data
{
    NSDictionary* dict = [self makeJSONDictionary:data];
    
    // try replacing image with UIImage
    
    
    
    // data:image/png;base64,
    
    NSString* imagedata = [dict objectForKey:@"imagedata"];
    NSString* imagetype = [dict objectForKey:@"imagetype"];
    if(imagetype && imagedata)
    {
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"data:%@;base64,%@",imagetype, imagedata]];
        
        NSData* imageData = [NSData dataWithContentsOfURL:url];
        UIImage* image = [UIImage imageWithData:imageData];
        
        NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        [newDict setValue:image forKey:@"imagedata"];
        dict = newDict;
    }
   
    
    
    if([self.delegate respondsToSelector:@selector(service:foundFloorData:)])
    {
        [self performOnMain:^()
        {
            [self.delegate service:self foundFloorData:dict];
        }];
    }
    
}

- (void)put_BeaconsInDB:(NSArray*) beacons user:(NSString*) user key:(NSString*) key location:(CLLocationCoordinate2D) location
{
    NSMutableArray* beaconsJson = [NSMutableArray new];
    
    for(BQBeacon* beacon in beacons)
    {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        [dict setObject:beacon.UUID forKey:@"UUID"];
        [dict setObject:beacon.major forKey:@"major"];
        [dict setObject:beacon.minor forKey:@"minor"];
        [beaconsJson addObject:dict];
    }
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary new];
    
    [jsonDict setObject:beaconsJson forKey:@"beacons"];
    [jsonDict setObject:[NSNumber numberWithDouble:location.latitude] forKey:@"latitude"];
    [jsonDict setObject:[NSNumber numberWithDouble:location.longitude] forKey:@"longitude"];
    [jsonDict setObject:user forKey:@"user.account"];
    
    NSError* error;
    NSData* jsonObjectData = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:&error];

    NSString* jsonContentBase64 = [NSString base64StringFromData:jsonObjectData];
    
    NSString* hash= [Crypto hmac256:jsonContentBase64 withKey:key];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@beacons/%@/verify/%@",baseURL,jsonContentBase64,hash]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    [request setHTTPMethod:@"PUT"];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if(!connectionError)
         {
             // NOTIFY DELEGATE
             if([self.delegate respondsToSelector:@selector(service:insertedBeaconsWithResult:)])
             {
                 [self performOnMain:^()
                  {
                      [self.delegate service:self insertedBeaconsWithResult:[self makeJSONArray:data]];
                  }];
             }
         }
         else
         {
             if(connectionError)
             {
                 [self sendError:connectionError];
             }
             else
             {
                 [self sendError:[BeeQnError errorWith:404 message:@"Some error with put_beacons"]];
             }
         }
     }];
}



#pragma mark - Additional

- (NSArray*)makeJSONArray:(id)possibleArray
{
    NSError* error;
    if ([[possibleArray class] isSubclassOfClass:[NSString class]])
    {

        NSArray* array = [NSJSONSerialization JSONObjectWithData:[possibleArray dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];

        if (!error)
        {
            return array;
        }
        else
        {
            return nil;
        }

    }
    else if ([[possibleArray class] isSubclassOfClass:[NSData class]])
    {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:possibleArray options:kNilOptions error:&error];
        if (!error)
        {
            return array;
        }
        else
        {
            return nil;
        }
    }
    else if ([[possibleArray class] isSubclassOfClass:[NSArray class]])
    {
        return possibleArray;
    }
    else
    {
        return nil;
    }

}

- (NSDictionary*)makeJSONDictionary:(id)possibleDictionary
{
    NSError* error;
    if ([[possibleDictionary class] isSubclassOfClass:[NSString class]])
    {
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:[possibleDictionary dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (!error)
        {
            return result;
        }
        else
        {
            return nil;
        }
    }
    else if ([[possibleDictionary class] isSubclassOfClass:[NSData class]])
    {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:possibleDictionary options:kNilOptions error:&error];
        if (!error)
        {
            return dict;
        }
        else
        {
            return nil;
        }
    }
    else if ([[possibleDictionary class] isSubclassOfClass:[NSDictionary class]])
    {
        return (NSDictionary*) possibleDictionary;
    }
    else
    {
        return nil;
    }
}



-(void) performOnMain:( void ( ^ )( void ) )block
{
    dispatch_async(dispatch_get_main_queue(), ^{ block(); });
}

@end













