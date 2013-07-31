//
//  DemoPhotographerCDTVC.m
//  Photomania
//
//  Created by Alden Quimby on 7/30/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "DemoPhotographerCDTVC.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"

@implementation DemoPhotographerCDTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.managedObjectContext)
    {
        [self useDemoDocument];
    }
}

- (void)useDemoDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    url = [url URLByAppendingPathComponent:@"Demo Document"];
    
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        // create document
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler: ^(BOOL success) {
              if (success)
              {
                  self.managedObjectContext = document.managedObjectContext;
                  [self refreshDataFromFlickr];
              }
              else
              {
                  NSLog(@"failed to create doc!");
              }
          }];
    }
    else if (document.documentState == UIDocumentStateClosed)
    {
        // open it
        [document openWithCompletionHandler: ^(BOOL success) {
            if (success)
            {
                self.managedObjectContext = document.managedObjectContext;
            }
            else
            {
                NSLog(@"failed to open doc!");
            }
          }];
    }
    else
    {
        // try to use it
        self.managedObjectContext = document.managedObjectContext;
    }
}

- (IBAction)refreshDataFromFlickr
{
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [FlickrFetcher latestGeoreferencedPhotos];
        // put the photos in Core Data
        [self.managedObjectContext performBlock:^{
            for (NSDictionary *photo in photos)
            {
                [Photo photoWithFlickrInfo:photo inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self
                            action:@selector(refreshDataFromFlickr)
                  forControlEvents:UIControlEventValueChanged];
}


@end
