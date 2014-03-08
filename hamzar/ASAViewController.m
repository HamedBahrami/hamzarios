//
//  ASAViewController.m
//  hamzar
//
//  Created by Hamed on 2/20/14.
//  Copyright (c) 2014 Asa. All rights reserved.
//

#import "ASAViewController.h"
#import "BWStatusBarOverlay.h"
#import "YIFullScreenScroll.h"
#include <stdlib.h>
static const CGFloat kNavBarHeight = 44.0f;

@implementation ASAViewController

{
    IBOutlet UIWebView *myWebView;
    NJKWebViewProgress *_progressProxy;

/*
    // use for scrolling effect
    __weak IBOutlet UINavigationBar *navBar;

    BOOL webViewScrollIsDragging;
    BOOL webViewScrollIsDecelerating;
*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe)];
//    [self.view addGestureRecognizer:swipeGestureRecognizer];

    _progressProxy = [[NJKWebViewProgress alloc] init];
    myWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    [self loadAsa];

    self.fullScreenScroll = [[YIFullScreenScroll alloc] initWithViewController:self scrollView:myWebView.scrollView];
    self.fullScreenScroll.shouldShowUIBarsOnScrollUp = NO;

    self.fullScreenScroll.shouldHideNavigationBarOnScroll = YES;
//    self.fullScreenScroll.shouldHideToolbarOnScroll = NO;
//    self.fullScreenScroll.shouldHideTabBarOnScroll = NO;
//
//    self.fullScreenScroll.shouldHideUIBarsWhenNotDragging = YES;
//    self.fullScreenScroll.shouldShowUIBarsOnScrollUp = NO;
    self.fullScreenScroll.additionalOffsetYToStartHiding = -100;
/*
    // use for scrolling effect
    [myWebView.scrollView setContentInset:UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0)];
    [myWebView.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0)];
    [myWebView.scrollView setContentOffset:CGPointMake(0, kNavBarHeight) animated:NO];
    myWebView.scrollView.delegate = self;
*/

    if ([self iOS5OrHigher]) {
        myWebView.scrollView.contentInset = UIEdgeInsetsMake(44.0,0.0,0.0,0.0);
    } else {
        UIScrollView *scrollview    = (UIScrollView *)[myWebView.subviews objectAtIndex:0];
        scrollview.contentInset     = UIEdgeInsetsMake(44.0,0.0,0.0,0.0);
    }
}

- (BOOL)iOS5OrHigher {
    NSString *iOSversion = [[UIDevice currentDevice] systemVersion];
    if ([iOSversion compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)searchButtonPushed:(id)sender
{
    [self loadAsa];
}

- (IBAction)reloadButtonPushed:(id)sender
{
    [myWebView reload];
}

-(void)loadAsa
{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://94.232.168.99/asa/"]];
    [myWebView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == 0.0) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
        [BWStatusBarOverlay setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
        [BWStatusBarOverlay setAnimation:BWStatusBarOverlayAnimationTypeFromTop];
        [BWStatusBarOverlay showWithMessage:@"بارگذاری..." loading:YES animated:YES];
    }
    if (progress == 1.0) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [BWStatusBarOverlay setAnimation:BWStatusBarOverlayAnimationTypeFade];
        [BWStatusBarOverlay dismissAnimated];
    }
    [BWStatusBarOverlay setProgress:progress animated:YES];
    [BWStatusBarOverlay setProgress:progress animated:YES];
}

- (void)viewDidUnload {
//    navBar = nil;
    [super viewDidUnload];
}

/*
-(void)handleSwipe{
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController setToolbarHidden:NO animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            myWebView.frame = CGRectMake(myWebView.frame.origin.x, myWebView.frame.origin.y, myWebView.frame.size.width, myWebView.frame.size.height - 88);
        }];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController setToolbarHidden:YES animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            myWebView.frame = CGRectMake(myWebView.frame.origin.x, myWebView.frame.origin.y, myWebView.frame.size.width, myWebView.frame.size.height + 88);
        }];
    }
}
*/

/*
// use for scrolling effect
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == myWebView.scrollView)
    {
        if (scrollView.contentOffset.y == 1 && !webViewScrollIsDragging && !webViewScrollIsDecelerating)
        {
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options: UIViewAnimationCurveEaseOut
                             animations:^(void) {
                                 CGRect navBarFrame = CGRectMake(0,-scrollView.contentOffset.y-kNavBarHeight, self.view.bounds.size.width, kNavBarHeight);
                                 navBar.frame = navBarFrame;
                             }
                             completion:nil];
        }
        else
        {
            CGRect navBarFrame = CGRectMake(0,-scrollView.contentOffset.y-kNavBarHeight, self.view.bounds.size.width, kNavBarHeight);
            navBar.frame = navBarFrame;
        }

        if (scrollView.contentOffset.y < -kNavBarHeight)
        {
            [myWebView.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(fabsf(scrollView.contentOffset.y), 0, 0, 0)];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == myWebView.scrollView)
    {
        webViewScrollIsDragging = YES;
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == myWebView.scrollView)
    {
        webViewScrollIsDragging = NO;
    }
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == myWebView.scrollView)
    {
        webViewScrollIsDecelerating = YES;
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == myWebView.scrollView)
    {
        webViewScrollIsDecelerating = NO;
    }
}*/
@end