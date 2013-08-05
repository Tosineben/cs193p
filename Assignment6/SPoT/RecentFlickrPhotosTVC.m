//
//  RecentFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Alden Quimby on 7/29/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "RecentFlickrPhotosTVC.h"
#import "SharedDocument.h"

@interface RecentFlickrPhotosTVC ()

@property (strong, nonatomic) SharedDocument *sd;

@end

@implementation RecentFlickrPhotosTVC

- (SharedDocument *)sd
{
    if (!_sd) _sd = [SharedDocument sharedDocument];
    return _sd;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.sd useDocumentWithOperation:^(BOOL success) {
        if (success)
        {
            [self setupFetchedResultsController];
        }
        else
        {
            NSLog(@"Failed to use document.");
        }
    }];
}

- (void)setupFetchedResultsController
{
    if (self.sd.managedObjectContext)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"recent.lastViewed" ascending:NO]];
        request.predicate = [NSPredicate predicateWithFormat:@"recent != nil"];
        
        if (self.searchPredicate)
        {
            request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[request.predicate, self.searchPredicate]];
        }
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.sd.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    }
    else
    {
        self.fetchedResultsController = nil;
    }
}

@end
