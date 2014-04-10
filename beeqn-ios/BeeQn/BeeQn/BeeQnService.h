//
// Created by Wolf Posdorfer on 09.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kListSizeSmall = 44,
    kListSizeBig = 80
} BeeQnListSize;


@protocol BeeQnServiceProtocol


@optional

- (void)service:(id)beeqnservice didFailWithError:(NSError*)error;

- (void)service:(id)beeqnservice foundCustom:(NSString*)custom;

- (void)service:(id)beeqnservice foundList:(NSArray*)listItems withTitle:(NSString*)title andSize:(BeeQnListSize) size;

- (void)service:(id)beeqnservice foundURL:(NSURL*)url;

@end


@interface BeeQnService : NSObject


@property (nonatomic, weak) NSObject <BeeQnServiceProtocol>* delegate;


- (void)fetchBeeQnInformation:(NSString*)UUID major:(NSNumber*)major minor:(NSNumber*)minor;


@end