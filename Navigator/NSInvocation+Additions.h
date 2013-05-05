//
//  NSInvocation+Additions.h
//
//  Created by Jackie CHEUNG on 13-1-12.
//  Copyright (c) 2013年 Jackie. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NSInvocationArgumentBeginIndex 2

@interface NSInvocation (Additions)
+ (NSInvocation *)invocationWithTargetTarget:(id)target block:(id)block;

- (BOOL)setArgumentObject:(id)argumentObject atIndex:(NSInteger)idx;
- (BOOL)setArgumentObject:(id)argumentObject atIndex:(NSInteger)idx withObjCType:(const char *)type;


- (void)setArgument:(id)startArgument argumentList:(va_list)argList;
- (void)setArgument:(id)startArgument argumentList:(va_list)argList fromIndex:(NSUInteger)index;
@end


