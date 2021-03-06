//
//  PhotosByPhotographerMapViewController.m
//  Photomania
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PhotosByPhotographerMapViewController.h"
#import "Photo+MKAnnotation.h"

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
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:photos];
    
    // center map on one of the photos
    Photo *photo = [photos lastObject];
    if (photo)
    {
        self.mapView.centerCoordinate = photo.coordinate;
    }
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setPhoto:" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setPhoto:"] &&
        [sender isKindOfClass:[MKAnnotationView class]])
    {
        MKAnnotationView *aView = (MKAnnotationView *)sender;
        if ([aView.annotation isKindOfClass:[Photo class]])
        {
            Photo *photo = (Photo *)aView.annotation;
            if ([segue.destinationViewController respondsToSelector:@selector(setPhoto:)])
            {
                [segue.destinationViewController performSelector:@selector(setPhoto:)
                                                      withObject:photo];
            }
        }
    }
}

@end
