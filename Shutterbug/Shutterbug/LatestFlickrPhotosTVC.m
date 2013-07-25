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
    
    self.photos = [FlickrFetcher latestGeoreferencedPhotos];
}

@end
