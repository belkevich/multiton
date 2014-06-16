//
//  ABMultitonConcurrencySpec.mm
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 6/16/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "ABMultiton.h"
#import "CedarAsync.h"
#import "SimpleObject.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(ABMultitonConcurrencySpec)

describe(@"ABMultiton", ^
{
    afterEach((id)^
    {
        [ABMultiton removeInstanceOfClass:SimpleObject. class];
    });

    it(@"should return same instance on concurrent access", ^
    {
        __block SimpleObject *instance1 = [[SimpleObject alloc] init];
        __block SimpleObject *instance2 = [[SimpleObject alloc] init];
        dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue1, ^
        {
            instance1 = SimpleObject.shared;
        });
        dispatch_async(queue2, ^
        {
            instance2 = SimpleObject.shared;
        });
        in_time(instance1)should equal(instance2);
    });
});

SPEC_END