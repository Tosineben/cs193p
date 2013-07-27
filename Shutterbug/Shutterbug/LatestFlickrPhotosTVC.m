//
//  LatestFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Alden Quimby on 7/25/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "LatestFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface LatestFlickrPhotosTVC ()

@end

@implementation LatestFlickrPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLatestPhotosFromFlickr];
    [self.refreshControl addTarget:self
                            action:@selector(loadLatestPhotosFromFlickr)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)loadLatestPhotosFromFlickr
{
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t loaderQ = dispatch_queue_create("flickr latest loader", NULL);
    dispatch_async(loaderQ, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSArray *latestPhotos = [FlickrFetcher latestGeoreferencedPhotos];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = latestPhotos;
            [self.refreshControl endRefreshing];
        });
    });
}

@end
