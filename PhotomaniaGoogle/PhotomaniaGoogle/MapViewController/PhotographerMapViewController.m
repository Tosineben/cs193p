//
//  PhotographerMapViewController.m
//  Photomania
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PhotographerMapViewController.h"
#import "Photographer+GMSMarker.h"
#import "Photographer+Create.h"
#import <CoreData/CoreData.h>

@implementation PhotographerMapViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    // reload only if on screen
    if (self.view.window)
    {
        [self reload];
        [self fitBoundsToMarkers];
    }
}

- (void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = [NSPredicate predicateWithFormat:@"photos.@count > 2"];
    
    NSError *error;
    NSArray *photographers = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    // TODO check error
    [self.mapView clear];
    for (Photographer *photographer in photographers)
    {
        GMSMarker *marker = [photographer gmsMarker];
        marker.map = self.mapView;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reload];
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    [self performSegueWithIdentifier:@"setPhotographer:" sender:marker];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setPhotographer:"])
    {
        if ([sender isKindOfClass:[GMSMarker class]])
        {
            Photographer *photographer = [Photographer photographerWithName:((GMSMarker *)sender).title
                                                     inManagedObjectContext:self.managedObjectContext];
            
            if ([segue.destinationViewController respondsToSelector:@selector(setPhotographer:)])
            {
                [segue.destinationViewController performSelector:@selector(setPhotographer:)
                                                      withObject:photographer];
                [segue.destinationViewController performSelector:@selector(setManagedObjectContext:)
                                                      withObject:self.managedObjectContext];
            }
        }
    }
}

@end
