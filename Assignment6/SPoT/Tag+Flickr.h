//
//  Tag+Flickr.h
//  SPoT
//
//  Created by Alden Quimby on 8/2/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Tag.h"

#define ALL_TAGS_STRING @"00000"

@interface Tag (Flickr)

+ (NSSet *)tagsFromFlickrInfo:(NSDictionary *)photoDictionary
       inManagedObjectContext:(NSManagedObjectContext *)context;

@end
