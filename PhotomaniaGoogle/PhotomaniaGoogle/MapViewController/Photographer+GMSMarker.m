//
//  Photographer+GMSMarker.m
//  PhotomaniaGoogle
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Photographer+GMSMarker.h"
#import "Photo+GMSMarker.h"

@implementation Photographer (GMSMarker)

- (UIImage *)thumbnail
{
    return [[self.photos anyObject] thumbnail];
}

- (GMSMarker *)gmsMarker
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = [[self.photos anyObject] coordinate];
    marker.title = self.name;
    marker.snippet = [NSString stringWithFormat:@"%d photos", [self.photos count]];
    return marker;
}

@end
