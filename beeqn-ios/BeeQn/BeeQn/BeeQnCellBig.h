//
//  BeeQnCellBig.h
//  BeeQn
//
//  Created by Wolf Posdorfer on 10.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeeQnCellBig : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;




+(NSString*) reuseIdentifer;


+(int) cellHeight;


@end