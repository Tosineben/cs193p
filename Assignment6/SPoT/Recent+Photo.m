//
//  Recent+Photo.m
//  SPoT
//
//  Created by Alden Quimby on 8/2/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Recent+Photo.h"
#import "Photo.h"

@implementation Recent (Photo)

#define RECENT_FLICKR_PHOTOS_NUMBER 20

+ (Recent *)recentPhoto:(Photo *)photo
{
    Recent *recent = nil;
    
    // create fetch request
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recent"];
    request.predicate = [NSPredicate predicateWithFormat:@"photo = %@", photo];
    
    // execute fetch request
    NSError *error = nil;
    NSArray *matches = [photo.managedObjectContext executeFetchRequest:request error:&error];
    
    // check results
    if (!matches || [matches count] > 1 || error)
    {
        NSLog(@"Error in recentPhoto: %@ %@", matches, error);
    }
    else if ([matches count] == 0)
    {
        recent = [NSEntityDescription insertNewObjectForEntityForName:@"Recent" inManagedObjectContext:photo.managedObjectContext];
        recent.photo = photo;
        recent.lastViewed = [NSDate date];
        
        // now that we created one, delete oldest if over max count
        request.predicate = nil;
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastViewed" ascending:NO]];
        matches = [photo.managedObjectContext executeFetchRequest:request error:&error];
        if ([matches count] > RECENT_FLICKR_PHOTOS_NUMBER)
        {
            [photo.managedObjectContext deleteObject:[matches lastObject]];
        }
    }
    else
    {
        recent = [matches lastObject];
        recent.lastViewed = [NSDate date];
    }
    
    return recent;
}

@end
