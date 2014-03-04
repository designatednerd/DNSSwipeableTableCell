//
//  DetailViewController.m
//  DNSSwipeableCell
//
//  Created by Ellen Shapiro on 11/28/13.
//  Copyright (c) 2013 Designated Nerd Software. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *detailDescriptionLabel;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailImage:(UIImage *)detailImage
{
    _detailImage = detailImage;
    // Update the view.
    [self configureView];
}

- (void)setDetailText:(NSString *)detailText
{
    _detailText = detailText;
    [self configureView];
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailImage) {
        self.imageView.image = self.detailImage;
    }
    
    if (self.detailText) {
        self.detailDescriptionLabel.text = self.detailText;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
