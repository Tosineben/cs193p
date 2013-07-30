//
//  FlickrPhotoTVC.m
//  Shutterbug
//
//  Created by Alden Quimby on 7/25/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#import "RecentFlickrPhotos.h"

@interface FlickrPhotoTVC () <UISplitViewControllerDelegate>

@end

@implementation FlickrPhotoTVC

#pragma mark setup

- (void) awakeFromNib
{
    self.splitViewController.delegate = self;
}

#pragma mark UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![sender isKindOfClass:[UITableViewCell class]] ||
        ![segue.identifier isEqualToString:@"ShowImage"])
    {
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if (indexPath)
    {
        [self sendDataforIndexPath:indexPath toViewController:segue.destinationViewController];
    }
}

- (void)sendDataforIndexPath:(NSIndexPath *)indexPath
            toViewController:(UIViewController *)vc
{
    if ([vc respondsToSelector:@selector(setImageURL:)])
    {
        NSDictionary *photo = self.photos[indexPath.row];
        [RecentFlickrPhotos addPhoto:photo];
        
        NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
        [vc performSelector:@selector(setImageURL:) withObject:url];
        [vc setTitle:[self titleForRow:indexPath.row]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (NSString *)titleForRow:(NSUInteger)row
{
    // might get back NSNull, so use description
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
    return [[self.photos[row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlickrPhoto";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self sendDataforIndexPath:indexPath
              toViewController:[self.splitViewController.viewControllers lastObject]];
}

@end
