//
//  HawaiiImageViewController.m
//  Shutterbug
//
//  Created by Alden Quimby on 7/25/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "HawaiiImageViewController.h"

@interface HawaiiImageViewController ()

@end

@implementation HawaiiImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageURL = [[NSURL alloc] initWithString:@"http://images.apple.com/v/iphone/gallery/a/images/photo_3.jpg"];
}

@end
