//
//  RecentFlickrPhotos.m
//  SPoT
//
//  Created by Alden Quimby on 7/29/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "RecentFlickrPhotos.h"
#import "FlickrFetcher.h"

@implementation RecentFlickrPhotos

#define RECENT_KEY @"RecentPhotos_Key"
#define RECENT_NUMBER 20

+ (NSArray *)allPhotos
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_KEY];
}

+ (void)addPhoto:(NSDictionary *)photo
{
    // get defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recents = [[defaults objectForKey:RECENT_KEY] mutableCopy];
    
    if (!recents)
    {
        recents = [[NSMutableArray alloc] init];
    }
    
    // if photo already in recents, remove it
    NSUInteger key = [recents indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
        return [photo[FLICKR_PHOTO_ID] isEqualToString:obj[FLICKR_PHOTO_ID]];
    }];
    if (key != NSNotFound)
    {
        [recents removeObjectAtIndex:key];
    }
    
    // add photo and bump oldest
    [recents insertObject:photo atIndex:0];
    while ([recents count] > RECENT_NUMBER)
    {
        [recents removeLastObject];
    }

    // save defaults
    [defaults setObject:recents forKey:RECENT_KEY];
    [defaults synchronize];
}

@end
