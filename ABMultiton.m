//
//  ABMultiton.m
//  ABMultiton
//
//  Created by Alexey Belkevich on 1/13/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABMultiton.h"

#define AB_MULTITON_EXCEPTION_PROTOCOL      @"class is not conforms to protocol ABSingletonProtocol"

@interface ABMultiton ()
- (id)sharedInstanceOfClass:(Class)theClass;
@end

@implementation ABMultiton

static ABMultiton *instance = nil;

#pragma mark -
#pragma mark main routine

- (id)init
{
    self = [super init];
    if (self)
    {
        singletones = [[NSMutableDictionary alloc] init];
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
#pragma mark ABSingleton protocol implementation

+ (id)sharedInstance
{
    if (!instance)
    {
        instance = [[ABMultiton alloc] init];
    }
    return instance;
}

#pragma mark -
#pragma mark actions

+ (id)sharedInstanceOfClass:(Class)theClass
{
    return [[ABMultiton sharedInstance] sharedInstanceOfClass:theClass];
}

#pragma mark -
#pragma mark private

- (id)sharedInstanceOfClass:(Class)theClass
{
    NSString *className = NSStringFromClass(theClass);
    if ([theClass conformsToProtocol:@protocol(ABSingletonProtocol)])
    {
        id classInstance = [singletones objectForKey:className];
        if (!classInstance)
        {
            classInstance = [[theClass alloc] init];
        }
        return classInstance;
    }
    NSString *reason = [NSString stringWithFormat:@"'%@' %@", className,
                        AB_MULTITON_EXCEPTION_PROTOCOL];
    @throw [NSException exceptionWithName:AB_MULTITON_EXCEPTION_PROTOCOL reason:reason
                                 userInfo:nil];
}

@end
