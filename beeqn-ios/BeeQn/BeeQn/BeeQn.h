//
//  BeeQn.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 24.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <Foundation/Foundation.h>

// Additional
#import "PSBorderButton.h"
#import "BQAlert.h"
#import "BQListViewController.h"
#import "BQCircleProgress.h"

// BeeQn
#import "BeeQnError.h"
#import "BeeQnCellBig.h"
#import "BeeQnService.h"
#import "BeeQnListItem.h"
#import "BeeQnLocationManager.h"
#import "BQBeaconCounter.h"
#import "BQBeacon.h"



@interface BeeQn : NSObject


@property (nonatomic, retain) BeeQnLocationManager* locatioManager;
@property (nonatomic, retain) BeeQnService* serviceManager;

-(instancetype) initWith:(NSObject<BeeQnLocationManagerProtocol,BeeQnServiceProtocol>*) delegate;

@end