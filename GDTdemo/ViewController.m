//
//  ViewController.m
//  GDTdemo
//
//  Created by Tiny on 15/4/20.
//  Copyright (c) 2015年 weiying. All rights reserved.
//

#import "ViewController.h"

#import "GDT.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(X) userInfo:nil repeats:YES] fire];
    
   
    UIWebView *w  =[[UIWebView alloc] initWithFrame:self.view.frame];
    [w loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [self.view addSubview:w];
}

- (void)X
{
    [GDT loadSDK];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
