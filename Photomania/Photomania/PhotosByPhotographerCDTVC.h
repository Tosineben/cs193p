//
//  PhotosByPhotographerCDTVC.h
//  Photomania
//
//  Created by Alden Quimby on 7/30/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PhotographerCDTVC.h"
#import "Photographer.h"

@interface PhotosByPhotographerCDTVC : CoreDataTableViewController

@property (strong, nonatomic) Photographer *photographer;

@end
