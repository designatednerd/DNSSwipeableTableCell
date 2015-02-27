//
//  SwipeableDataSource.h
//  DNSSwipeableCell
//
//  Created by Ellen Shapiro on 2/26/15.
//  Copyright (c) 2015 Designated Nerd Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwipeableDataSource : NSObject


/**
 *  Instantiator
 *
 *  @param tableView      The table view to use, with nibs and classes already registered with cell identiiers.
 *  @param viewController The current view controller which should present/dismiss new views.
 *  @param cellIdentifier The cell identifier to use to dequeue cells.
 *
 *  @return The instantiated data source. 
 */
+ (SwipeableDataSource *)sourceWithTableView:(UITableView *)tableView
                              viewController:(UIViewController *)viewController
                              cellIdentifier:(NSString *)cellIdentifier;

@end
