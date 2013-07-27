//
//  ImageViewController.m
//  Shutterbug
//
//  Created by Alden Quimby on 7/25/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "ImageViewController.h"
#import "AttributedStringViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIPopoverController *urlPopover;

@end

@implementation ImageViewController

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(id)sender
{
    // don't perform ShowURL if there is no imageURL or we're already showing one
    if ([identifier isEqualToString:@"ShowURL"])
    {
        return self.imageURL && !self.urlPopover.popoverVisible;
    }
    else
    {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowURL"] &&
        [segue.destinationViewController isKindOfClass:[AttributedStringViewController class]])
    {
        AttributedStringViewController *asc = segue.destinationViewController;
        asc.text = [[NSAttributedString alloc] initWithString:[self.imageURL description]];
        
        // if popover segue, save popover so that we don't show multiple
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]])
        {
            self.urlPopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
        }
    }
}

- (void)setTitle:(NSString *)title
{
    super.title = title;
    self.titleBarButtonItem.title = title;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (void)resetImage
{
    // if i don't have a scrollView yet, viewDidLoad hasn't happened, do nothing
    if (!self.scrollView)
    {
        return;
    }
    
    self.scrollView.zoomScale = 1.0; // make sure we're at normal zoom
    self.scrollView.contentSize = CGSizeZero;
    self.imageView.image = nil;
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    // if we fail to load the image for some reason, do nothing
    if (!image)
    {
        return;
    }
    
    self.scrollView.contentSize = image.size;
    self.imageView.image = image;
    
    // put imageView in top left of scrollView
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

// allow zooming
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add subview, but dont set content size so nothing happens yet
    [self.scrollView addSubview:self.imageView];
    
    // allow zooming: set min/max and be delegate for scroll view
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    
    // need to call reset image in case someone set imageURL before loading
    [self resetImage];
    
    // need to set title in case someone set title before loading
    self.titleBarButtonItem.title = self.title;
}


@end
