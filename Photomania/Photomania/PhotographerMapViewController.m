//
//  PhotographerMapViewController.m
//  Photomania
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PhotographerMapViewController.h"
#import "Photographer+MKAnnotation.h"
#import <CoreData/CoreData.h>

@interface PhotographerMapViewController ()

@end

@implementation PhotographerMapViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    // reload only if on screen
    if (self.view.window)
    {
        [self reload];        
    }
}

- (void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = [NSPredicate predicateWithFormat:@"photos.@count > 2"];
    
    NSError *error;
    NSArray *photographers = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    // TODO check error
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:photographers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reload];
}


- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setPhotographer:" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setPhotographer:"])
    {
        if ([sender isKindOfClass:[MKAnnotationView class]])
        {
            MKAnnotationView *aView = (MKAnnotationView *)sender;
            if ([aView.annotation isKindOfClass:[Photographer class]])
            {
                Photographer *photographer = (Photographer *)aView.annotation;
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotographer:)])
                {
                    [segue.destinationViewController performSelector:@selector(setPhotographer:)
                                                          withObject:photographer];
                }
            }
        }
    }
}


@end
