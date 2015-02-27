//
//  StoryboardTableViewController.m
//  DNSSwipeableCell
//
//  Created by Ellen Shapiro on 2/26/15.
//  Copyright (c) 2015 Designated Nerd Software. All rights reserved.
//

#import "StoryboardTableViewController.h"

#import "SwipeableDataSource.h"
#import "DNSStoryboardCell.h"

@interface StoryboardTableViewController ()
@property (nonatomic, strong) SwipeableDataSource *dataSource;
@end

@implementation StoryboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Cells from the storyboard!";
    
    self.dataSource = [SwipeableDataSource sourceWithTableView:self.tableView
                                                viewController:self
                                                cellIdentifier:[DNSStoryboardCell reuseIdentifier]];
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
                       
@end
