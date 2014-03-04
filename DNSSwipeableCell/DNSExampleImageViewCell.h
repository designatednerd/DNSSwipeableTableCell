//
//  DNSExampleImageViewCell.h
//  DNSSwipeableCell
//
//  Created by Ellen Shapiro on 3/3/14.
//  Copyright (c) 2014 Designated Nerd Software. All rights reserved.
//

#import "DNSSwipeableCell.h"

FOUNDATION_EXPORT CGFloat const kExampleCellHeight;

@interface DNSExampleImageViewCell : DNSSwipeableCell

@property (nonatomic, strong) UIImageView *exampleImageView;
@property (nonatomic, strong) UILabel *exampleLabel;

@end
