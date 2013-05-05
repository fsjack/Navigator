//
//  WNNavigatorURLScheme.h
//
//  Created by Jackie CHEUNG on 12-12-4.
//  Copyright (c) 2012年 Jackie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NTURLSchemeInitializeBlock)(id viewController);

@interface NTURLScheme : NSObject

@property (nonatomic,strong) NSURL *URL;

@property (nonatomic) Class classForInvocation;

@property (nonatomic) SEL initializeSelector;

@property (nonatomic,copy) id initializeBlock;

@end