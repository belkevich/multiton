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
#import "dispatch_safe.h"

NSString * const kMultitonException = @"class doesn't conforms to protocol ABMultitonProtocol'";
static const int kMultitonQueueKey = 1;

@interface ABMultiton ()
@property (nonatomic, readonly) NSMutableDictionary *instances;
@property (nonatomic, readonly) dispatch_queue_t concurrentQueue;
@property (nonatomic, readonly) dispatch_queue_t serialQueue;
@end

@implementation ABMultiton

#pragma mark - main routine

- (id)init
{
    self = [super init];
    if (self)
    {
        _instances = [[NSMutableDictionary alloc] init];
        _concurrentQueue = [self createDispatchQueueWithConcurrency:YES];
        _serialQueue = [self createDispatchQueueWithConcurrency:NO];
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
    dispatch_release(_concurrentQueue);
    dispatch_release(_serialQueue);
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

#pragma mark - load

+ (void)load
{
    [super load];
    @autoreleasepool
    {
        [ABMultitonInjector injectMultitonProtocolMethods];
    }
}

#pragma mark - public

+ (id)sharedInstanceOfClass:(Class)theClass
{
    return [[ABMultiton sharedInstance] sharedInstanceOfClass:theClass withInitBlock:nil];
}

+ (id)sharedInstanceOfClass:(Class)theClass withInitBlock:(id (^)())initBlock
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

- (id)sharedInstanceOfClass:(Class)theClass withInitBlock:(id (^)())initBlock
{
    NSString *className = NSStringFromClass(theClass);
    if ([theClass conformsToProtocol:@protocol(ABMultitonProtocol)])
    {
        __block id classInstance = [self getInstanceForKey:className];
        if (!classInstance)
        {
            dispatch_safe_sync(self.serialQueue, &kMultitonQueueKey, ^
            {
                classInstance = [self getInstanceForKey:className];
                if (!classInstance)
                {
                    classInstance = initBlock ? initBlock() : [[theClass alloc] init];
                    dispatch_barrier_async(self.concurrentQueue, ^
                    {
                        [self.instances setObject:classInstance forKey:className];
                    });
                }
            });
        }
        return classInstance;
    }
    NSString *reason = [NSString stringWithFormat:@"'%@' %@", className, kMultitonException];
    @throw [NSException exceptionWithName:kMultitonException reason:reason userInfo:nil];
}

- (id)getInstanceForKey:(NSString *)key
{
    __block id classInstance = nil;
    dispatch_sync(self.concurrentQueue, ^
    {
        classInstance = [self.instances objectForKey:key];
    });
    return classInstance;
}

- (void)removeInstanceOfClass:(Class)theClass
{
    NSString *className = NSStringFromClass(theClass);
    dispatch_barrier_async(self.concurrentQueue, ^
    {
        [self.instances removeObjectForKey:className];
    });
}

- (void)purgeRemovableInstances
{
    dispatch_barrier_async(self.concurrentQueue, ^
    {
        NSSet *keys = [self.instances keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop)
        {
            if ([obj respondsToSelector:@selector(isRemovableInstance)])
            {
                return [obj isRemovableInstance];
            }
            return NO;
        }];
        [self.instances removeObjectsForKeys:[keys allObjects]];
    });
}

#if TARGET_OS_IPHONE
- (void)memoryWarningReceived:(NSNotification *)notification
{
    [self purgeRemovableInstances];
}
#endif

- (dispatch_queue_t)createDispatchQueueWithConcurrency:(BOOL)concurrent
{
    NSString *name = concurrent ? @"concurrent" : @"serial";
    name = [NSString stringWithFormat:@"org.okolodev.%@.%@.%ld", self.class, name, (long)self.hash];
    const char *label = [name cStringUsingEncoding:NSUTF8StringEncoding];
    return concurrent ? dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT) :
           dispatch_safe_queue_create(label, &kMultitonQueueKey);
}

@end
