//
//  justpostedflickrphotoTVC.m
//  shutterbug
//
//  Created by xiaojia on 14-3-6.
//  Copyright (c) 2014年 xiaojia. All rights reserved.
//

#import "justpostedflickrphotoTVC.h"
#import "FlickrFetcher.h"

@interface justpostedflickrphotoTVC ()

@end

@implementation justpostedflickrphotoTVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchphotos];
    
}

-(IBAction)fetchphotos
{
    
    [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
   
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
            NSData *jsonResults = [NSData dataWithContentsOfURL:url];
            NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                                options:0
                                                                                  error:NULL];
            NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
}

@end
