//
//  ABMultitonSpec.mm
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 2/27/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "ABMultiton.h"
#import "SimpleObject.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(ABMultitonSpec)

describe(@"ABMultiton", ^
{
    __block SimpleObject *instance;

    beforeEach(^
               {
                   instance = SimpleObject.sharedInstance;
               });

    afterEach(^
              {
                  [ABMultiton removeInstanceOfClass:SimpleObject.class];
              });


    it(@"should create shared instance", ^
    {
        instance should_not be_nil;
        instance should be_instance_of(SimpleObject.class);
    });

    it(@"should remove shared instance", ^
    {
        [ABMultiton removeInstanceOfClass:instance.class];
        [ABMultiton containsInstanceOfClass:SimpleObject.class] should equal(NO);
    });

    it(@"should not purge shared instance if it isn't removable", ^
    {
        [ABMultiton purgeRemovableInstances];
        [ABMultiton containsInstanceOfClass:SimpleObject.class] should_not equal(NO);
    });

    it(@"should purge shared instance if it is removable", ^
    {
        instance.shouldRemove = YES;
        [ABMultiton purgeRemovableInstances];
        [ABMultiton containsInstanceOfClass:SimpleObject.class] should equal(NO);
    });

    it(@"should purge removable items on memory warning", ^
    {
        instance.shouldRemove = YES;
        [[NSNotificationCenter defaultCenter]
                               postNotificationName:UIApplicationDidReceiveMemoryWarningNotification
                                             object:nil];
        [ABMultiton containsInstanceOfClass:SimpleObject.class] should equal(NO);
    });
});

SPEC_END