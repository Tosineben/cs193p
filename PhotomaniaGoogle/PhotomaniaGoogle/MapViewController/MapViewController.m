//
//  MapViewController.m
//  Photomania
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

- (void)loadView
{
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];

    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.scrollGestures = YES;
    self.mapView.settings.zoomGestures = YES;
    self.mapView.settings.tiltGestures = YES;
    self.mapView.settings.rotateGestures = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    
    self.mapView.delegate = self;
    self.view = self.mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = self.mapView;
}

- (void)fitBoundsToMarkers
{
    if ([self.mapView.markers count] == 0)
    {
        return; // no markers, don't update
    }
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    
    for (GMSMarker *marker in self.mapView.markers)
    {
        bounds = [bounds includingCoordinate:marker.position];
    }

    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [self.mapView animateWithCameraUpdate:update];
}

#pragma mark - GMSMapViewDelegate

/**
 * Called before the camera on the map changes, either due to a gesture,
 * animation (e.g., by a user tapping on the "My Location" button) or by being
 * updated explicitly via the camera or a zero-length animation on layer.
 *
 * @param gesture If YES, this is occuring due to a user gesture.
 */
- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    // [mapView clear];
}

/**
 * Called repeatedly during any animations or gestures on the map (or once, if
 * the camera is explicitly set). This may not be called for all intermediate
 * camera positions. It is always called for the final position of an animation
 * or gesture.
 */
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    
}

/**
 * Called when the map becomes idle, after any outstanding gestures or
 * animations have completed (or after the camera has been explicitly set).
 */
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{

}

/**
 * Called after a tap gesture at a particular coordinate, but only if a marker
 * was not tapped.  This is called before deselecting any currently selected
 * marker (the implicit action for tapping on the map).
 */
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}

/**
 * Called after a long-press gesture at a particular coordinate.
 *
 * @param mapView The map view that was pressed.
 * @param coordinate The location that was pressed.
 */
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"You long pressed at %f,%f", coordinate.latitude, coordinate.longitude);
}

/**
 * Called after a marker has been tapped.
 *
 * @param mapView The map view that was pressed.
 * @param marker The marker that was pressed.
 * @return YES if this delegate handled the tap event, which prevents the map
 *         from performing its default selection behavior, and NO if the map
 *         should continue with its default selection behavior.
 */
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    NSLog(@"You tapped at marker %@", marker.title);
    
    return NO;
}

/**
 * Called after a marker's info window has been tapped.
 */
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    NSLog(@"You tapped at info window of marker %@", marker.title);
}

/**
 * Called after an overlay has been tapped.
 * This method is not called for taps on markers.
 *
 * @param mapView The map view that was pressed.
 * @param overlay The overlay that was pressed.
 */
- (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay
{
    NSLog(@"You tapped at overlay %@", overlay.title);
}

/**
 * Called when a marker is about to become selected, and provides an optional
 * custom info window to use for that marker if this method returns a UIView.
 * If you change this view after this method is called, those changes will not
 * necessarily be reflected in the rendered version.
 *
 * The returned UIView must not have bounds greater than 500 points on either
 * dimension.  As there is only one info window shown at any time, the returned
 * view may be reused between other info windows.
 *
 * @return The custom info window for the specified marker, or nil for default
 */
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    /*
     view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
     view.canShowCallout = YES;
     if ([mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)])
     {
     view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
     }
     view.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]])
    {
        UIImageView *imageView = (UIImageView *)(view.leftCalloutAccessoryView);
        if ([view.annotation respondsToSelector:@selector(thumbnail)])
        {
            imageView.image = [view.annotation performSelector:@selector(thumbnail)];
        }
    }
    */
    
    return nil;
}

@end
