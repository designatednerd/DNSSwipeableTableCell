//
//  DNSExampleImageViewCell.h
//  DNSSwipeableCell
//
//  Created by Ellen Shapiro on 3/3/14.
//  Copyright (c) 2014 Designated Nerd Software. All rights reserved.
//

#import "DNSSwipeableCell.h"

FOUNDATION_EXPORT CGFloat const kExampleCellHeight;

/**
 * This subclass is an example of how you can subclass DNSSwipeableCell to create your own
 * custom cells that can still be properly recycled.
 */
@interface DNSExampleImageViewCell : DNSSwipeableCell

@property (nonatomic, strong) UIImageView *exampleImageView;
@property (nonatomic, strong) UILabel *exampleLabel;

@end
