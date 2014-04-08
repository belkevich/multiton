//
//  ABMultitonSetInstanceSpec.mm
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 4/8/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//


#import "ABMultiton+SetInstance.h"
#import "SimpleObject.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(ABMultitonSetInstanceSpec)

describe(@"ABMultiton", ^
{
    __block SimpleObject *instance;

    beforeEach((id)^
    {
        instance = SimpleObject.shared;
    });

    afterEach((id)^
    {
        [ABMultiton removeInstanceOfClass:SimpleObject.class];
    });

    it(@"should set custom shared instance", ^
    {
        SimpleObject *customInstance = [[SimpleObject alloc] init];
        [ABMultiton setInstance:customInstance forClass:SimpleObject.class];
        SimpleObject *checkInstance = SimpleObject.shared;
        checkInstance should_not equal(instance);
        checkInstance should equal(customInstance);
    });
});

SPEC_END