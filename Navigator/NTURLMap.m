//
//  WNURLMap.m
//
//  Created by Jackie CHEUNG on 12-12-4.
//  Copyright (c) 2012年 Jackie. All rights reserved.
//

#import "NTURLMap.h"
@interface NTURLMap ()
@property  (nonatomic,strong) NSMutableDictionary *schemeURLMaps;
@end

@implementation NTURLMap

+ (NTURLMap *)globalMap{
    static NTURLMap *_map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_map){
            _map = [[NTURLMap alloc] init];
        }
    });
    return _map;    
}

- (id)init{
    self = [super init];
    if(self){
        self.schemeURLMaps = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NTURLScheme *)schemeForURL:(NSString *)url{
    return [self.schemeURLMaps objectForKey:url];
}

- (NTURLScheme *)addSchemeURL:(NSString *)url classForInvocation:(Class)aClass initializeSelector:(SEL)selector initializeBlock:(id)block{
    if([self schemeForURL:url]) return [self schemeForURL:url];
    NTURLScheme *scheme         = [[NTURLScheme alloc] init];
    scheme.URL                  = [NSURL URLWithString:url];
    scheme.classForInvocation   = aClass;
    scheme.initializeSelector   = selector;
    scheme.initializeBlock      = block;
    
    [self.schemeURLMaps setObject:scheme forKey:url];
    
    return scheme;
}

- (void)addSchemeWithURL:(NSString *)url toViewController:(Class)viewControllerClass{
    [self addSchemeURL:url classForInvocation:viewControllerClass initializeSelector:@selector(init) initializeBlock:nil];
}

- (void)addSchemeWithURL:(NSString *)url toViewController:(Class)viewControllerClass initializeSelector:(SEL)initializeSelector{
    [self addSchemeURL:url classForInvocation:viewControllerClass initializeSelector:initializeSelector initializeBlock:nil];
}

- (void)addSchemeWithURL:(NSString *)url initializeBlock:(id)block{
    [self addSchemeURL:url classForInvocation:nil initializeSelector:nil initializeBlock:block];
}

@end
