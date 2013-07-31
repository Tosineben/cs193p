//
//  Photographer+GMSMarker.h
//  PhotomaniaGoogle
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Photographer.h"
#import <GoogleMaps/GoogleMaps.h>

@interface Photographer (GMSMarker)

- (UIImage *)thumbnail; // blocks!

- (GMSMarker *)gmsMarker;

@end
