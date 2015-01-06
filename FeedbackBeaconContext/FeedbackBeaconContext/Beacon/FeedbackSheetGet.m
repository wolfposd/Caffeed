//
//  FeedbackSheetGet.m
//  FeedbackBeaconContext
//
//  Created by Wolf Posdorfer on 28.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//



#define BASEURL_DEBUG @"http://localhost/feedback/rest.php/sheetforcontext/"
#define BASEURL_REAL @"http://beeqn.informatik.uni-hamburg.de/feedback/rest.php/sheetforcontext/"

#define BASEURL_SUBMIT_REAL @"http://beeqn.informatik.uni-hamburg.de/feedback/rest.php/submitsheetforcontext/"



#import "FeedbackSheetGet.h"
#import "NSString+Base64.h"
#import "FileLog.h"

@interface FeedbackSheetGet ()

@end

@implementation FeedbackSheetGet


-(void) loadSheetForContext:(NSString*) contextjson
{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASEURL_REAL, contextjson.base64String]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
   
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if(data)
         {
             [self dataSuccess:data];
         }
         else
         {
             [self error:connectionError];
         }
     }];
}


-(void) dataSuccess:(NSData*) data
{
    NSError* error;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if(dict)
    {
        FeedbackSheet* sheet = [FeedbackSheetManager feedbackSheetFromDictionary:dict];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(feedbacksheetget:downloadSuccess:)])
        {
            [self.delegate feedbacksheetget:self downloadSuccess:sheet];
        }
    }
    else
    {
        [self error: error];
    }
}


-(void) submitSuccess:(NSData*) data
{
    
    NSError* error = nil;
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if(dict)
    {
        NSLog(@"notifiying: %@", self.delegate);
        BOOL successfull = dict[@"success"] != nil;
        if(self.delegate && [self.delegate respondsToSelector:@selector(feedbacksheetget:submittedSheetDataWithSuccess:)])
        {
            [self.delegate feedbacksheetget:self submittedSheetDataWithSuccess:successfull];
            NSLog(@"was notified : %@", self.delegate);
        }
    }
    else
    {
        NSLog(@"%@", @"no dictionary");
    }
}


-(void) submitSheetResult:(NSDictionary*) sheetresults
{
    NSLog(@"%@", @"Submitting Data");
    NSError* error = nil;
    NSData* d = [NSJSONSerialization dataWithJSONObject:sheetresults options:kNilOptions error:&error];
    
    if(d)
    {
        NSString* json = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        
        
        int time = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]].intValue;
        
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%d", BASEURL_SUBMIT_REAL, json.base64String,time]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
        
        NSLog(@"%@", url);
        
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
         ^(NSURLResponse* response, NSData* data, NSError* connectionError)
         {
             NSLog(@"Received Data from submit: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//             NSLog(@"%@", response);
//             NSLog(@"%@", connectionError);
             if(data)
             {
                 [self submitSuccess:data];
             }
             else
             {
                 [self error:connectionError];
             }
         }];
    }
    else
    {
        [self error:error];
    }
}

-(void) error:(NSError*) error
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(feedbacksheetget:downloadFailure:)])
    {
        [self.delegate feedbacksheetget:self downloadFailure:error];
    }
}
@end
