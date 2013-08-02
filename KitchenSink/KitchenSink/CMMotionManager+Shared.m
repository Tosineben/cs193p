//
//  CMMotionManager+Shared.m
//  KitchenSink
//
//  Created by Alden Quimby on 8/2/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CMMotionManager+Shared.h"

@implementation CMMotionManager (Shared)

+ (CMMotionManager *)sharedMotionManager
{
    static CMMotionManager *manager = nil;
    if (!manager)
    {
        // make sure we only create one, thread safe
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[CMMotionManager alloc] init];
        });
    }
    return manager;
}

@end
