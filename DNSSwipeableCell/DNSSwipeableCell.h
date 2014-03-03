//
//  DNSSwipeableCell.h
//  DNSSwipeableCell
//
//  Created by Ellen Shapiro on 12/29/13.
//  Copyright (c) 2013 Designated Nerd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DNSSwipeableCell;

@protocol DNSSwipeableCellDataSource <NSObject>
@required
/**
 * The number of buttons which should be built for a particular swipeable cell
 * @param indexPath - The indexPath in the tableView for the swipeable cell
 * @return The number of buttons for said cell.
 */
- (NSInteger)numberOfButtonsInSwipeableCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 * The title for the button at a given index in a particular swipeable cell.
 *
 * REMEMBER: Button index paths will be right to left since that's the way the cell
 * slides open - for example | index 2  index 1  index 0 |.
 * 
 * @param index - The index of the button for which this string should be the title.
 * @param indexPath - The indexPath of the cell in which to display said button. 
 * @return The title string to display.
 */
- (NSString *)titleForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 * The color for the background of a button at the given index in a swipeable cell at 
 * the given index path.
 * 
 * REMEMBER: Button index paths will be right to left since that's the way the cell
 * slides open - for example | index 2  index 1  index 0 |.
 *
 * @param index - The index of the button for which this color should be the backgroundColor.
 * @param indexPath - The indexPath of the cell in which to display said button.
 * @return The background color you wish to display.
 */
- (UIColor *)backgroundColorForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 * The color for the text of a button at the given index in a swipeable cell at
 * the given index path.
 *
 * REMEMBER: Button index paths will be right to left since that's the way the cell
 * slides open - for example | index 2  index 1  index 0 |.
 *
 * @param index - The index of the button for which this color should be the text color.
 * @param indexPath - The indexPath of the cell in which to display said button.
 * @return The text color you wish to display.
 */
- (UIColor *)textColorForButtonAtIndex:(NSInteger)index inCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol DNSSwipeableCellDelegate <NSObject>
- (void)swipeableCell:(DNSSwipeableCell *)cell didSelectButtonAtIndex:(NSInteger)index;
- (void)cellDidOpen:(DNSSwipeableCell *)cell;
- (void)cellDidClose:(DNSSwipeableCell *)cell;

@end


/**
 * ZOMG THE ACTUAL CLASS
 */
@interface DNSSwipeableCell : UITableViewCell

@property (nonatomic, strong) NSString *itemText;

//Always remember to reset the index path when the cell gets recycled, or you'll get weird behavior.
@property (nonatomic, strong) NSIndexPath *indexPath;


@property (nonatomic, weak) id <DNSSwipeableCellDelegate> delegate;
@property (nonatomic, weak) id <DNSSwipeableCellDataSource> dataSource;

- (void)openCell:(BOOL)animated;
- (void)configureButtons;

@end
