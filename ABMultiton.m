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

- (instancetype)sharedInstanceOfClass:(Class)theClass;
- (void)removeInstanceOfClass:(Class)theClass;
- (void)memoryWarningReceived:(NSNotification *)notification;
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
        [[NSNotificationCenter defaultCenter]
                               addObserver:self selector:@selector(memoryWarningReceived:)
                                      name:UIApplicationDidReceiveMemoryWarningNotification
                                    object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [instances release];
    [super dealloc];
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

+ (instancetype)sharedInstanceOfClass:(Class)theClass
{
    return [[ABMultiton sharedInstance] sharedInstanceOfClass:theClass];
}

+ (void)removeInstanceOfClass:(Class)theClass
{
    [[ABMultiton sharedInstance] removeInstanceOfClass:theClass];
}

- (void)memoryWarningReceived:(NSNotification *)notification
{
    dispatch_async(lock, ^
    {
        NSSet *keys = [instances keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop)
        {
            if ([obj respondsToSelector:@selector(isRemoveOnMemoryWarning)])
            {
                return [obj isRemoveOnMemoryWarning];
            }
            return NO;
        }];
        [instances removeObjectsForKeys:[keys allObjects]];
    });
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

- (instancetype)sharedInstanceOfClass:(Class)theClass
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
