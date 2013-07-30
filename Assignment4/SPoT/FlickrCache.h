//
//  FlickrCache.h
//  SPoT
//
//  Created by Alden Quimby on 7/29/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrCache : NSObject

+ (NSURL *)cachedURLforURL:(NSURL *)url;
+ (void)cacheData:(NSData *)data forURL:(NSURL *)url;

@end
