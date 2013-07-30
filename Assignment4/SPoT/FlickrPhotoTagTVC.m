//
//  FlickrPhotoTagTVC.m
//  Shutterbug
//
//  Created by Alden Quimby on 7/29/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "FlickrPhotoTagTVC.h"
#import "FlickrFetcher.h"
#import "NetworkActivityIndicator.h"

@interface FlickrPhotoTagTVC () <UISplitViewControllerDelegate>

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSDictionary *photosByTag;

@end

@implementation FlickrPhotoTagTVC

#pragma mark setup

- (void) awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self loadPhotosFromFlickr];
    [self.refreshControl addTarget:self
                            action:@selector(loadPhotosFromFlickr)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)loadPhotosFromFlickr
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t loaderQ = dispatch_queue_create("flickr loader", NULL);
    dispatch_async(loaderQ, ^{
        [NetworkActivityIndicator start];
        NSArray *photos = [FlickrFetcher stanfordPhotos];
        [NetworkActivityIndicator stop];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = [photos sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:FLICKR_PHOTO_TITLE ascending:YES]]];
            [self.refreshControl endRefreshing];
        });
    });
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self updatePhotosByTag];
    [self.tableView reloadData];
}

- (void)updatePhotosByTag
{
    NSMutableDictionary *photosByTag = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *photo in self.photos)
    {
        for (NSString *tag in [photo[FLICKR_TAGS] componentsSeparatedByString:@" "])
        {
            if ([tag isEqualToString:@"cs193pspot"] ||
                [tag isEqualToString:@"portrait"] ||
                [tag isEqualToString:@"landscape"])
            {
                continue;
            }
            
            NSMutableArray *photos = photosByTag[tag];
            if (!photos)
            {
                photos = [[NSMutableArray alloc] init];
                photosByTag[tag] = photos;
            }
            [photos addObject:photo];
        }
    }
    
    self.photosByTag = photosByTag;
}

# pragma mark segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![sender isKindOfClass:[UITableViewCell class]] ||
        ![segue.identifier isEqualToString:@"ShowTagPhotos"] ||
        ![segue.destinationViewController respondsToSelector:@selector(setPhotos:)])
    {
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if (indexPath)
    {
        NSString *tag = [self tagForRow:indexPath.row];
        [segue.destinationViewController performSelector:@selector(setPhotos:)
                                              withObject:self.photosByTag[tag]];
        [segue.destinationViewController setTitle:[tag capitalizedString]];
    }
}

#pragma mark UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photosByTag count];
}

- (NSString *)tagForRow:(NSUInteger)row
{
    return [[self.photosByTag allKeys] sortedArrayUsingSelector:@selector(compare:)][row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlickrPhotoTag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *tag = [self tagForRow:indexPath.row];
    int count = [self.photosByTag[tag] count];
    
    cell.textLabel.text = [tag capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photo%@", count, count == 1 ? @"" : @"s"];
    
    return cell;
}

@end
