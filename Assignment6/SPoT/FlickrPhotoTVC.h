//
//  FlickrPhotoTVC.h
//  Shutterbug
//
//  Created by Alden Quimby on 7/25/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"
#import "CoreDataTableViewController.h"

@interface FlickrPhotoTVC : CoreDataTableViewController

@property (nonatomic, strong) Tag *tag;
@property (nonatomic, strong) NSPredicate *searchPredicate;

@end
