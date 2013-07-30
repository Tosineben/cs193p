//
//  FlickrCache.m
//  SPoT
//
//  Created by Alden Quimby on 7/29/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "FlickrCache.h"

@interface FlickrCache()

@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSURL *cacheFolder;

@end

@implementation FlickrCache

+ (NSURL *)cachedURLforURL:(NSURL *)url
{
    return nil;
}

+ (void)cacheData:(NSData *)data forURL:(NSURL *)url
{
    
}

@end
