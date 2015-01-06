//
//  FSTableViewController.m
//  FeedbackBeaconContext
//
//  Created by Wolf Posdorfer on 03.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

#import "FSTableViewController.h"
#import "FeedbackSheetGet.h"
#import "BDKNotifyHUD.h"


@interface FSTableViewController ()<UITableViewDataSource, UITableViewDelegate, ModuleCellDelegate, FeedbackSheetGetDelegate>

@property (nonatomic, retain) NSMutableDictionary* responseDictionary;

@property (nonatomic) int pageindex;
@property (nonatomic, retain) FeedbackSheet* feedbackSheet;
@property (nonatomic, retain) FeedbackSheetPage* currentPage;

@property (nonatomic, retain) FeedbackSheetGet* rest;

@property (nonatomic,retain) BDKNotifyHUD* notifyHUD;
@property (nonatomic) CGRect frameForNotify;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem* nextPageButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem* prevPageButton;

@end

@implementation FSTableViewController

-(id) initWithSheet:(FeedbackSheet*) sheet
{
    self = [self initWithStyle:UITableViewStylePlain];
    if(self)
    {
        _pageindex = 0;
        _feedbackSheet = sheet;
        _responseDictionary = [NSMutableDictionary new];
        
        if(_feedbackSheet.pages.count > 0)
        {
            _currentPage = sheet.pages[0];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerModuleCells];
    [self navigationSetup];
    [self showSheetTitle:self.feedbackSheet.title];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    [self updateValuesOnPageChange];
}

-(void) navigationSetup
{
    UIBarButtonItem* nextPageButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ArrowNextPage"] style:UIBarButtonItemStyleBordered target:self action:@selector(nextPageButton:)];
    
    UIBarButtonItem* prevPageButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ArrowLastPage"] style:UIBarButtonItemStyleBordered target:self action:@selector(previousPageButton:)];
    
    [self togglePageButtonsStatus];
    
    [self.navigationItem setRightBarButtonItems:@[nextPageButton, prevPageButton]];
    
    self.nextPageButton = nextPageButton;
    self.prevPageButton = prevPageButton;
}


#pragma mark - Stuff

-(BOOL) isLastPage
{
    return self.pageindex == self.feedbackSheet.pages.count - 1;
}


- (void) registerModuleCells
{
    [FSViewControllerHelper registerModuleCells:self.tableView];
}


-(void) showSheetTitle:(NSString*) title
{
    UIView* headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    
    [headerview addSubview:titleLabel];
    
    
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor whiteColor];
    headerview.backgroundColor = [UIColor whiteColor];
    
    [titleLabel sizeToFit];
    
    titleLabel.center = headerview.center;
    
    self.tableView.tableHeaderView = headerview;
}


-(void) toggleSubmitButton
{
    if(![self isLastPage])
    {
        self.tableView.tableFooterView = nil;
    }
    else if(self.tableView.tableFooterView == nil)
    {
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        
        UIButton* submitButton = [UIButton buttonWithType: UIButtonTypeSystem];
        
        submitButton.layer.borderColor = [UIColor grayColor].CGColor;
        submitButton.layer.borderWidth = 1.5;
        submitButton.layer.cornerRadius = 5;
        submitButton.backgroundColor = [UIColor whiteColor];
        submitButton.frame = CGRectMake(0, 0, self.view.frame.size.width - 40, 44);
        [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(submitButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        submitButton.center = CGPointMake(footerView.center.x, footerView.center.y - 20);
        [footerView addSubview:submitButton];
        self.tableView.tableFooterView = footerView;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger page = 0;
    
    if(self.currentPage)
    {
        page =  self.currentPage.modulesVisible.count;
    }
    return page;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return[FSViewControllerHelper tableView:tableView cellForRowAtIndexPath:indexPath dictionary:self.responseDictionary page:self.currentPage delegate:self];
}

#pragma mark - ModuleCellDelegate

-(void)moduleCell:(ModuleCell *)cell didGetResponse:(NSObject *)response forID:(NSString *)ID
{
    self.responseDictionary[ID] = response;
}

#pragma mark - IBActions

-(void) submitButtonTouchUpInside:(id) sender
{
    //    do stuff with:
    //    self.responseDictionary
    
    NSLog(@"%@", self.responseDictionary);
    
    
    NSLog(@"%@", @"submitting feedbacksheet");
    
    
    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] init];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity startAnimating];
    CGRect rect = activity.frame;
    rect.size.height = rect.size.height*2;
    activity.frame = rect;
    

    UIButton* button = sender;
    CGRect frame = button.superview.frame;
    frame.size.width = 300;
    frame.size.height = 500;
    
    frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2;
    frame.origin.y = frame.origin.y - 200;
    
    self.frameForNotify = frame;
    
    self.notifyHUD = [BDKNotifyHUD notifyHUDWithView:activity text:@"Submitting..." frame:frame];
    [self.view addSubview:self.notifyHUD];
    [self.notifyHUD presentWithSpeed:0.5 onCompletion:^(){
        self.rest = [[FeedbackSheetGet alloc] init];
        self.rest.delegate = self;
        [self.rest submitSheetResult:self.responseDictionary];
    }];
    
    
}

-(void) nextPageButton:(id) sender
{
    if(![self isLastPage])
    {
        self.pageindex++;
        [self updateValuesOnPageChange];
    }
}

-(void) previousPageButton:(id) sender
{
    if(self.pageindex <= 1)
    {
        self.pageindex--;
        [self updateValuesOnPageChange];
    }
}

-(void) updateValuesOnPageChange
{
    self.currentPage = self.feedbackSheet.pages[self.pageindex];
    [self togglePageButtonsStatus];
    [self.tableView reloadData];
    [self toggleSubmitButton];
}

-(void) togglePageButtonsStatus
{
    self.nextPageButton.enabled = ![self isLastPage];
    self.prevPageButton.enabled = self.pageindex != 0;
    self.title = [NSString stringWithFormat:@"Page %d of %lu",  self.pageindex+1, (unsigned long)self.feedbackSheet.pages.count];
    
}

#pragma mark - FeedbackSheetGetDelegate

-(void) feedbacksheetget:(id) get submittedSheetDataWithSuccess:(BOOL) success
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", @"data submit success");
        
        if(self.notifyHUD)
        {
            [self.notifyHUD removeFromSuperview];
            self.notifyHUD = nil;
        }
        
        self.notifyHUD = [BDKNotifyHUD notifyHUDWithText: success ? @"Submission was successfull" : @"Submission was not successfull"];
        CGRect notifframe = self.notifyHUD.frame;
        CGRect frame = self.frameForNotify;
        frame.origin.x = (self.view.frame.size.width -  notifframe.size.width) / 2;
        self.notifyHUD.frame = frame;
        
        [self.view addSubview:self.notifyHUD];
        
        [self.notifyHUD presentWithDuration:3.0 speed:0.5 completion:^(){
            if(success)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    });
}

-(void) feedbacksheetget:(id)get downloadFailure:(NSError*) error
{
    if(self.notifyHUD)
    {
        [self.notifyHUD removeFromSuperview];
        self.notifyHUD = nil;
    }
}


@end
