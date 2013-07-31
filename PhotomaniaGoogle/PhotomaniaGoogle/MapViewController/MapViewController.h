//
//  MapViewController.h
//  Photomania
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : UIViewController <GMSMapViewDelegate>

@property (nonatomic, strong) IBOutlet GMSMapView *mapView;

- (void)fitBoundsToMarkers;

@end
