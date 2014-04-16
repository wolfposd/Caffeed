//
//  WebViewViewController.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 15.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewViewController : UIViewController

-(instancetype)initWithString:(NSString*) urlString;

-(instancetype)initWithURL:(NSURL*) urlString;

@end
