//
// Created by Wolf Posdorfer on 09.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BeeQnListItem.h"


@interface BeeQnListItem ()

@property (nonatomic, readwrite, retain) NSString* title;
@property (nonatomic, readwrite, retain) NSString* detail;
@property (nonatomic, readwrite, retain) NSURL* destinationURL;
@end

@implementation BeeQnListItem


+ (BeeQnListItem*)listitem:(NSString*)title detail:(NSString*)detail destinationURL:(NSURL*)url
{
    BeeQnListItem* item = [[BeeQnListItem alloc] init];
    if (item)
    {
        item.title = title;
        item.detail = detail;
        item.destinationURL = url;
    }
    return item;
}

- (NSString*)description
{
    return [@"BeeQnListItem" stringByAppendingString:self.title];
}


@end