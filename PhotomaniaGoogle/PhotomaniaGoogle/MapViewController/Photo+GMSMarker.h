//
//  Photo+GMSMarker.h
//  PhotomaniaGoogle
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Photo.h"
#import <GoogleMaps/GoogleMaps.h>

@interface Photo (GMSMarker)

- (UIImage *)thumbnail; // blocks!

- (CLLocationCoordinate2D)coordinate;

- (GMSMarker *)gmsMarker;

@end
