//
//  InterstitialViewController.h
//
//  Created by 高超 on 13-11-1.
//  Copyright (c) 2013年 高超. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GDTMobInterstitial.h"


@protocol LaunchTargetAppDelegate <NSObject>

- (void)LaunchTargetApp;

@end


@interface InterstitialViewController : UIViewController<GDTMobInterstitialDelegate>
{
    GDTMobInterstitial *_interstitialObj;
}

@property(nonatomic, assign)BOOL AdIsShow;
@property(nonatomic, strong)GDTMobInterstitial *interstitialObj;

@property(nonatomic, assign)id delegate;

- (void)showAd;

- (void)loadAd;

@end
