//
//  ABMultiton.m
//  ABMultiton
//
//  Created by Alexey Belkevich on 1/13/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABMultiton.h"
#import "ABMultitonProtocol.h"

#define AB_MULTITON_EXCEPTION_PROTOCOL      @"class is not conforms to protocol ABMultitonProtocol"

@interface ABMultiton () <ABMultitonProtocol>

- (id)sharedInstanceOfClass:(Class)theClass;
- (void)removeInstanceOfClass:(Class)theClass;
@end

@implementation ABMultiton

#pragma mark -
#pragma mark main routine

- (id)init
{
    self = [super init];
    if (self)
    {
        instances = [[NSMutableDictionary alloc] init];
        lock = dispatch_queue_create("multiton queue", NULL);
    }
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
    // nothing to do
}

- (id)autorelease
{
    return self;
}

#pragma mark -
#pragma mark singleton protocol implementation

+ (instancetype)sharedInstance
{
    static ABMultiton *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        instance = [[ABMultiton alloc] init];
    });
    return instance;
}

#pragma mark -
#pragma mark actions

+ (id)sharedInstanceOfClass:(Class)theClass
{
    return [[ABMultiton sharedInstance] sharedInstanceOfClass:theClass];
}

+ (void)removeInstanceOfClass:(Class)theClass
{
    [[ABMultiton sharedInstance] removeInstanceOfClass:theClass];
}

- (void)removeInstanceOfClass:(Class)theClass
{
    NSString *className = NSStringFromClass(theClass);
    dispatch_async(lock, ^
    {
        [instances removeObjectForKey:className];
    });
}

#pragma mark -
#pragma mark private

- (id)sharedInstanceOfClass:(Class)theClass
{
    NSString *className = NSStringFromClass(theClass);
    if ([theClass conformsToProtocol:@protocol(ABMultitonProtocol)])
    {
        __block id classInstance = nil;
        dispatch_sync(lock, ^
        {
            classInstance = [instances objectForKey:className];
        });
        if (!classInstance)
        {
            classInstance = [[theClass alloc] init];
            dispatch_async(lock, ^
            {
                [instances setObject:classInstance forKey:className];
            });
            [classInstance release];
        }
        return classInstance;
    }
    NSString *reason = [NSString stringWithFormat:@"'%@' %@", className,
                                                  AB_MULTITON_EXCEPTION_PROTOCOL];
    @throw [NSException exceptionWithName:AB_MULTITON_EXCEPTION_PROTOCOL reason:reason
                                 userInfo:nil];
}

@end
