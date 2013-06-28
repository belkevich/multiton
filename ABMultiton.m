//
//  ABMultiton.m
//  ABMultiton
//
//  Created by Alexey Belkevich on 1/13/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABMultiton.h"
#import "ABMultitonProtocol.h"

#define AB_MULTITON_EXCEPTION_PROTOCOL      @"class doesn't conforms to protocol 'ABMultitonProtocol'"

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
#if TARGET_OS_IPHONE
        [[NSNotificationCenter defaultCenter]
                               addObserver:self selector:@selector(memoryWarningReceived:)
                                      name:UIApplicationDidReceiveMemoryWarningNotification
                                    object:nil];
#endif
    }
    return self;
}

- (void)dealloc
{
#if TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif

#if !OS_OBJECT_USE_OBJC
    if (lock)
    {
        dispatch_release(lock);
    }
#endif
}

#pragma mark -
#pragma mark shared instance

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
    return [[ABMultiton sharedInstance] sharedInstanceOfClass:theClass withInitBlock:nil];
}

+ (id)sharedInstanceOfClass:(Class)theClass withInitBlock:(ABInitBlock)initBlock
{
    return [[ABMultiton sharedInstance] sharedInstanceOfClass:theClass withInitBlock:initBlock];
}

+ (void)removeInstanceOfClass:(Class)theClass
{
    [[ABMultiton sharedInstance] removeInstanceOfClass:theClass];
}

+ (void)purgeRemovableInstances
{
    [[ABMultiton sharedInstance] purgeRemovableInstances];
}

+ (BOOL)containsInstanceOfClass:(Class)theClass
{
    NSString *className = NSStringFromClass(theClass);
    return ([[ABMultiton sharedInstance] getInstanceForKey:className] != nil);
}

#pragma mark -
#pragma mark private

- (id)sharedInstanceOfClass:(Class)theClass withInitBlock:(ABInitBlock)initBlock
{
    NSString *className = NSStringFromClass(theClass);
    if ([theClass conformsToProtocol:@protocol(ABMultitonProtocol)])
    {
        id classInstance = [self getInstanceForKey:className];
        if (!classInstance)
        {
            classInstance = initBlock ? initBlock() : [[theClass alloc] init];
            dispatch_async(lock, ^
            {
                [instances setObject:classInstance forKey:className];
            });
        }
        return classInstance;
    }
    NSString *reason = [NSString stringWithFormat:@"'%@' %@", className,
                                                  AB_MULTITON_EXCEPTION_PROTOCOL];
    @throw [NSException exceptionWithName:AB_MULTITON_EXCEPTION_PROTOCOL reason:reason
                                 userInfo:nil];
}

- (id)getInstanceForKey:(NSString *)key
{
    __block id classInstance = nil;
    dispatch_sync(lock, ^
    {
        classInstance = [instances objectForKey:key];
    });
    return classInstance;
}

- (void)removeInstanceOfClass:(Class)theClass
{
    NSString *className = NSStringFromClass(theClass);
    dispatch_async(lock, ^
    {
        [instances removeObjectForKey:className];
    });
}

- (void)purgeRemovableInstances
{
    dispatch_async(lock, ^
    {
        NSSet *keys = [instances keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop)
        {
            if ([obj respondsToSelector:@selector(isRemovableInstance)])
            {
                return [obj isRemovableInstance];
            }
            return NO;
        }];
        [instances removeObjectsForKeys:[keys allObjects]];
    });
}

#if TARGET_OS_IPHONE
- (void)memoryWarningReceived:(NSNotification *)notification
{
    [self purgeRemovableInstances];
}
#endif

@end
