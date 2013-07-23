//
//  MyiAd.h
//  iCarromProTablet
//
//  Created by Gururaj T on 24/01/13.
//  Copyright (c) 2013 Gururaj T ( gururaj.tallur@gmail.com ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import "iAd/ADBannerView.h"

@interface MyiAd : NSObject<ADBannerViewDelegate>
{
    ADBannerView *_adBannerView;
    BOOL _adBannerViewIsVisible;
    UIView *_contentView;
}

@property (nonatomic, assign) ADBannerView *adBannerView;
@property (nonatomic) BOOL adBannerViewIsVisible;

-(void)RemoveiAd ;
- (void)createAdBannerView ;
@end