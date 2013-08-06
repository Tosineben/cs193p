//
//  Photo+Flickr.m
//  SPoT
//
//  Created by Alden Quimby on 8/2/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Tag+Flickr.h"
#import "Recent.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    // create fetch request
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [photoDictionary[FLICKR_PHOTO_ID] description]];
    
    // execute fetch request
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count] > 1 || error)
    {
        NSLog(@"Error in photoWithFlickrInfo: %@ %@", matches, error);
    }
    else if ([matches count] == 0)
    {
        BOOL isPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
        
        // create new photo
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [photoDictionary[FLICKR_PHOTO_ID] description];
        photo.title = [photoDictionary[FLICKR_PHOTO_TITLE] description];
        photo.subtitle = [[photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description];
        photo.firstLetter = [photo.title substringToIndex:1];

        photo.imageURL = [[FlickrFetcher urlForPhoto:photoDictionary
                                              format:isPad ? FlickrPhotoFormatOriginal : FlickrPhotoFormatLarge] absoluteString];
        photo.thumbnailURL = [[FlickrFetcher urlForPhoto:photoDictionary
                                                  format:FlickrPhotoFormatSquare] absoluteString];
        
        photo.tags = [Tag tagsFromFlickrInfo:photoDictionary inManagedObjectContext:context];
        NSArray *tags = [[photo.tags allObjects] sortedArrayUsingComparator:^NSComparisonResult(Tag *tag1, Tag *tag2) {
            return [tag1.name compare:tag2.name];
        }];
        photo.tagsString = [((Tag *)tags[1]).name capitalizedString];
        
        photo.thumbnail = nil; // get later
        photo.recent = nil; // get later
    }
    else
    {
        // photo already exists
        photo = [matches lastObject];
    }
    
    return photo;
}

- (void)delete
{
    for (Tag *tag in self.tags)
    {
        if ([tag.photos count] == 1)
        {
            [self.managedObjectContext deleteObject:tag];
        }
    }
    
    self.tags = nil;
    
    if (self.recent)
    {
        [self.managedObjectContext deleteObject:self.recent];
    }
}

@end
