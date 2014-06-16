//
//  ABMultitonSpec.mm
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 2/27/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "ABMultiton.h"
#import "SimpleObject.h"
#import "MagicObject.h"
#import "SharedObject.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(ABMultitonSpec)

describe(@"ABMultiton", ^
{
    __block SimpleObject *instance;

    afterEach((id)^
    {
        [ABMultiton removeInstanceOfClass:SimpleObject.class];
        [ABMultiton removeInstanceOfClass:MagicObject.class];
        [ABMultiton removeInstanceOfClass:SharedObject.class];
    });

    it(@"should create shared instance", ^
    {
        instance = SimpleObject.shared;
        instance should_not be_nil;
        instance should be_instance_of(SimpleObject.class);
    });

    it(@"should create shared instance with custom initialization block", ^
    {
        [ABMultiton sharedInstanceOfClass:SimpleObject.class withInitBlock:^id
        {
            SimpleObject *object = [[SimpleObject alloc] init];
            object.shouldRemove = YES;
            return object;
        }];
        SimpleObject.shared should_not be_nil;
        SimpleObject.shared.shouldRemove should equal(YES);
    });

    it(@"should inject shared instance method if it doesn't impelented", ^
    {
        __block MagicObject *object;
        ^
        {
            object = MagicObject.shared;
        } should_not raise_exception;
        object should_not be_nil;
        object should be_instance_of(MagicObject.class);
    });

    it(@"shouldn't inject shared instance method if it already implemented", ^
    {
        SharedObject *object = SharedObject.shared;
        object.flag should equal(YES);
    });

    it(@"should remove shared instance", ^
    {
        instance = SimpleObject.shared;
        [ABMultiton removeInstanceOfClass:instance.class];
        [ABMultiton containsInstanceOfClass:SimpleObject.class] should equal(NO);
    });

    it(@"should remove shared instance from class method", ^
    {
        instance = SimpleObject.shared;
        ^
        {
            [SimpleObject removeShared];
        } should_not raise_exception;
        [ABMultiton containsInstanceOfClass:SimpleObject.class] should equal(NO);
    });

    it(@"should not purge shared instance if it isn't removable", ^
    {
        instance = SimpleObject.shared;
        [ABMultiton purgeRemovableInstances];
        [ABMultiton containsInstanceOfClass:SimpleObject.class] should_not equal(NO);
    });

    it(@"should purge shared instance if it is removable", ^
    {
        instance = SimpleObject.shared;
        instance.shouldRemove = YES;
        [ABMultiton purgeRemovableInstances];
        [ABMultiton containsInstanceOfClass:SimpleObject.class] should equal(NO);
    });

    it(@"should purge removable items on memory warning", ^
    {
        instance = SimpleObject.shared;
        instance.shouldRemove = YES;
        [[NSNotificationCenter defaultCenter]
                               postNotificationName:UIApplicationDidReceiveMemoryWarningNotification
                                             object:nil];
        [ABMultiton containsInstanceOfClass:SimpleObject.class] should equal(NO);
    });

    it(@"should throw exception if class doesn't conforms ABMultitonProtocol", ^
    {
        ^
        {
            [ABMultiton sharedInstanceOfClass:NSObject.class];
        } should raise_exception;
    });
});

SPEC_END