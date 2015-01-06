//
//  FeedbackSheetGet.h
//  FeedbackBeaconContext
//
//  Created by Wolf Posdorfer on 28.10.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedbackSheetManagerDelegate.h"
#import "FeedbackBeaconContext-Swift.h"


@protocol FeedbackSheetGetDelegate <NSObject>


@optional

-(void) feedbacksheetget:(id) get submittedSheetDataWithSuccess:(BOOL) success;

-(void) feedbacksheetget:(id) get downloadSuccess:(FeedbackSheet*) feedbacksheet;

-(void) feedbacksheetget:(id) get downloadFailure:(NSError*) error;

@end


@interface FeedbackSheetGet : NSObject 

@property (nonatomic, weak) id<FeedbackSheetGetDelegate> delegate;

-(void) loadSheetForContext:(NSString*) contextjson;

-(void) submitSheetResult:(NSDictionary*) sheetresults;

@end
