//
//  FlickrPhotoTVC.m
//  Shutterbug
//
//  Created by Alden Quimby on 7/25/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoTVC ()

@end

@implementation FlickrPhotoTVC

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![sender isKindOfClass:[UITableViewCell class]] ||
        ![segue.identifier isEqualToString:@"ShowImage"] ||
        ![segue.destinationViewController respondsToSelector:@selector(setImageURL:)])
    {
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if (indexPath)
    {
        NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
        [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
        [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
    }
}

#pragma mark - Table view data source

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
    // might get back NSNull, so use description
    return [self.photos[row][FLICKR_PHOTO_OWNER] description];
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

@end
