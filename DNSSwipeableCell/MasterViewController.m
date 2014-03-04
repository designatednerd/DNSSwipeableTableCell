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

@interface MasterViewController () <DNSSwipeableCellDelegate, DNSSwipeableCellDataSource>

@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;
@property (nonatomic, strong) NSMutableArray *itemTitles;
@property (nonatomic, strong) NSArray *backgroundColors;
@property (nonatomic, strong) NSArray *textColors;
@property (nonatomic, strong) NSArray *imageNames;

@end

static NSString * const kDNSExampleImageCellIdentifier = @"Cell";

@implementation MasterViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Register the custom subclass
    [self.tableView registerClass:[DNSExampleImageViewCell class] forCellReuseIdentifier:kDNSExampleImageCellIdentifier];

    //Initialize the mutable array so you can add stuff to it.
    _itemTitles = [NSMutableArray array];
    self.cellsCurrentlyEditing = [NSMutableArray array];
    
    //Create a whole bunch of string objects, and add them to the array.
    NSInteger numberOfItems = 30;
    for (NSInteger i = 1; i <= numberOfItems; i++) {
        NSString *item = [NSString stringWithFormat:@"Longer Title Item #%d", i];
        [_itemTitles addObject:item];
    }
    
    //Create an array of image names
    self.imageNames = @[ @"annoyed.jpg",
                         @"dancer.jpg",
                         @"ontivo.jpg",
                         @"red.jpg",
                         @"sandwichthief.jpg",
                         @"super.jpg"];
    
    //Create arrays of random background and text colors
    self.backgroundColors = @[[UIColor blueColor],
                              [UIColor greenColor],
                              [UIColor orangeColor],
                              [UIColor darkGrayColor],
                              [UIColor purpleColor],
                              [UIColor lightGrayColor],
                              [UIColor yellowColor]];
    
    self.textColors = @[[UIColor whiteColor],
                        [UIColor blackColor]];
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kExampleCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Recycle!
    DNSExampleImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDNSExampleImageCellIdentifier forIndexPath:indexPath];


    //Setup the label and image
    NSString *textItem = self.itemTitles[indexPath.row];
    NSString *imageName = self.imageNames[indexPath.row % self.imageNames.count];
    UIImage *image = [UIImage imageNamed:imageName];
    cell.exampleLabel.text = textItem;
    cell.exampleImageView.image = image;
    
    //Set up the buttons
    cell.indexPath = indexPath;
    cell.dataSource = self;
    cell.delegate = self;
    
    [cell configureButtons];
    [cell setNeedsUpdateConstraints];
    
    //Reopen the cell if it was already editing
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell:NO];
    }
    
    return cell;
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
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
    
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

#pragma mark - DNSSwipeableCellDataSource

#pragma mark Required Methods
- (NSInteger)numberOfButtonsInSwipeableCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        //Even rows have 2 options
        return 2;
    } else {
        //Odd rows 3 options
        return 3;
    }
}

- (NSString *)titleForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
{
    switch (index) {
        case 0:
            return NSLocalizedString(@"Delete", @"Delete");
            break;
        case 1:
            return NSLocalizedString(@"Option 1", @"Option 1");
            break;
        case 2:
            return NSLocalizedString(@"Option 2", @"Option 2");
            break;
        default:
            break;
    }
    
    return nil;
}

- (UIColor *)backgroundColorForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
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

- (UIColor *)textColorForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
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

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailForIndexPath:indexPath fromDelegateButtonAtIndex:-1];
}

#pragma mark Optional Methods
//Uncomment the optional methods to muck around with them. 
//- (CGFloat)fontSizeForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 12.0f;
//}
//
//- (NSString *)fontNameForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath
//{
//    //List of fonts available on iOS 7: http://support.apple.com/kb/HT5878
//    return @"AmericanTypewriter";
//}

#pragma mark - DNSSwipeableCellDelegate

- (void)swipeableCell:(DNSSwipeableCell *)cell didSelectButtonAtIndex:(NSInteger)index
{
    if (index == 0) {
        [self.cellsCurrentlyEditing removeObject:cell.indexPath];
        [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:cell.indexPath];
    } else {
        [self showDetailForIndexPath:cell.indexPath fromDelegateButtonAtIndex:index];
    }
}

- (void)swipeableCellDidOpen:(DNSSwipeableCell *)cell
{
    [self.cellsCurrentlyEditing addObject:cell.indexPath];
}

- (void)swipeableCellDidClose:(DNSSwipeableCell *)cell
{
    [self.cellsCurrentlyEditing removeObject:cell.indexPath];
}

#pragma mark - Detail view

- (void)showDetailForIndexPath:(NSIndexPath *)indexPath fromDelegateButtonAtIndex:(NSInteger)buttonIndex
{
    //Instantiate the DetailVC out of the storyboard.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    NSString *title = self.itemTitles[indexPath.row];
    if (buttonIndex != -1) {
        NSString *textForCellButton = [self titleForButtonAtIndex:buttonIndex inCellAtIndexPath:indexPath];
        title = [NSString stringWithFormat:@"%@: %@", title, textForCellButton];
    } else {
        title = self.itemTitles[indexPath.row];
    }

    detail.detailText = title;
    NSString *imageName = self.imageNames[indexPath.row % self.imageNames.count];
    detail.detailImage = [UIImage imageNamed:imageName];
    
    if (buttonIndex == -1) {
        detail.title = @"Selected!";
        [self.navigationController pushViewController:detail animated:YES];
    } else {
        //Present modally
        detail.title = @"In the delegate!";
        
        //Setup nav controller to contain the detail vc.
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detail];
        
        //Setup button to close the detail VC (will call the method below.
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeModal)];
        [detail.navigationItem setRightBarButtonItem:done];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void)closeModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
