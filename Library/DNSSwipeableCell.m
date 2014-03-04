//
//  DNSSwipeableCell.m
//  DNSSwipeableCell
//
//  Created by Ellen Shapiro on 12/29/13.
//  Copyright (c) 2013 Designated Nerd Software. All rights reserved.
//

#import "DNSSwipeableCell.h"

@interface DNSSwipeableCell() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, strong) NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *contentViewLeftConstraint;

@end

@implementation DNSSwipeableCell

#pragma mark - Initialization
- (void)commonInit
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Setup button array
    self.buttons = [NSMutableArray array];
    
    //setup content view
    self.myContentView = [[UIView alloc] init];
    self.myContentView.userInteractionEnabled = YES;
    self.myContentView.clipsToBounds = YES;

    self.myContentView.backgroundColor = [UIColor whiteColor];
    self.myContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.myContentView];
    
    //Setup pan gesture recognizer
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    [self.myContentView addGestureRecognizer:self.panRecognizer];
}

- (id)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    
    return self;
}

#pragma mark - Cell Lifecycle

- (void)updateConstraints
{
    [super updateConstraints];
    if (!self.contentViewLeftConstraint) {
        NSDictionary *views = @{ @"myContentView" : self.myContentView };
        
        NSArray *verticalConstraints = [NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:|[myContentView]|"
                                        options:0
                                        metrics:nil
                                        views:views];
        [self.contentView addConstraints:verticalConstraints];
        
        NSArray *horizontalConstraints = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|[myContentView]|"
                                          options:0
                                          metrics:0
                                          views:views];
        self.contentViewLeftConstraint = horizontalConstraints[0];
        self.contentViewRightConstraint = horizontalConstraints[1];
        
        [self.contentView addConstraints:horizontalConstraints];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self resetConstraintContstantsToZero:NO notifyDelegateDidClose:NO];
    
    //Reset buttons
    for (UIButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    
}

#pragma mark - Button Config

- (void)configureButtons
{
    CGFloat previousMinX = CGRectGetWidth(self.frame);
    NSInteger buttons = [self.dataSource numberOfButtonsInSwipeableCellAtIndexPath:self.indexPath];
    for (NSInteger i = 0; i < buttons; i++) {
        UIButton *button = [self buttonForIndex:i previousButtonMinX:previousMinX inCellAtIndexPath:self.indexPath];
        [self.buttons addObject:button];
        previousMinX -= CGRectGetWidth(button.frame);
        [self.contentView addSubview:button];
    }
    
    [self.contentView bringSubviewToFront:self.myContentView];
}

- (void)configureButtonsIfNeeded
{
    if (self.buttons.count == 0) {
        [self configureButtons];
    }
}

- (UIButton *)buttonForIndex:(NSInteger)index previousButtonMinX:(CGFloat)previousMinX inCellAtIndexPath:(NSIndexPath *)indexPath
{
    //Create button with mandatory aspects
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [self.dataSource backgroundColorForButtonAtIndex:index inCellAtIndexPath:indexPath];
    [button setTitleColor:[self.dataSource textColorForButtonAtIndex:index inCellAtIndexPath:indexPath] forState:UIControlStateNormal];
    [button setTitle:[self.dataSource titleForButtonAtIndex:index inCellAtIndexPath:indexPath] forState:UIControlStateNormal];
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
    
    //Setup font if needed
    CGFloat fontPointSize = 0;
    if ([self.dataSource respondsToSelector:@selector(fontSizeForButtonAtIndex:inCellAtIndexPath:)]) {
        fontPointSize = [self.dataSource fontSizeForButtonAtIndex:index inCellAtIndexPath:indexPath];
    }
    
    NSString *fontName = nil;
    if ([self.dataSource respondsToSelector:@selector(fontNameForButtonAtIndex:inCellAtIndexPath:)]) {
        fontName = [self.dataSource fontNameForButtonAtIndex:index inCellAtIndexPath:indexPath];
    }
    
    if (fontPointSize > 0 && fontName != nil) {
        //Custom font name and point size
        button.titleLabel.font = [UIFont fontWithName:fontName size:fontPointSize];
    } else if (fontPointSize > 0) {
        //No custom font name, but custom point size
        button.titleLabel.font = [UIFont fontWithName:button.titleLabel.font.fontName size:fontPointSize];
    } else if (fontName != nil) {
        //No custom point size, but custom font name
        button.titleLabel.font = [UIFont fontWithName:fontName size:button.titleLabel.font.pointSize];
    } //else do nothing, neither is set.

    
    //Size it to fit the contents
    [button sizeToFit];
    
    //Update the origin and size to make sure that everything is the size it needs to be
    CGFloat xOrigin = previousMinX - CGRectGetWidth(button.frame);
    button.frame = CGRectMake(xOrigin, 0, CGRectGetWidth(button.frame), CGRectGetHeight(self.frame));
    
    //Add tap target
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (xOrigin < 40) {
        NSLog(@"***ATTENTION!*** Button at index %d at index path %@ is going to leave less than 40 points of space! That's going to be hard to close.", index, indexPath);
    }
    
    return button;
}

- (IBAction)buttonClicked:(id)sender
{
    if ([sender isKindOfClass:[UIButton class] ]) {
        NSInteger index = [self.buttons indexOfObject:sender];
        if (index != NSNotFound) {
            NSLog(@"Clicked button at index %d", index);
            [self.delegate swipeableCell:self didSelectButtonAtIndex:index];
        } else {
            NSAssert(NO, @"Index not in the list of buttons!");
        }
    } else {
        NSLog(@"NOT A BUTTON!");
    }
}

#pragma mark - Measurement convenience methods

- (CGFloat)halfOfFirstButtonWidth
{
    UIButton *firstButton = [self.buttons firstObject];
    return (CGRectGetWidth(firstButton.frame) / 2);
}

- (CGFloat)halfOfLastButtonXPosition
{
    UIButton *lastButton = [self.buttons lastObject];
    CGFloat halfOfLastButton = CGRectGetWidth(lastButton.frame) / 2;
    return [self buttonTotalWidth] - halfOfLastButton;
}

- (CGFloat)buttonTotalWidth
{
    //Add all the widths together
    CGFloat buttonWidth = 0;
    for (UIButton *button in self.buttons) {
        buttonWidth += CGRectGetWidth(button.frame);
    }
    
    return buttonWidth;
}

#pragma mark - Constraint animation

#pragma mark Public
- (void)openCell:(BOOL)animated
{
    [self configureButtonsIfNeeded];
    [self setConstraintsToShowAllButtons:animated notifyDelegateDidOpen:NO];
}

- (void)closeCell:(BOOL)animated
{
    [self configureButtonsIfNeeded];
    [self resetConstraintContstantsToZero:animated notifyDelegateDidClose:NO];
}

#pragma mark Private

- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate
{
    if (notifyDelegate) {
        [self.delegate swipeableCellDidOpen:self];
    }
    
    CGFloat buttonTotalWidth = [self buttonTotalWidth];
    if (self.startingRightLayoutConstraintConstant == buttonTotalWidth &&
        self.contentViewRightConstraint.constant == buttonTotalWidth) {
        //Already all the way open, no bounce necessary
        return;
    }

    self.contentViewLeftConstraint.constant = -buttonTotalWidth;
    self.contentViewRightConstraint.constant = buttonTotalWidth;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
    }];
}

- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate
{
    if (notifyDelegate) {
        [self.delegate swipeableCellDidClose:self];
    }
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.contentViewRightConstraint.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.contentViewRightConstraint.constant = 0;
    self.contentViewLeftConstraint.constant = 0;
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
    }];
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion;
{
    float duration = 0;
    if (animated) {
        duration = 0.4;
    }
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                              [self layoutIfNeeded];
                     } completion:completion];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //Allows scrolling to work.
    return YES;
}

#pragma mark - Gesture Recognizer target

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self configureButtonsIfNeeded];
            self.panStartPoint = [recognizer translationInView:self.myContentView];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.myContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {
                panningLeft = YES;
            }
            
            if (self.startingRightLayoutConstraintConstant == 0) {
                //The cell was closed and is now opening
                if (!panningLeft) {
                    CGFloat constant = MAX(-deltaX, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        NSLog(@"Setting constant to %f", constant);
                        self.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]);
                    if (constant == [self buttonTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            } else {
                //The cell was at least partially open.
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX;
                if (!panningLeft) {
                    CGFloat constant = MAX(adjustment, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(adjustment, [self buttonTotalWidth]);
                    if (constant == [self buttonTotalWidth]) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            }
            
            self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant;
        }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //We were opening
                if (self.contentViewRightConstraint.constant >= [self halfOfFirstButtonWidth]) {
                    //Open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Re-close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
                
            } else {
                //We were closing
                if (self.contentViewRightConstraint.constant >= [self halfOfLastButtonXPosition]) {
                    //Re-open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //We were closed - reset everything to 0
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                //We were open - reset to the open state
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
            
        default:
            break;
    }
}

@end
