//
//  ImageViewController.m
//  Imaginarium
//
//  Created by xiaojia on 14-3-4.
//  Copyright (c) 2014年 xiaojia. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()<UIScrollViewDelegate,UISplitViewControllerDelegate>
@property (nonatomic,strong) UIImageView *ImageView;
@property (nonatomic,strong) UIImage     *Image;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sppiner;

@end

@implementation ImageViewController

-(void)setScrollView:(UIScrollView *)ScrollView
{
    _ScrollView = ScrollView;
    _ScrollView.maximumZoomScale = 2.0;
    _ScrollView.minimumZoomScale = 0.2;
    _ScrollView.delegate = self;
   self.ScrollView.contentSize = self.Image ? self.Image.size : CGSizeZero;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.ImageView;
}

-(void)setImageURL:(NSURL *)ImageURL
{
    _ImageURL = ImageURL;
    //self.Image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.ImageURL]];
    [self startDownloadImage];
}

-(void)startDownloadImage
{
    self.Image = Nil;
    
    if(self.ImageURL){
        [self.sppiner startAnimating]; 
        NSURLRequest *request = [NSURLRequest requestWithURL:self.ImageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                    if(!error){
                        if([request.URL isEqual:self.ImageURL]){
                            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.Image = image;
                            });
                        }
                    }
                }];
       [task resume];
    }
    
}

-(UIImageView *)ImageView
{
    if(!_ImageView) _ImageView = [[UIImageView alloc] init];
    return _ImageView;
}

-(void)setImage:(UIImage *)Image
{
    self.ScrollView.zoomScale = 1.0;
    self.ImageView.image = Image;
    [self.ImageView sizeToFit];
    
    self.ImageView.frame = CGRectMake(0, 0, Image.size.width, Image.size.height);
    
    self.ScrollView.contentSize = self.Image ? self.Image.size : CGSizeZero;
    [self.sppiner stopAnimating];
}

-(UIImage *)Image
{
    return self.ImageView.image;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.ScrollView addSubview:self.ImageView];
}


#pragma UISplitViewController Delegate

-(void)awakeFromNib
{
    self.splitViewController.delegate = self;
}


-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}


-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

@end
