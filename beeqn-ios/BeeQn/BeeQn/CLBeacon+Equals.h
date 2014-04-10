//
//  CLBeacon+Equals.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 10.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLBeacon (Equals)


-(BOOL) isEqualToBeacon:(id) beacon;

@end
