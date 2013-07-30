//
//  RecentFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Alden Quimby on 7/29/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "RecentFlickrPhotosTVC.h"
#import "RecentFlickrPhotos.h"

@interface RecentFlickrPhotosTVC ()

@end

@implementation RecentFlickrPhotosTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.photos = [RecentFlickrPhotos allPhotos];
}

@end
