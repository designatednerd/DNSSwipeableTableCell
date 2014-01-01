//
//  MasterViewController.m
//  DNSSwipeableCell
//
//  Created by Transferred on 11/28/13.
//  Copyright (c) 2013 Designated Nerd Software. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "DNSSwipeableCell.h"

@interface MasterViewController () <DNSSwipeableCellDelegate> {
    NSMutableArray *_objects;
}
@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Initialize the mutable array so you can add stuff to it.
    _objects = [NSMutableArray array];
    _cellsCurrentlyEditing = [NSMutableArray array];
    
    //Create a whole bunch of string objects, and add them to the array.
    NSInteger numberOfItems = 30;
    for (NSInteger i = 1; i <= numberOfItems; i++) {
        NSString *item = [NSString stringWithFormat:@"Longer Title Item #%d", i];
        [_objects addObject:item];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNSSwipeableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *item = _objects[indexPath.row];
    cell.itemText = item;
    cell.delegate = self;
    
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Deletes the object from the array
        [_objects removeObjectAtIndex:indexPath.row];
        
        //Deletes the row from the tableView.
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        //This is something that hasn't been set up yet - add a log to determine
        //what sort of editing style you also need to handle.
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - DNSSwipeableCellDelegate
- (void)showDetailWithText:(NSString *)detailText
{
    //Instantiate the DetailVC out of the storyboard.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detail.title = @"In the delegate!";
    detail.detailItem = detailText;
    
    //Setup nav controller to contain the detail vc.
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detail];
    
    //Setup button to close the detail VC.
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeModal)];
    [detail.navigationItem setRightBarButtonItem:done];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)closeModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonOneActionForItemText:(NSString *)itemText
{
    [self showDetailWithText:[NSString stringWithFormat:@"Clicked button one for %@", itemText]];
}

- (void)buttonTwoActionForItemText:(NSString *)itemText
{
    [self showDetailWithText:[NSString stringWithFormat:@"Clicked button two for %@", itemText]];
}

- (void)cellDidBeginEditing:(UITableViewCell *)cell
{
    NSIndexPath *currentEditingIndexPath = [self.tableView indexPathForCell:cell];
    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
}

- (void)cellDidEndEditing:(UITableViewCell *)cell
{
    [self.cellsCurrentlyEditing removeObject:[self.tableView indexPathForCell:cell]];
}

@end
