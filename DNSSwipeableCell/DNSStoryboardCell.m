//
//  DNSStoryboardCell.m
//  DNSSwipeableCell
//
//  Created by Ellen Shapiro on 2/26/15.
//  Copyright (c) 2015 Designated Nerd Software. All rights reserved.
//

#import "DNSStoryboardCell.h"

@implementation DNSStoryboardCell

- (void)awakeFromNib
{
    if (![[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
        //We're on iOS 7, and cells are dumb.
        [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    }

    [super awakeFromNib];
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass(self);
}

+ (CGFloat)cellHeight
{
    return 400.0f;
}

@end
