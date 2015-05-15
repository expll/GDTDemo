//
//  InterstitialViewController.m
//
//  Created by 高超 on 13-11-1.
//  Copyright (c) 2013年 高超. All rights reserved.
//

#import "InterstitialViewController.h"
#import <objc/runtime.h>


#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface InterstitialViewController()
{

}

@end

@implementation InterstitialViewController

static NSString *INTERSTITIAL_STATE_TEXT = @"插屏状态";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    if (IS_OS_7_OR_LATER) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
}


/**
 *  在适当的时候，初始化并调用loadAd方法进行预加载
 */
- (void)loadAd {
    
    NSLog(@"======%@==%@==", [[self topViewController] class], [[[self topViewController] view] subviews]);
    
    if ([[self topViewController] isKindOfClass:objc_getClass("GDTWebViewController")]) {
        
        [[self topViewController] dismissViewControllerAnimated:NO completion:nil];
    }
    
    if ([[self topViewController] isKindOfClass:objc_getClass("GDTStoreProductViewController")]) {
        
        [[self topViewController] dismissViewControllerAnimated:NO completion:nil];
    }
    
    if ([[self topViewController] isKindOfClass:objc_getClass("GDTInterstitialDialog")]) {
        
        [[self topViewController] dismissViewControllerAnimated:NO completion:nil];
    }
    
    _interstitialObj = [[GDTMobInterstitial alloc] initWithAppkey:@"1104183939" placementId:@"6020100367325563"];
    //NSLog(@"广点通AppKey：%@  广告位：%@", gdt_id, gdt_placeid);
    
    _interstitialObj.delegate = self; //设置委托
    _interstitialObj.isGpsOn = NO; //【可选】设置GPS开关
    //预加载广告
    [_interstitialObj loadAd];
}

/**
 *  在适当的时候，调用presentFromRootViewController来展现插屏广告
 */
- (void)showAd{
    //UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    //[[[UIAlertView alloc] initWithTitle:@"showAd" message:vc.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    //[_interstitialObj presentFromRootViewController:vc];
    [_interstitialObj presentFromRootViewController:[self topViewController]];

}
////////////
- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}
////////////////

/**
 *  广告预加载成功回调
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 */
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial
{
    
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Loaded.");
    [self showAd];
    //[[[UIAlertView alloc] initWithTitle:@"成功" message:@"1103428373" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

/**
 *  广告预加载失败回调
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial errorCode:(int)errorCode
{
    //[[[UIAlertView alloc] initWithTitle:@"失败" message:@"1103428373" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Fail Loaded." );
    
    // 广告展示时间控制
    if (self.delegate && [self.delegate respondsToSelector:@selector(LaunchTargetApp)])
    {
        [self.delegate LaunchTargetApp];
    }
}

/**
 *  插屏广告将要展示回调
 *  详解: 插屏广告即将展示回调该函数
 */
- (void)interstitialWillPresentScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Going to present.");
    //[[[UIAlertView alloc] initWithTitle:@"zhanshi" message:@"interstitialWillPresentScreen" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

/**
 *  插屏广告视图展示成功回调
 *  详解: 插屏广告展示成功回调该函数
 */
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Presented." );
    self.AdIsShow = YES;
 
}

/**
 *  插屏广告展示结束回调
 *  详解: 插屏广告展示结束回调该函数
 */
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Finish Presented.");
    self.AdIsShow = NO;
    

    
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)interstitialApplicationWillEnterBackground:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Application enter background.");
}

/**
 *  插屏广告曝光时回调
 *  详解: 插屏广告曝光时回调
 */
-(void)interstitialWillExposure:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Exposured");
}
/**
 *  插屏广告点击时回调
 *  详解: 插屏广告点击时回调
 */
-(void)interstitialClicked:(GDTMobInterstitial *)interstitial
{
    NSLog(@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Clicked");
    


}

#pragma makr 释放内存

- (void)dealloc
{
    _interstitialObj = nil;
    _delegate = nil;

}


@end
