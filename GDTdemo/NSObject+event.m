//
//  NSObject+event.m
//  GDTdemo
//
//  Created by Tiny on 15/5/13.
//  Copyright (c) 2015年 weiying. All rights reserved.
//

#import "NSObject+event.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation NSObject (event)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        
        //----------------------------------| UIViewController |---------------------------------------
        Class class = objc_getClass("UIResponder");
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);              -[UnityViewControllerBase viewDidAppear:]:
        
        SEL originalSelector = @selector(touchesBegan:withEvent:);
        SEL swizzledSelector = @selector(patch_touchesBegan:withEvent:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}
#pragma mark - Method Swizzling

- (void)patch_touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    NSLog(@"===%@===%@===", touches, event);
    [self patch_touchesBegan:touches withEvent:event];
}


@end
