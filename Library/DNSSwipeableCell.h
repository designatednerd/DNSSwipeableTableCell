//
//  DNSSwipeableCell.h
//  DNSSwipeableCell
//
//  Created by Ellen Shapiro on 12/29/13.
//  Copyright (c) 2013 Designated Nerd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DNSSwipeableCell;

#pragma mark - Data Source

@protocol DNSSwipeableCellDataSource <NSObject>

@required

/**
 * The number of buttons which should be built for a particular swipeable cell
 *
 * @param cell - The cell for which to determine the button count
 * @return The number of buttons for said cell.
 */
- (NSInteger)numberOfButtonsInSwipeableCell:(DNSSwipeableCell *)cell;

@optional

/**
 * The title for the button at a given index in a particular swipeable cell. Defaults to
 * an empty string.
 *
 * REMEMBER: Button indexes will be right to left since that's the way the cell
 * slides open - for example | index 2  index 1  index 0 |.
 *
 * @param cell - The cell for which to find the button title
 * @param index - The index of the button for which this string should be the title.
 * @return The title string to display.
 */
- (NSString *)swipeableCell:(DNSSwipeableCell *)cell titleForButtonAtIndex:(NSInteger)index;

/**
 * The color for the background of a button at the given index in a swipeable cell at
 * the given index path. Defaults to [UIColor redColor] for index 0 and [UIColor 
 * lightGrayColor] for all other indexes
 *
 * REMEMBER: Button indexes will be right to left since that's the way the cell
 * slides open - for example | index 2  index 1  index 0 |.
 *
 * @param cell - The cell for which to find the button background
 * @param index - The index of the button for which this color should be the backgroundColor.
 * @return The background color you wish to display.
 */
- (UIColor *)swipeableCell:(DNSSwipeableCell *)cell backgroundColorForButtonAtIndex:(NSInteger)index;

/**
 * The color for the text of a button at the given index in a swipeable cell at
 * the given index path. Defaults to [UIColor whiteColor]
 *
 * REMEMBER: Button indexes will be right to left since that's the way the cell
 * slides open - for example | index 2  index 1  index 0 |.
 *
 * @param cell - The cell for which to find the button tintColor
 * @param index - The index of the button for which this color should be the text color.
 * @return The text color you wish to display.
 */
- (UIColor *)swipeableCell:(DNSSwipeableCell *)cell tintColorForButtonAtIndex:(NSInteger)index;

/**
 * Configures the image for a button at a given index. Note that you should not set both
 * an image and a title for the same cell. Defaults to null.
 *
 * REMEMBER: Button indexes will be right to left since that's the way the cell
 * slides open - for example | index 2  index 1  index 0 |.
 *
 * @param cell - The cell for which you wish to find the button image.
 * @param index - The index of the button for which this should be the image.
 * @return The Image you wish to display.
 */
- (UIImage *)swipeableCell:(DNSSwipeableCell *)cell imageForButtonAtIndex:(NSInteger)index;

/**
 * Configures the font for a button at a given index. Defaults to the UIButton font 
 * provided by the system.
 *
 * REMEMBER: Button indexes will be right to left since that's the way the cell
 * slides open - for example | index 2  index 1  index 0 |.
 *
 * @param cell - The cell for which you wish to find the font.
 * @param index - The index of the button for which this should be the font.
 * @return The font you wish to display.
 */
- (UIFont *)swipeableCell:(DNSSwipeableCell *)cell fontForButtonAtIndex:(NSInteger)index;

@end

#pragma mark - Delegate
@protocol DNSSwipeableCellDelegate <NSObject>

/**
 * Notifies the delegate that a particular button was selected.
 *
 * REMEMBER: Button indexes will be right to left since that's the way the cell
 * slides open - for example | index 2  index 1  index 0 |.
 *
 * @param cell - The cell sending this message
 * @param index - The index of the button selected.
 */
- (void)swipeableCell:(DNSSwipeableCell *)cell didSelectButtonAtIndex:(NSInteger)index;

/**
 * Notifies the delegate that a particular cell did open, to facilitate the delegate's
 * management of which cells are open and which cells are closed.
 * @param cell - The swipeable cell which opened.
 */
- (void)swipeableCellDidOpen:(DNSSwipeableCell *)cell;

/**
 * Notifies the delegate that a particular cell did close, to facilitate the delegate's
 * management of which cells are open and which cells are closed.
 * @param cell - The swipeable cell which closed.
 */
- (void)swipeableCellDidClose:(DNSSwipeableCell *)cell;

@end


#pragma mark - Actual Class
/**
 * ZOMG THE ACTUAL CLASS
 */
@interface DNSSwipeableCell : UITableViewCell

@property (nonatomic, strong) UIView *myContentView;

//The delegate and datasource.
@property (nonatomic, weak) id <DNSSwipeableCellDelegate> delegate;
@property (nonatomic, weak) id <DNSSwipeableCellDataSource> dataSource;

/**
 * Slides the cell to all the way open.
 * @param animated - YES if the cell opening should be animated, NO if not.
 */
- (void)openCell:(BOOL)animated;

/**
 * Slides the cell all the way closed.
 * @param animated - YES if the cell closing should be animated, NO if not.
 */
- (void)closeCell:(BOOL)animated;

/**
 * Initialization methods which are called no matter which initializer is called. Should
 * only be overridden by subclasses and not called directly.
 */
- (void)commonInit;

@end
