//
//  FlickrPhotoTVC.m
//  Shutterbug
//
//  Created by Alden Quimby on 7/25/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "Recent+Photo.h"
#import "Tag+Flickr.h"
#import "SharedDocument.h"
#import "FlatUIKit.h"

@implementation FlickrPhotoTVC

- (void)setupFetchedResultsController
{
    if (self.tag.managedObjectContext)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        
        request.predicate = [NSPredicate predicateWithFormat:@"%@ in tags", self.tag];
        
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]];
        NSString *sectionNameKeyPath = @"firstLetter";
        if ([self.tag.name isEqualToString:ALL_TAGS_STRING])
        {
            request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"tagsString" ascending:YES],
                                        [request.sortDescriptors lastObject]];
            sectionNameKeyPath = @"tagsString";
        }
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.tag.managedObjectContext
                                                                              sectionNameKeyPath:sectionNameKeyPath
                                                                                       cacheName:nil];
    }
    else
    {
        self.fetchedResultsController = nil;
    }
}

- (void)setTag:(Tag *)tag
{
    _tag = tag;
    
    if ([tag.name isEqualToString:ALL_TAGS_STRING])
    {
        self.title = @"All";
    }
    else
    {
        self.title = [tag.name capitalizedString];
    }
    
    [self setupFetchedResultsController];
}

- (void)sendDataforIndexPath:(NSIndexPath *)indexPath toViewController:(UIViewController *)vc
{
    if ([vc respondsToSelector:@selector(setImageURL:)])
    {
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [Recent recentPhoto:photo];
        [[SharedDocument sharedDocument] saveDocument:^(BOOL success) {
            if (!success)
            {
                NSLog(@"Failed to save document");
            }
        }];
        [vc performSelector:@selector(setImageURL:) withObject:[NSURL URLWithString:photo.imageURL]];
        [vc performSelector:@selector(setTitle:) withObject:photo.title];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"ShowImage"])
            {
                [self sendDataforIndexPath:indexPath toViewController:segue.destinationViewController];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupFlatUI];
}

- (void)setupFlatUI
{
    self.tableView.separatorColor = [UIColor cloudsColor];
    self.tableView.backgroundColor = [UIColor cloudsColor];
    self.tableView.backgroundView = nil;
    // self.tableView.sectionIndexColor = [UIColor peterRiverColor];
    
    self.view.backgroundColor = [UIColor cloudsColor];
}

- (void)setupFlatUITableViewCell:(UITableViewCell *)cell
{
    [cell configureFlatCellWithColor:[UIColor greenSeaColor] selectedColor:[UIColor cloudsColor]];
    cell.cornerRadius = 5.f;
    cell.separatorHeight = self.tableView.style == UITableViewStyleGrouped ? 2.f : 0.;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlickrPhoto";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // TODO this should only need to happen when cell is first created
    [self setupFlatUITableViewCell:cell];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    cell.imageView.image = [UIImage imageWithData:photo.thumbnail];
    
    // if we don't have the image yet, download it, save it to the photo, and refresh the cell
    if (!cell.imageView.image)
    {
        dispatch_queue_t q = dispatch_queue_create("Thumbnail Flickr Photo", 0);
        dispatch_async(q, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:photo.thumbnailURL]];
            [photo.managedObjectContext performBlock:^{
                photo.thumbnail = imageData;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell setNeedsLayout];
                });
            }];
        });
    }
    
    return cell;
}

// letter helpers are ugly
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *detailVc = [self.splitViewController.viewControllers lastObject];
    [self sendDataforIndexPath:indexPath toViewController:detailVc];
}

-  (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [photo.managedObjectContext performBlock:^{
            [photo delete];
            [[SharedDocument sharedDocument] saveDocument:^(BOOL success) {
                if (!success)
                {
                    NSLog(@"Failed to save document");
                }
            }];
        }];
    }
}

@end
