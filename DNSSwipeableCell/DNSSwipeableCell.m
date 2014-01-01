//
//  DNSSwipeableCell.m
//  DNSSwipeableCell
//
//  Created by Transferred on 12/29/13.
//  Copyright (c) 2013 Designated Nerd Software. All rights reserved.
//

#import "DNSSwipeableCell.h"

@interface DNSSwipeableCell() <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIView *myContentView;
@property (nonatomic, weak) IBOutlet UILabel *myTextLabel;
@property (nonatomic, weak) IBOutlet UIView *myButtonContainerView;
@property (nonatomic, strong) UIPanGestureRecognizer *panHelper;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat snapPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;

@end

static CGFloat kBounceValue = 20;

@implementation DNSSwipeableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.panHelper = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panHelper.delegate = self;
    [self.myContentView addGestureRecognizer:self.panHelper];
    
    
    CGSize contentViewSize = self.myContentView.frame.size;
    contentViewSize.width += CGRectGetWidth(self.button1.frame);
    contentViewSize.width += CGRectGetWidth(self.button2.frame);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self resetContentOffsetsToZero:NO endEditing:NO];
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

- (CGFloat)buttonTotalWidth
{
    return CGRectGetWidth(self.button1.frame) + CGRectGetWidth(self.button2.frame);
}

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.myContentView];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint currentPoint = [recognizer translationInView:self.myContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {
                panningLeft = YES;
            }

            if (self.startingRightLayoutConstraintConstant == 0) {
                //The cell was closed and is now opening
                if (!panningLeft) {
                    self.contentViewRightConstraint.constant = MAX(-deltaX, 0);
                } else {
                    self.contentViewRightConstraint.constant = MIN(-deltaX, [self buttonTotalWidth]);
                }
            } else {
                //The cell is at least partially open.
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX;
                if (!panningLeft) {
                    self.contentViewRightConstraint.constant = MAX(adjustment, 0);
                } else {
                    self.contentViewRightConstraint.constant = MIN(adjustment, [self buttonTotalWidth]);
                }
            }
            
            self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant;            
        }
            break;
            
        case UIGestureRecognizerStateEnded:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //We were opening
                CGFloat halfOfButtonOne = CGRectGetWidth(self.button1.frame) / 2;
                if (self.contentViewRightConstraint.constant >= halfOfButtonOne) {
                    //Open all the way
                    [self setContentOffsetsToShowAllButtons:YES beginEditing:YES];
                } else {
                    //Re-close
                    [self resetContentOffsetsToZero:YES endEditing:YES];
                }
                
            } else {
                //We were closing
                CGFloat buttonOnePlusHalfOfButton2 = CGRectGetWidth(self.button1.frame) + (CGRectGetWidth(self.button2.frame) / 2);
                if (self.contentViewRightConstraint.constant >= buttonOnePlusHalfOfButton2) {
                    //Re-open all the way
                    [self setContentOffsetsToShowAllButtons:YES beginEditing:YES];
                } else {
                    [self resetContentOffsetsToZero:YES endEditing:YES];
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //Reset everything to 0
                [self resetContentOffsetsToZero:YES endEditing:YES];
            } else {
                //Reset to the open state
                [self setContentOffsetsToShowAllButtons:YES beginEditing:YES];
            }
            break;
        default:
            break;
    }
}

- (void)setContentOffsetsToShowAllButtons:(BOOL)animated beginEditing:(BOOL)beginEditing
{
    if (beginEditing) {
        [self.delegate cellDidBeginEditing:self];
    }
    
    if (self.contentViewRightConstraint.constant == [self buttonTotalWidth]) {
        //Already all the way open, no bounce necessary
        return;
    }
    
    self.contentViewLeftConstraint.constant = -[self buttonTotalWidth] - kBounceValue;
    self.contentViewRightConstraint.constant = [self buttonTotalWidth] + kBounceValue;
    
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    
    [self updateConstraintsIfNeeded:duration completion:^(BOOL finished) {
        self.contentViewLeftConstraint.constant = -[self buttonTotalWidth];
        self.contentViewRightConstraint.constant = [self buttonTotalWidth];
        
        [self updateConstraintsIfNeeded:duration completion:nil];
    }];
}

- (void)openCell
{
    [self setContentOffsetsToShowAllButtons:NO beginEditing:NO];
}

- (void)resetContentOffsetsToZero:(BOOL)animated endEditing:(BOOL)endEditing
{
    if (endEditing) {
        [self.delegate cellDidEndEditing:self];
    }
    if (self.contentViewLeftConstraint.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.contentViewRightConstraint.constant = -kBounceValue;
    self.contentViewLeftConstraint.constant = kBounceValue;
    
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    
    [self updateConstraintsIfNeeded:duration completion:^(BOOL finished) {
        self.contentViewRightConstraint.constant = 0;
        self.contentViewLeftConstraint.constant = 0;
        
        [self updateConstraintsIfNeeded:duration completion:nil];
    }];
}

- (void)updateConstraintsIfNeeded:(CGFloat)duration completion:(void (^)(BOOL finished))completion;
{
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //Allows scrolling to work.
    return YES;
}

@end
