//
//  WNURLMap.h
//
//  Created by Jackie CHEUNG on 12-12-4.
//  Copyright (c) 2012年 Jackie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NTURLScheme.h"
/** ------------------------------------------------------------------------
        NTURLMap -- Application Routing Map
 ------------------------------------------------------------------------
 @WHY
 NTURLMap solved problems that writing viewContrller creation codes repeatly.It required you to have your oNT URLMap in your applicaiton to provide unique URL that indicate where to come and go.
 It got little bit tricky when handling parameter passing and undefined block 'cause it involved lots of runtime techniques,so it could be confused when using it in the first time.
 
 @HOW
 Simplest creation:
 [[NTURLMap globalMap] addSchemeWithURL:@"test://home" toViewController:[UIViewController class]];
 [[NTURLMap globalMap] addSchemeWithURL:@"test://home" toViewController:[UIViewController class] initializeSelector:@selector(init)];
 
 usage:
 [self.navigationController.navigator navigateToURL:@"test://home" animated:YES arguments:nil];
 
 Notices that we dont need to pass arguments here 'cause the initializeSelector required no arguments and we didnt pass initlizeBlock in addScheme method either.
 
 Creation with block:
 InitizlizedBlock is called when viewContrller have beed created,you can do some follow-up work in the block.
 
 [[NTURLMap globalMap] addSchemeWithURL:@"test://home" toViewController:[UIViewController class] initializeSelector:@selector(init)
 initializeBlock:(NTNavigator *navigator,UIViewController *viewController,NSString *title){
    viewController.title = title;
 }];
 
 [self.navigationController.navigator navigateToURL:@"test://home" animated:YES arguments:@"title"];
 
 Why we dont need to pass navigator and viewController in arguments here? GOOD QUESTION! Because We dont have to!
 initializeBlock always pass navigator instance and viewController in front of arguments that user passed!
 
 
 Create Schemes that both selector and block needed parameters:
 [[NTURLMap globalMap] addSchemeWithURL:@"test://home" toViewController:[UIViewController class] initializeSelector:@selector(initWithNibName:bundle:) initializeBlock:(NTNavigator *navigator,UIViewController *viewController,NSString *title){
    viewController.title = title;
 }];
 
 [self.navigationController.navigator navigateToURL:@"test://home" animated:YES arguments:@"UIViewController",nil,@"title"];
 
 Since selector initWithNibName:bundle: need tow parameters and block need one parameter so we need to pass there arugments totally when navigate to URL @"test://home".
 
 Creation with Nib:
 [[NTURLMap globalMap] addSchemeWithURL:@"test://home" toViewController:[UIViewController class] nibName:@"ViewController" inBundle:[NSBundle mainBundle]];
 
 easy enough :)
 
 
 */
@interface NTURLMap : NSObject

+ (NTURLMap *)globalMap;

- (NTURLScheme *)schemeForURL:(NSString *)url;

- (void)addSchemeWithURL:(NSString *)url toViewController:(Class)viewControllerClass;

- (void)addSchemeWithURL:(NSString *)url toViewController:(Class)viewControllerClass initializeSelector:(SEL)initializeSelector;

- (void)addSchemeWithURL:(NSString *)url initializeBlock:(id)block;

@end