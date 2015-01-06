//
//  FeedbackSheetManagerDelegate.h
//  BeaconContext
//
//  Created by Wolf Posdorfer on 28.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedbackSheetManagerDelegate <NSObject>

-(void)feedbackSheetManager :(id) manager didFinishFetchingSheet:(id) sheet;

-(void)feedbackSheetManager :(id) manager didPostSheetWithSuccess:(BOOL) success;

-(void)feedbackSheetManager :(id) manager didFailWithError:(NSError*) error;

@end




@protocol FeedbackSheetViewControllerDelegate

-(void) feedbackSheetViewController:(id) controller finishedWithResponse:(NSDictionary*) dict;

-(void) feedbackSheetViewController:(id)controller didFailWithError:(NSError*) error;

@end