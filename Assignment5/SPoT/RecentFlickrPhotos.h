//
//  RecentFlickrPhotos.h
//  SPoT
//
//  Created by Alden Quimby on 7/29/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentFlickrPhotos : NSObject

+ (NSArray *)allPhotos;
+ (void)addPhoto:(NSDictionary *)photo;

@end
