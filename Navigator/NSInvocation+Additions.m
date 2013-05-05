//
//  NSInvocation+Additions.m
//
//  Created by Jackie CHEUNG on 13-1-12.
//  Copyright (c) 2013年 Jackie. All rights reserved.
//

#import "NSInvocation+Additions.h"
#import <objc/runtime.h>
#import <CTObjectiveCRuntimeAdditions/CTObjectiveCRuntime.h>

@implementation NSInvocation (Additions)

+ (NSInvocation *)invocationWithTargetTarget:(id)target block:(id)block{
    IMP theImplementation = imp_implementationWithBlock(block);
    CTBlockDescription *blockDescription = [[CTBlockDescription alloc] initWithBlock:block];
    NSMutableString *selectorString = [NSMutableString stringWithString:@"method:"];
    NSMutableString *objCTypeString = [NSMutableString stringWithFormat:@"%s@:",[blockDescription.blockSignature methodReturnType]]; //return type is object(@)
    for(int i = 2;i < blockDescription.blockSignature.numberOfArguments;i++){
        [selectorString appendString:@"parameter:"];
        [objCTypeString appendFormat:@"%s",[blockDescription.blockSignature getArgumentTypeAtIndex:i]];
    }
    
    NSString *uniqueName = [NSString stringWithFormat:@"%@-%@", NSStringFromClass([target class]), selectorString];
    SEL sel = sel_registerName([uniqueName UTF8String]);
    if(!class_addMethod([target class], sel, theImplementation, [objCTypeString UTF8String])){
        class_replaceMethod([target class], sel, theImplementation, [objCTypeString UTF8String]);
    }
    
    NSMethodSignature *signature = [target methodSignatureForSelector:sel];
    NSInvocation *invocation     = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:sel];
    
    return invocation;
}

static BOOL objCTypeIsObject(const char *type){
    if(!strcmp(type, "@") || !strcmp(type, "#")) return YES;
    else return NO;
}

- (BOOL)setArgumentObject:(id)argumentObject atIndex:(NSInteger)idx{
   return [self setArgumentObject:argumentObject atIndex:idx withObjCType:[self.methodSignature getArgumentTypeAtIndex:(idx + NSInvocationArgumentBeginIndex)]];
}

- (BOOL)setArgumentObject:(id)argumentObject atIndex:(NSInteger)idx withObjCType:(const char *)type{
    if(!argumentObject) return YES;
    if(!objCTypeIsObject(type) && ![argumentObject isKindOfClass:[NSValue class]]) return NO;
    
    NSUInteger index = (idx + NSInvocationArgumentBeginIndex);
    NSNumber *number = (NSNumber *)argumentObject;
    void *pointer = NULL;
    switch (*type) {
        case 'c': {
            char value = [number charValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 'C': {
            unsigned char value = [number unsignedCharValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 'i': {
            int value = [number intValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 'I': {
            unsigned int value = [number unsignedIntegerValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 's': {
            short value = [number shortValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 'S':{
            unsigned short value = [number unsignedShortValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 'l': {
            long value = [number longValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 'L':{
            unsigned long value = [number unsignedLongValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 'q': {
            long long value = [number longLongValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 'Q': {
            unsigned long long value = [number unsignedLongLongValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 'f': {
            float value = [number floatValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 'd': {
            double value = [number doubleValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 'B': {
            bool value = [number boolValue];
            [self setArgument:&value atIndex:index];
            break;
        }case 'v': break;
        case '*': break;
        case '@':
        case '#': {
            [self setArgument:&argumentObject atIndex:index];
            break;
        }case '?':
        case '^': {
            pointer = [argumentObject pointerValue];
            [self setArgument:&pointer atIndex:index];
            break;
        }default:
            break;
    }
    return YES;
}



- (void)setArgument:(id)startArgument argumentList:(va_list)argList{
    [self setArgument:startArgument argumentList:argList fromIndex:0];
}

- (void)setArgument:(id)startArgument argumentList:(va_list)argList fromIndex:(NSUInteger)index{
    NSMethodSignature *signature = self.methodSignature;
    int numberOfArgument = [signature numberOfArguments];
    while (numberOfArgument-NSInvocationArgumentBeginIndex > index ) {
        if(![self setArgumentObject:startArgument atIndex:index]){
            [[NSException exceptionWithName:NSInvalidArgumentException reason:@"paramter type your passing in is not correct" userInfo:nil] raise];
            return;
        }
        index++;
        if(index >= (numberOfArgument-NSInvocationArgumentBeginIndex) ) break;
        startArgument = va_arg(argList, id );
    }
}
    
@end
