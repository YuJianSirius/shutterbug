//
//  FlickrphotoTVC.m
//  shutterbug
//
//  Created by xiaojia on 14-3-6.
//  Copyright (c) 2014年 xiaojia. All rights reserved.
//

#import "FlickrphotoTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickrphotoTVC ()
@end

@implementation FlickrphotoTVC

-(void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}


#pragma mark - Navigation

-(void)prepareForPhoto:(ImageViewController *)ivc toDisplay:(NSDictionary *)photo
{
    ivc.ImageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]]){
        NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
        if (indexpath) {
            if ([segue.identifier isEqualToString:@"Display photo"]) {
                if([segue.destinationViewController isKindOfClass:[ImageViewController class]]){
                    [self prepareForPhoto:segue.destinationViewController
                                toDisplay:self.photos[indexpath.row]];
                }
            }
        }

    }
    
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    // is the Detail is an ImageViewController?
    if ([detail isKindOfClass:[ImageViewController class]]) {
        // yes ... we know how to update that!
        [self prepareForPhoto:detail toDisplay:self.photos[indexPath.row]];
    }
}

@end
