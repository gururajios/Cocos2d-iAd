//
//  MyiAd.mm
//  iCarromProTablet
//
//  Created by Gururaj T on 24/01/13.
//  Copyright (c) 2013 Gururaj T ( gururaj.tallur@gmail.com ). All rights reserved.
//

#import "MyiAd.h"

#import "AppDelegate.h"

@implementation MyiAd

@synthesize adBannerView = _adBannerView;
@synthesize adBannerViewIsVisible = _adBannerViewIsVisible;


-(id)init
{
    if(self=[super init])
    {
        _adBannerViewIsVisible = false;
        [self createAdBannerView];
        
    }
    return self;
}

- (int)getBannerHeight:(UIDeviceOrientation)orientation {
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 32;
    } else {
        return 50;
    }
}

- (int)getBannerHeight {
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}

- (void)createAdBannerView
{
    
    AppController *app =  (AppController*)[[UIApplication sharedApplication] delegate];
    
    // --- WARNING ---
    // If you are planning on creating banner views at runtime in order to support iOS targets that don't support the iAd framework
    // then you will need to modify this method to do runtime checks for the symbols provided by the iAd framework
    // and you will need to weaklink iAd.framework in your project's target settings.
    // See the iPad Programming Guide, Creating a Universal Application for more information.
    // http://developer.apple.com/iphone/library/documentation/general/conceptual/iPadProgrammingGuide/Introduction/Introduction.html
    // --- WARNING ---
    
    // Depending on our orientation when this method is called, we set our initial content size.
    // If you only support portrait or landscape orientations, then you can remove this check and
    // select either ADBannerContentSizeIdentifierPortrait (if portrait only) or ADBannerContentSizeIdentifierLandscape (if landscape only).
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
	NSString *contentSize;
	if (&ADBannerContentSizeIdentifierPortrait != nil)
	{
		contentSize = UIInterfaceOrientationIsPortrait(orientation) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifierLandscape;
	}
	else
	{
		// user the older sizes
		contentSize = UIInterfaceOrientationIsPortrait(orientation) ? ADBannerContentSizeIdentifier320x50 : ADBannerContentSizeIdentifier480x32;
    }
	
    // Calculate the intial location for the banner.
    // We want this banner to be at the bottom of the view controller, but placed
    // offscreen to ensure that the user won't see the banner until its ready.
    // We'll be informed when we have an ad to show because -bannerViewDidLoadAd: will be called.
    CGRect frame;
    frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:contentSize];
    frame.origin = CGPointMake(0.0f, CGRectGetMaxY(app.navController.view.bounds));
    
    // Now to create and configure the banner view
    self.adBannerView = [[ADBannerView alloc] initWithFrame:frame];
    // Set the delegate to self, so that we are notified of ad responses.
    self.adBannerView.delegate = self;
    // Set the autoresizing mask so that the banner is pinned to the bottom
    self.adBannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    // Since we support all orientations in this view controller, support portrait and landscape content sizes.
    // If you only supported landscape or portrait, you could remove the other from this set.
    
	self.adBannerView.requiredContentSizeIdentifiers = (&ADBannerContentSizeIdentifierPortrait != nil) ?
    [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil] :
    [NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, ADBannerContentSizeIdentifier480x32, nil];
    
    // At this point the ad banner is now be visible and looking for an ad.
    
    
}


#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_adBannerViewIsVisible) {
        _adBannerViewIsVisible = YES;
        [self showBannerView];
        
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_adBannerViewIsVisible)
    {
        _adBannerViewIsVisible = NO;
        
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        CGRect s = [[UIScreen mainScreen] bounds];
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        self.adBannerView.frame = CGRectOffset(self.adBannerView.frame, 0, s.size.height );
        [UIView commitAnimations];
    }
}

-(void)RemoveiAd
{
    _adBannerViewIsVisible = false;
    
    [self dismissAdView];
    //[self.adBannerView removeFromSuperview];
}


-(void)showBannerView
{
    _adBannerViewIsVisible = true;
    AppController * myDelegate = (((AppController*) [UIApplication sharedApplication].delegate));
    [myDelegate.navController.view addSubview:self.adBannerView];
    
    if (self.adBannerView)
    {
        CGSize s = [[CCDirector sharedDirector] winSize];

        CGRect frame = self.adBannerView.frame;
        frame.origin.y = - frame.size.height;
        frame.origin.x = (s.width/2.0f - frame.size.width/2.0f);
        
        self.adBannerView.frame = frame;
         
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             
             CGRect frame = self.adBannerView.frame;
             frame.origin.y = 0.0f;//s.height - frame.size.height;
             frame.origin.x = (s.width/2.0f - frame.size.width/2.0f);
             
             self.adBannerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
         }];
    }
    
}


-(void)hideBannerView
{
    if (self.adBannerView)
    {
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        CGRect frame = self.adBannerView.frame;
        frame.origin.y = 0.0f;
        frame.origin.x = (s.width/2.0f - frame.size.width/2.0f);
        
        self.adBannerView.frame = frame;
        
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGSize s = [[CCDirector sharedDirector] winSize];
             
             CGRect frame = self.adBannerView.frame;
             frame.origin.y = - frame.size.height;// frame.origin.y +  frame.size.height;
             frame.origin.x = (s.width/2.0f - frame.size.width/2.0f);
         }
                         completion:^(BOOL finished)
         {
         }];
    }
    
}


-(void)dismissAdView
{
    if (self.adBannerView)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGSize s = [[CCDirector sharedDirector] winSize];
             
             CGRect frame = self.adBannerView.frame;
             frame.origin.y = -frame.size.height; //frame.origin.y + frame.size.height ;
             frame.origin.x = (s.width/2.0f - frame.size.width/2.0f);
             self.adBannerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [self.adBannerView removeFromSuperview];
             self.adBannerView.delegate = nil;
             self.adBannerView = nil;
             
         }];
    }
    
}


-(void)dealloc
{
    [super dealloc];
}


@end
