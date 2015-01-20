//
//  BCProductionControllerTableViewController.m
//  FeedbackBeaconContext
//
//  Created by Wolf Posdorfer on 20.01.15.
//  Copyright (c) 2015 Wolf Posdorfer. All rights reserved.
//

#import "BCProductionControllerTableViewController.h"
#import "BCBeaconContextViewController.h"


@interface ActionItem : NSObject
@property (nonatomic,retain) NSString* text;
@property (nonatomic,retain) NSString* detailText;
@property (copy)void (^action)(void);
@property(nonatomic) UITableViewCellAccessoryType accessoryType;

+(ActionItem*) item:(NSString*) text action:(void(^)(void)) action;
+(ActionItem*) item:(NSString*) text action:(void(^)(void)) action accessory:(UITableViewCellAccessoryType) type;
+(ActionItem*) item:(NSString*) text detail:(NSString*) detail action:(void(^)(void)) action accessory:(UITableViewCellAccessoryType) type;
@end

@implementation ActionItem

+(ActionItem*) item:(NSString*) text action:(void(^)(void)) action
{
    return [self item:text action:action accessory:UITableViewCellAccessoryNone];
}
+(ActionItem*) item:(NSString*) text action:(void(^)(void)) action accessory:(UITableViewCellAccessoryType) type
{
    return [self item:text detail:@"" action:action accessory:type];
}

+(ActionItem*) item:(NSString*) text detail:(NSString*) detail action:(void(^)(void)) action accessory:(UITableViewCellAccessoryType) type
{
    ActionItem* itm = [ActionItem new];
    itm.text = text;
    itm.detailText = detail;
    itm.action = action;
    itm.accessoryType = type;
    return itm;
}


@end

@interface BCProductionControllerTableViewController ()


@property (nonatomic,retain) NSMutableArray* items;

@end


@implementation BCProductionControllerTableViewController



- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.title = @"Caffeed";
        _items = [NSMutableArray new];
        [self setup];
    }
    return self;
}

-(void) setup
{
    [_items addObject:[NSMutableArray new]];
    [_items addObject:[NSMutableArray new]];
    [_items addObject:[NSMutableArray new]];
    
    
    [_items[0] addObject:[ActionItem item:@"Previous Submissions" action:^{NSLog(@"gello");} accessory:UITableViewCellAccessoryDisclosureIndicator]];
    [_items[0] addObject:[ActionItem item:@"Pending Submissions" action:^{NSLog(@"gello");} accessory:UITableViewCellAccessoryDisclosureIndicator]];
    
    [_items[1] addObject:[ActionItem item:@"None" detail:@"Current Status" action:^{} accessory:UITableViewCellAccessoryNone]];
    
#ifdef DEBUG

    [_items[2] addObject:[ActionItem item:@"Debug Mode" action:^{
        [self.navigationController pushViewController:[[BCBeaconContextViewController alloc] init] animated:YES];
    } accessory:UITableViewCellAccessoryDisclosureIndicator]];
#endif
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:102.0/256.0 green:204.0/256.0 blue:1.0 alpha:1.0];
    
    
    UIImageView* img2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-300, self.view.frame.size.width, 250)];
    img2.image = [UIImage imageNamed:@"caffeed"];
    
    [self.view addSubview:img2];
    [self.view sendSubviewToBack:img2];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items[section] count];
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"standard"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"standard"];
    }
    
    ActionItem* item  = self.items[indexPath.section][indexPath.row];
    cell.textLabel.text = item.text;
    cell.detailTextLabel.text = item.detailText;
    cell.accessoryType = item.accessoryType;
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionItem* item  = self.items[indexPath.section][indexPath.row];
    
    item.action();
}

@end
