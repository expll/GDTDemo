//
//  GDT.m
//  GDTdemo
//
//  Created by Tiny on 15/4/20.
//  Copyright (c) 2015年 weiying. All rights reserved.
//

#import "GDT.h"
#import "InterstitialViewController.h"

static InterstitialViewController *__inters;

@implementation GDT

+ (void)loadSDK
{
    if (__inters == nil) {
        __inters = [[InterstitialViewController alloc] init];
    }
    
    [__inters loadAd];
    
}

@end
