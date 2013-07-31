//
//  PhotosByPhotographerMapViewController.h
//  Photomania
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "MapViewController.h"
#import "Photographer.h"

@interface PhotosByPhotographerMapViewController : MapViewController

@property (strong, nonatomic) Photographer *photographer;

@end
