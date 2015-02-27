//
//  SwipeableDataSource.m
//  DNSSwipeableCell
//
//  Created by Ellen Shapiro on 2/26/15.
//  Copyright (c) 2015 Designated Nerd Software. All rights reserved.
//

#import "SwipeableDataSource.h"
#import "DNSSwipeableCell.h"
#import "DNSExampleImageViewCell.h"
#import "DNSStoryboardCell.h"
#import "DetailViewController.h"

@interface SwipeableDataSource() <UITableViewDataSource, UITableViewDelegate, DNSSwipeableCellDataSource, DNSSwipeableCellDelegate>
@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;
@property (nonatomic, strong) NSMutableArray *itemTitles;
@property (nonatomic, strong) NSArray *backgroundColors;
@property (nonatomic, strong) NSArray *textColors;
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIViewController *currentViewController;
@property (nonatomic) NSString *cellIdentifier;

@end

static NSInteger kSelectedRowInsteadOfButton = -1;

@implementation SwipeableDataSource

+ (SwipeableDataSource *)sourceWithTableView:(UITableView *)tableView
                              viewController:(UIViewController *)viewController
                              cellIdentifier:(NSString *)cellIdentifier
{
    SwipeableDataSource *dataSource = [[SwipeableDataSource alloc] init];
    dataSource.tableView = tableView;
    dataSource.tableView.dataSource = dataSource;
    dataSource.tableView.delegate = dataSource;
    dataSource.cellIdentifier = cellIdentifier;
    dataSource.currentViewController = viewController;
    
    
    
    //Create an array of image names
    dataSource.imageNames = @[ @"annoyed.jpg",
                         @"dancer.jpg",
                         @"ontivo.jpg",
                         @"red.jpg",
                         @"sandwichthief.jpg",
                         @"super.jpg"];
    
    //Create arrays of random background and text colors
    dataSource.backgroundColors = @[[UIColor blueColor],
                              [UIColor greenColor],
                              [UIColor orangeColor],
                              [UIColor darkGrayColor],
                              [UIColor purpleColor],
                              [UIColor lightGrayColor],
                              ];
    
    dataSource.textColors = @[[UIColor whiteColor],
                        [UIColor blackColor]];
    
    //Initialize the mutable array so you can add stuff to it.
    dataSource.itemTitles = [NSMutableArray array];
    dataSource.cellsCurrentlyEditing = [NSMutableArray array];
    
    //Create a whole bunch of string objects, and add them to the array.
    NSInteger numberOfItems = 30;
    for (NSInteger i = 1; i <= numberOfItems; i++) {
        NSString *item = [NSString stringWithFormat:@"Longer Title Item #%@", @(i)];
        [dataSource.itemTitles addObject:item];
    }
    
    return dataSource;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cellIdentifier isEqualToString:[DNSStoryboardCell reuseIdentifier]]) {
        return [DNSStoryboardCell cellHeight];
    } else {
        return kExampleCellHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Recycle!
    DNSSwipeableCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    NSString *textItem = self.itemTitles[indexPath.row];
    NSString *imageName = self.imageNames[indexPath.row % self.imageNames.count];
    UIImage *image = [UIImage imageNamed:imageName];
    
    if ([cell isKindOfClass:[DNSExampleImageViewCell class]]) {
        [self configureProgrammaticCell:(DNSExampleImageViewCell *)cell
                           withTextItem:textItem
                               andImage:image];
    } else if ([cell isKindOfClass:[DNSStoryboardCell class]]) {
        [self configureStoryboardCell:(DNSStoryboardCell *)cell
                         withTextItem:textItem
                             andImage:image];
    } else {
        NSAssert(NO, @"Unexpected class of cell %@", NSStringFromClass([cell class]));
    }
    
    
    
    //Set up the buttons
    cell.dataSource = self;
    cell.delegate = self;
    
    [cell setNeedsUpdateConstraints];
    
    //Reopen the cell if it was already editing
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell:NO];
    }
    
    return cell;
}

- (void)configureProgrammaticCell:(DNSExampleImageViewCell *)cell withTextItem:(NSString *)textItem andImage:(UIImage *)image
{
    //Setup the label and image
    cell.exampleLabel.text = textItem;
    cell.exampleImageView.image = image;
}

- (void)configureStoryboardCell:(DNSStoryboardCell *)cell withTextItem:(NSString *)textItem andImage:(UIImage *)image
{
    cell.storyboardExampleLabel.text = textItem;
    cell.storyboardImageView.image = image;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //This needs to return NO or you'll only get the stock delete button.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //Deletes the object from the array
        [_itemTitles removeObjectAtIndex:indexPath.row];
        
        //Deletes the row from the tableView.
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        //This is something that hasn't been set up yet - add a log to determine
        //what sort of editing style you also need to handle.
        NSLog(@"Unhandled editing style! %@", @(editingStyle));
    }
    
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailForIndexPath:indexPath fromDelegateButtonAtIndex:kSelectedRowInsteadOfButton];
}

#pragma mark - DNSSwipeableCellDataSource

#pragma mark Required Methods

- (NSInteger)numberOfButtonsInSwipeableCell:(DNSSwipeableCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    
    if (indexPath.row % 2 == 0) {
        //Even rows have 2 options
        return 2;
    } else {
        //Odd rows 3 options
        return 3;
    }
}

#pragma mark Optional Methods

////Uncomment this optional styling method to muck around with the font.
//- (UIFont *)swipeableCell:(DNSSwipeableCell *)cell fontForButtonAtIndex:(NSInteger)index
//{
//    //List of fonts available on iOS 7: http://support.apple.com/kb/HT5878
//    return [UIFont fontWithName:@"AmericanTypewriter" size:14.0f];
//}

//Uncomment to show fully custom button
//- (UIButton *)swipeableCell:(DNSSwipeableCell *)cell buttonForIndex:(NSInteger)index
//{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"Custom" forState:UIControlStateNormal];
//    [button setFrame:CGRectMake(0.0f, 0.0f, 100.0f, 10.0f)];
//    [button setBackgroundColor:[UIColor redColor]];
//
//    return button;
//}

- (NSString *)swipeableCell:(DNSSwipeableCell *)cell titleForButtonAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    switch (index) {
        case 0:
            return NSLocalizedString(@"Delete", @"Delete");
            break;
        case 1:
            return (indexPath.row == 0) ? @"" : NSLocalizedString(@"Option 1", @"Option 1");
            break;
        case 2:
            return NSLocalizedString(@"Option 2", @"Option 2");
            break;
        default:
            break;
    }
    
    return nil;
}

- (UIImage *)swipeableCell:(DNSSwipeableCell *)cell imageForButtonAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    
    //Return a user image for the first row only.
    if (indexPath.row == 0 && index == 1) {
        return [UIImage imageNamed:@"user"];
    } else {
        return nil;
    }
}

- (UIColor *)swipeableCell:(DNSSwipeableCell *)cell backgroundColorForButtonAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return [UIColor redColor];
            break;
        default: {
            //Note that the random index means colors won't persist after recycling.
            NSInteger randomIndex = floorf (arc4random() % self.backgroundColors.count);
            return self.backgroundColors[randomIndex];
        }
            break;
    }
}

- (UIColor *)swipeableCell:(DNSSwipeableCell *)cell tintColorForButtonAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return self.textColors[0];
            break;
        default: {
            //Note that the random index means colors won't persist after recycling.
            NSInteger randomIndex = floorf(arc4random() % self.textColors.count);
            return self.textColors[randomIndex];
        }
            break;
    }
}

#pragma mark - DNSSwipeableCellDelegate

- (void)swipeableCell:(DNSSwipeableCell *)cell didSelectButtonAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    
    if (index == 0) {
        [self.cellsCurrentlyEditing removeObject:indexPath];
        [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    } else {
        [self showDetailForIndexPath:indexPath fromDelegateButtonAtIndex:index];
    }
}

- (void)swipeableCellDidOpen:(DNSSwipeableCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    [self.cellsCurrentlyEditing addObject:indexPath];
}

- (void)swipeableCellDidClose:(DNSSwipeableCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    [self.cellsCurrentlyEditing removeObject:indexPath];
}

#pragma mark - Detail handling.

- (void)showDetailForIndexPath:(NSIndexPath *)indexPath fromDelegateButtonAtIndex:(NSInteger)buttonIndex
{
    DNSSwipeableCell *cell = (DNSSwipeableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    //Instantiate the DetailVC out of the storyboard.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    NSString *title = self.itemTitles[indexPath.row];
    if (buttonIndex != kSelectedRowInsteadOfButton) {
        NSString *textForCellButton = [self swipeableCell:cell titleForButtonAtIndex:buttonIndex];
        title = [NSString stringWithFormat:@"%@: %@", title, textForCellButton];
    } else {
        title = self.itemTitles[indexPath.row];
    }
    
    detail.detailText = title;
    NSString *imageName = self.imageNames[indexPath.row % self.imageNames.count];
    detail.detailImage = [UIImage imageNamed:imageName];
    
    if (buttonIndex == kSelectedRowInsteadOfButton) {
        detail.title = @"Selected!";
        [self.currentViewController.navigationController pushViewController:detail animated:YES];
    } else {
        //Present modally
        detail.title = @"In the delegate!";
        
        //Setup nav controller to contain the detail vc.
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detail];
        
        //Setup button to close the detail VC (will call the method below.
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeModal)];
        [detail.navigationItem setRightBarButtonItem:done];
        [self.currentViewController presentViewController:navController animated:YES completion:nil];
    }
}

- (void)closeModal
{
    [self.currentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
