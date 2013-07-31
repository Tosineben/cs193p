//
//  PhotoViewController.m
//  Photomania
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PhotoViewController.h"
#import "MapViewController.h"
#import "Photo+GMSMarker.h"

@interface PhotoViewController ()

@property (nonatomic, strong) MapViewController *mapVC;

@end

@implementation PhotoViewController

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    self.title = photo.title;
    self.imageURL = [NSURL URLWithString:photo.imageURL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.photo gmsMarker].map = self.mapVC.mapView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Map of Photo"] &&
        [segue.destinationViewController isKindOfClass:[MapViewController class]])
    {
        // can't set annotations yet because outlets aren't set
        // so just grab a hold of it for now, and set annotations when view loads
        self.mapVC = segue.destinationViewController;
    }
}

@end
