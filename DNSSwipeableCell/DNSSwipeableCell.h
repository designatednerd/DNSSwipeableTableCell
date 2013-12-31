//
//  DNSSwipeableCell.h
//  DNSSwipeableCell
//
//  Created by Transferred on 12/29/13.
//  Copyright (c) 2013 Designated Nerd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DNSSwipeableCellDelegate <NSObject>
- (void)buttonOneActionForItemText:(NSString *)itemText;
- (void)buttonTwoActionForItemText:(NSString *)itemText;
@end

@interface DNSSwipeableCell : UITableViewCell

@property (nonatomic, strong) NSString *itemText;
@property (nonatomic, weak) id <DNSSwipeableCellDelegate> delegate;
@end
