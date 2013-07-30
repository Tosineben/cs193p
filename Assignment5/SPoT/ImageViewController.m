//
//  ImageViewController.m
//  Shutterbug
//
//  Created by Alden Quimby on 7/25/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "ImageViewController.h"
#import "AttributedStringViewController.h"
#import "NetworkActivityIndicator.h"
#import "FlickrCache.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIPopoverController *urlPopover;
@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;

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
    
    self.scrollView.contentSize = CGSizeZero;
    self.imageView.image = nil;
    
    // download image on another thread
    
    [self.spinner startAnimating];
    
    NSURL *imageURL = self.imageURL; // save this before dispatching
    dispatch_queue_t imageFetchQueue = dispatch_queue_create("image fetcher", NULL);
    dispatch_async(imageFetchQueue, ^{
        
        NSData *imageData = nil;
        
        if (self.imageURL)
        {        
            NSURL *cachedURL = [FlickrCache cachedURLforURL:self.imageURL];
            
            if (cachedURL)
            {
                imageData = [[NSData alloc] initWithContentsOfURL:cachedURL];
            }
            else
            {
                // fetch from network
                [NetworkActivityIndicator start];
                imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
                [NetworkActivityIndicator stop];
                
                // cache for next time
                [FlickrCache cacheData:imageData forURL:self.imageURL];
            }
        }
        
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        // if we've switched images, do nothing
        if (self.imageURL != imageURL)
        {
            return;
        }
        
        // tell UI thread to update
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.spinner stopAnimating];
            
            if (image)
            {
                self.scrollView.zoomScale = 1.0;
                self.scrollView.contentSize = image.size;
                self.imageView.image = image;
                
                // put imageView in top left of scrollView
                self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                [self setZoomScaleToFillScreen]; 
            }
        });
    });
}

- (void)setZoomScaleToFillScreen
{
    double wScale = self.scrollView.bounds.size.width / self.imageView.image.size.width;
    double hScale = self.scrollView.bounds.size.height / self.imageView.image.size.height;
    
    if (wScale > hScale)
    {
        self.scrollView.zoomScale = wScale;
    }
    else
    {
        self.scrollView.zoomScale = hScale;
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
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
    
    self.splitViewController.delegate = self;
    [self handleSplitViewBarButtonItem:self.splitViewBarButtonItem];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setZoomScaleToFillScreen];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetImage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.imageView.image = nil;
}

#pragma mark - Scroll view

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Split view

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem)
    {
        [toolbarItems removeObject:_splitViewBarButtonItem];
    }
    if (splitViewBarButtonItem)
    {
        [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    }
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem)
    {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                               target:barButtonItem.target
                               action:barButtonItem.action];
    barButtonItem = button;
    self.splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.splitViewBarButtonItem = nil;
}

@end
