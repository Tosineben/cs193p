//
//  Photo+GMSMarker.m
//  PhotomaniaGoogle
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Photo+GMSMarker.h"

@implementation Photo (GMSMarker)

- (UIImage *)thumbnail
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbnailURLString]]];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

- (GMSMarker *)gmsMarker
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = [self coordinate];
    marker.title = self.title;
    marker.snippet = self.unique;
    return marker;
}

@end
