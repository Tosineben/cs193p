//
//  PhotographerMapViewController.h
//  Photomania
//
//  Created by Alden Quimby on 7/31/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "MapViewController.h"

@interface PhotographerMapViewController : MapViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)reload;

@end
