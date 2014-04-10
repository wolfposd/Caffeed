//
//  BQListViewController.m
//  BeeQn
//
//  Created by Wolf Posdorfer on 09.04.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "BQListViewController.h"
#import "BeeQnListItem.h"
#import "BeeQnService.h"
#import "BeeQnCellBig.h"

@interface BQListViewController ()

@property (nonatomic, retain) NSArray* bqlistarray;
@property (nonatomic) int listSize;

@end

@implementation BQListViewController


- (id)initWith:(NSArray*)blistarray title:(NSString*)title size:(int)size
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.bqlistarray = blistarray;
        self.title = title;
        self.listSize = size;
        
        
        self.tableView.rowHeight = size;
        
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bqlistarray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* reuseIdentifer = @"standard";

    BeeQnListItem* item = self.bqlistarray[indexPath.row];

    if (self.listSize == kListSizeSmall)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];

        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifer];
        }


        cell.imageView.image = item.image;
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = item.detail;


        return cell;

    }
    else
    {
        BeeQnCellBig* cell = [tableView dequeueReusableCellWithIdentifier:[BeeQnCellBig reuseIdentifer]];
        if (cell == nil)
        {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:[BeeQnCellBig reuseIdentifer] owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }

        cell.image.image = item.image;
        cell.titleLabel.text = item.title;
        cell.detailLabel.text = item.detail;

        return cell;
    }


}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSURL* url = ((BeeQnListItem*) self.bqlistarray[indexPath.row]).destinationURL;

    NSLog(@"%@", url);

}

@end
