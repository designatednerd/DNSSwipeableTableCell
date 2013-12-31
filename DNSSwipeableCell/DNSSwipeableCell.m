//
//  DNSSwipeableCell.m
//  DNSSwipeableCell
//
//  Created by Transferred on 12/29/13.
//  Copyright (c) 2013 Designated Nerd Software. All rights reserved.
//

#import "DNSSwipeableCell.h"

@interface DNSSwipeableCell()

@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, weak) IBOutlet UIView *myContentView;
@property (nonatomic, weak) IBOutlet UILabel *myTextLabel;

@end

@implementation DNSSwipeableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //Move the accessory view to the scroll view.
//        [self.myScrollView addSubview:self.accessoryView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClicked:(id)sender
{
    if (sender == self.button1) {
        [self.delegate buttonOneActionForItemText:self.itemText];
    } else if (sender == self.button2) {
        [self.delegate buttonTwoActionForItemText:self.itemText];
    } else {
        NSLog(@"Clicked unknown button!");
    }
}

- (void)setItemText:(NSString *)itemText
{
    //Update the instance variable
    _itemText = itemText;
    
    //Set the text to the custom label.
    self.myTextLabel.text = itemText;
}

@end
