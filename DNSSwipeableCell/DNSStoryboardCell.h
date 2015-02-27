//
//  DNSStoryboardCell.h
//  DNSSwipeableCell
//
//  Created by Ellen Shapiro on 2/26/15.
//  Copyright (c) 2015 Designated Nerd Software. All rights reserved.
//

#import "DNSSwipeableCell.h"

@interface DNSStoryboardCell : DNSSwipeableCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)cellHeight;

@property (nonatomic, weak) IBOutlet UIImageView *storyboardImageView;
@property (nonatomic, weak) IBOutlet UILabel *storyboardExampleLabel;

@end
