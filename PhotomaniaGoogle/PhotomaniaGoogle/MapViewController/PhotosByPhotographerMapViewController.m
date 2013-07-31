//
//  PhotosByPhotographerMapViewController.m
//  Photomania
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PhotosByPhotographerMapViewController.h"
#import "Photo+GMSMarker.h"
#import "Photo+Flickr.h"
#import "FlickrFetcher.h"

@implementation PhotosByPhotographerMapViewController

- (void)setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;
    if (self.view.window)
    {
        [self reload];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}

- (void)reload
{
    // get photos for photographer
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", self.photographer];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    NSArray *photos = [self.photographer.managedObjectContext executeFetchRequest:request error:NULL];

    // add photo annotations to map
    [self.mapView clear];
    for (Photo *photo in photos)
    {
        GMSMarker *marker = [photo gmsMarker];
        marker.animated = YES;
        marker.map = self.mapView;
    }
    
    // center map on one of the photos
    Photo *photo = [photos lastObject];
    if (photo)
    {
        [self.mapView animateToLocation:photo.coordinate];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    // TODO should be infoView not mapView
    [self performSegueWithIdentifier:@"setPhoto:" sender:mapView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setPhoto:"])
    {
        if ([sender isKindOfClass:[GMSMarker class]])
        {
            Photo *photo = [Photo photoWithFlickrId:((GMSMarker *)sender).snippet inManagedObjectContext:self.managedObjectContext];
            
            if ([segue.destinationViewController respondsToSelector:@selector(setPhoto:)])
            {
                [segue.destinationViewController performSelector:@selector(setPhoto:)
                                                      withObject:photo];
            }
        }
    }
}

@end
