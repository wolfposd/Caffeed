//
// Created by Wolf Posdorfer on 09.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BeeQnService.h"
#import "BeeQnListItem.h"
#import "BeeQnError.h"
#import "NSString+Base64.h"


@implementation BeeQnService


static NSString* ACTION_INFO = @"action_info";
static NSString* ACTION_TYPE = @"action_type";
static NSString* baseURL = @"http://beeqn.informatik.uni-hamburg.de/rest.php/";

- (void)fetchBeeQnInformation:(NSString*)UUID major:(NSNumber*)major minor:(NSNumber*)minor
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
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.delegate service:self didFailWithError:error];
        });
    }
}


- (void)handleDictionary:(NSDictionary*)dictionary
{

    if ([dictionary objectForKey:@"error"])
    {
        [self sendError:[NSError errorWithDomain:@"com.beeqn" code:100 userInfo:nil]];
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
            else
            {
                [self handleCustom:dictionary];
            }
        }
    }
}

- (void)handleListItems:(NSDictionary*)dictionary
{
    NSDictionary* list = [self makeJSON:[dictionary objectForKey:ACTION_INFO]];
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

        NSLog(@"%@", listitems);

        if ([self.delegate respondsToSelector:@selector(service:foundList:withTitle:andSize:)])
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [self.delegate service:self foundList:listitems withTitle:listTitle andSize:listSize];
            });
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


- (NSDictionary*)makeJSON:(id)possibleDictionary
{
    if ([[possibleDictionary class] isSubclassOfClass:[NSString class]])
    {
        NSError* error;
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:[possibleDictionary dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (!error)
        {
            return result;
        }
        else
        {
            NSLog(@"%@", error);
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


@end












