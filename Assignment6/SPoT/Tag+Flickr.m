//
//  Tag+Flickr.m
//  SPoT
//
//  Created by Alden Quimby on 8/2/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Tag+Flickr.h"
#import "FlickrFetcher.h"

@implementation Tag (Flickr)

+ (NSSet *)tagsFromFlickrInfo:(NSDictionary *)photoDictionary
       inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tagStrings = [photoDictionary[FLICKR_TAGS] componentsSeparatedByString:@" "];
    
    if (![tagStrings count])
    {
        return nil;   
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSArray *matches;
    NSError *error;
    Tag *tag;
    NSMutableSet *tags = [NSMutableSet setWithCapacity:[tagStrings count]];
    tagStrings = [tagStrings arrayByAddingObject:ALL_TAGS_STRING];
    
    for (NSString *tagString in tagStrings)
    {
        if (!tagString) continue;
        if ([tagString isEqualToString:@"cs193pspot"]) continue;
        if ([tagString isEqualToString:@"portrait"]) continue;
        if ([tagString isEqualToString:@"landscape"]) continue;
        
        tag = nil;
        error = nil;
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", tagString];
        matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1) || error)
        {
            NSLog(@"Error in tagsFromFlickrInfo: %@ %@", matches, error);
        }
        else if (![matches count])
        {
            tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
            tag.name = tagString;
        }
        else
        {
            tag = [matches lastObject];
        }
        
        if (tag)
        {
            [tags addObject:tag];
        }
    }
    
    return tags;
}

@end
