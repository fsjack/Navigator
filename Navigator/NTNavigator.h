//
//  WNNavigator.h
//
//  Created by Jackie CHEUNG on 12-12-4.
//  Copyright (c) 2012年 Jackie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NTNavigator.h"
@class NTURLMap;
@interface NTNavigator : NSObject

/** if URL Map not been set,would look for the global URLMap */
- (id)initWithNavigorController:(id)navigationController;

- (void)setNavigationActionForURLString:(void (^)(id navigatorController,NSString *urlString,UIViewController *viewController,BOOL animated))actionBlock;

- (void)setNavigatorURLMap:(NTURLMap *)map;

- (UIViewController *)navigateToURL:(NSString *)url animated:(BOOL)animated;
- (UIViewController *)navigateToURL:(NSString *)url animated:(BOOL)animated arguments:(id)arg,...;

@end



@interface UINavigationController (WNNavigator)
@property (nonatomic,readonly) NTNavigator *navigator;
@end