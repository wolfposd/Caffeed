//
// Created by Wolf Posdorfer on 09.04.14.
// Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BeeQnListItem : NSObject


@property (nonatomic, retain) NSURL* imageURL;
@property (nonatomic, readonly, retain) NSString* title;
@property (nonatomic, readonly, retain) NSString* detail;
@property (nonatomic, readonly, retain) NSURL* destinationURL;

@property (nonatomic, retain) UIImage* image;
/**
 *  A BeeQnListItem
 *
 *  @param imageURL    URL of Image to be displayed
 *  @param title       The Cell-Title
 *  @param description The Cell-Description
 *  @param url         The target URL
 *
 *  @return a new BeeQnListItem
 */
+ (BeeQnListItem*)listitem:(NSString*)title detail:(NSString*)detail destinationURL:(NSURL*)url;

@end