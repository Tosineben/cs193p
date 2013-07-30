//
//  FlickrCache.h
//  SPoT
//
//  Created by Alden Quimby on 7/29/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLICKRCACHE_MAXSIZE_IPHONE 1024*1024*3
#define FLICKRCACHE_MAXSIZE_IPAD 1024*1024*10
#define FLICKRCACHE_FOLDER @"FlickrPhotos"

@interface FlickrCache : NSObject

+ (NSURL *)cachedURLforURL:(NSURL *)url;
+ (void)cacheData:(NSData *)data forURL:(NSURL *)url;

@end
