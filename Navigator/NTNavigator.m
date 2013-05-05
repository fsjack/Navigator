//
//  WNNavigator.m
//
//  Created by Jackie CHEUNG on 12-12-4.
//  Copyright (c) 2012年 Jackie. All rights reserved.
//

#import "NTNavigator.h"
#import "NTURLMap.h"
#import "NTURLScheme.h"
#import <objc/runtime.h>
#import "NSInvocation+Additions.h"
@interface NTNavigator ()
@property (nonatomic,strong,setter = setNavigatorURLMap:) NTURLMap *map;
@property (nonatomic,weak) id navigatorController;
@property (nonatomic,copy,setter = setNavigationActionForURLString:) void (^navigationActionForURLStringBlock)(id navigatorController,NSString *urlString,UIViewController *viewController,BOOL animated);
@end

@implementation NTNavigator

- (id)init{
    self = [super init];
    if(self){        
    }
    return self;
}

- (id)initWithNavigorController:(id)navigationController{
    self = [super init];
    if(self){
        self.navigatorController = navigationController;
    }
    return self;
}

- (UIViewController *)navigateToURL:(NSString *)url animated:(BOOL)animated{
    return [self navigateToURL:url animated:animated arguments:nil];
}

- (UIViewController *)navigateToURL:(NSString *)url animated:(BOOL)animated arguments:(id)arg,...{
    NTURLScheme *scheme = [(self.map ? self.map : [NTURLMap globalMap]) schemeForURL:url];
    
    if(!scheme) return nil;

    Class viewControllerClass = [scheme classForInvocation];
    SEL initializeSelector    = scheme.initializeSelector;
    id initializeBlock        = scheme.initializeBlock;
    
    if( (!viewControllerClass && !initializeSelector) && !initializeBlock ) {
        [[NSException exceptionWithName:NSObjectNotAvailableException reason:@"initializeSelector or initializeBlock should not be nil" userInfo:nil] raise];
        return nil;
    }
    
    UIViewController *viewController = nil;
    NSInvocation *invocation = nil;
    id viewControllerInstance = nil;
    va_list argList;
    va_start(argList, arg);
    if(initializeSelector){
        viewControllerInstance = [viewControllerClass alloc];
        
        NSMethodSignature *signature = [viewControllerClass instanceMethodSignatureForSelector:initializeSelector];
        invocation     = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:initializeSelector];
        [invocation setArgument:arg argumentList:argList];
        [invocation invokeWithTarget:viewControllerInstance];
        
        CFTypeRef returnValue   = NULL;
        [invocation getReturnValue:&returnValue];
        if (returnValue) CFRetain(returnValue);
        viewController = (__bridge_transfer id)returnValue;
    }
    
    if(initializeBlock){
        invocation = [NSInvocation invocationWithTargetTarget:self block:initializeBlock];
        [invocation setArgument:arg argumentList:argList];
        [invocation invokeWithTarget:self];
        
        CFTypeRef returnValue   = NULL;
        [invocation getReturnValue:&returnValue];
        if (returnValue) CFRetain(returnValue);
        viewController = (__bridge_transfer id)returnValue;
    }
    
    va_end(argList);
    
    if(!viewController || ![viewController isKindOfClass:[UIViewController class]]){
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"view controller instantiation is failed!" userInfo:nil] raise];
        return nil;
    }
    
    if(self.navigationActionForURLStringBlock) self.navigationActionForURLStringBlock(self.navigatorController,url,viewController,animated);
    
    return viewController;
}

@end

static char kNTNavigatorObjectKey;
@implementation UINavigationController (NTNavigator)
- (NTNavigator *)navigator{
    NTNavigator *navigator = objc_getAssociatedObject(self, &kNTNavigatorObjectKey);
    if(!navigator){
        navigator = [[NTNavigator alloc] initWithNavigorController:self];
        objc_setAssociatedObject(self, &kNTNavigatorObjectKey, navigator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [navigator setNavigationActionForURLString:^(id navigatorController,NSString *urlString,UIViewController *viewController,BOOL animated) {
            [navigatorController pushViewController:viewController animated:animated];
        }];
    }
    return navigator;
}
@end