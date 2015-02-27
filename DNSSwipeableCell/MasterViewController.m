//
//  MasterViewController.m
//  DNSSwipeableCell
//
//  Created by Ellen Shapiro on 11/28/13.
//  Copyright (c) 2013 Designated Nerd Software. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "DNSExampleImageViewCell.h"
#import "SwipeableDataSource.h"

@interface MasterViewController ()
@property (nonatomic, strong) SwipeableDataSource *dataSource;
@end

static NSString * const kDNSExampleImageCellIdentifier = @"Cell";

@implementation MasterViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Register the custom subclass
    [self.tableView registerClass:[DNSExampleImageViewCell class] forCellReuseIdentifier:kDNSExampleImageCellIdentifier];
    
    //Setup the data source.
    self.dataSource = [SwipeableDataSource sourceWithTableView:self.tableView
                                                viewController:self
                                                cellIdentifier:kDNSExampleImageCellIdentifier];
}

- (IBAction)showStoryboardVC:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *storyboardNav = [storyboard instantiateViewControllerWithIdentifier:@"StoryboardNav"];
    
    [self presentViewController:storyboardNav animated:YES completion:nil];
}

@end
