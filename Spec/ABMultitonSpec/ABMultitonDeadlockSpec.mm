//
//  ABMultitonDeadlockSpec.mm
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 5/21/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "ABMultiton+SetInstance.h"
#import "SimpleObject.h"
#import "DeadlockObject.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(ABMultitonDeadlockSpec)

describe(@"ABMultiton", ^
{
    beforeEach((id)^
    {
        [ABMultiton removeInstanceOfClass:SimpleObject.class];
        [ABMultiton removeInstanceOfClass:DeadlockObject.class];
    });

    afterEach((id)^
    {
        [ABMultiton removeInstanceOfClass:SimpleObject.class];
        [ABMultiton removeInstanceOfClass:DeadlockObject.class];
    });

    it(@"shouldn't cause deadlock", ^
    {
        DeadlockObject.shared should_not be_nil;
    });
});

SPEC_END
