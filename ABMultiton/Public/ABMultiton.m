//
//  ABMultiton.m
//  ABMultiton
//
//  Created by Alexey Belkevich on 1/13/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABMultiton.h"
#import "ABMultitonProtocol.h"
#import "ABMultitonInjector.h"

NSString * const kMultitonException = @"class doesn't conforms to protocol ABMultitonProtocol'";

@interface ABMultiton ()
{
    NSMutableDictionary *_instances;
    dispatch_queue_t _lock;
}
@end

@implementation ABMultiton

#pragma mark - main routine

- (id)init
{
    self = [super init];
    if (self)
    {
        _instances = [[NSMutableDictionary alloc] init];
        _lock = dispatch_queue_create("org.okolodev.multiton_queue", NULL);
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
    if (_lock)
    {
        dispatch_release(_lock);
    }
#endif
}

#pragma mark - shared instance

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

#pragma mark - initialize

+ (void)initialize
{
    [super initialize];
    [ABMultitonInjector injectMultitonProtocolMethods];
}

#pragma mark - public

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

#pragma mark - private

- (id)sharedInstanceOfClass:(Class)theClass withInitBlock:(ABInitBlock)initBlock
{
    NSString *className = NSStringFromClass(theClass);
    if ([theClass conformsToProtocol:@protocol(ABMultitonProtocol)])
    {
        __block id classInstance;
        dispatch_sync(_lock, ^
        {
            classInstance = [_instances objectForKey:className];
            if (!classInstance)
            {
                classInstance = initBlock ? initBlock() : [[theClass alloc] init];
                [_instances setObject:classInstance forKey:className];
            }
        });
        return classInstance;
    }
    NSString *reason = [NSString stringWithFormat:@"'%@' %@", className, kMultitonException];
    @throw [NSException exceptionWithName:kMultitonException reason:reason userInfo:nil];
}

- (id)getInstanceForKey:(NSString *)key
{
    __block id classInstance = nil;
    dispatch_sync(_lock, ^
    {
        classInstance = [_instances objectForKey:key];
    });
    return classInstance;
}

- (void)removeInstanceOfClass:(Class)theClass
{
    dispatch_async(_lock, ^
    {
        NSString *className = NSStringFromClass(theClass);
        [_instances removeObjectForKey:className];
    });
}

- (void)purgeRemovableInstances
{
    dispatch_async(_lock, ^
    {
        NSSet *keys = [_instances keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop)
        {
            if ([obj respondsToSelector:@selector(isRemovableInstance)])
            {
                return [obj isRemovableInstance];
            }
            return NO;
        }];
        [_instances removeObjectsForKeys:[keys allObjects]];
    });
}

#if TARGET_OS_IPHONE
- (void)memoryWarningReceived:(NSNotification *)notification
{
    [self purgeRemovableInstances];
}
#endif

@end
