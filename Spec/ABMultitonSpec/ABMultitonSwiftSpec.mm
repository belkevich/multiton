//
//  ABMultitonSwiftSpec.mm
//  ABMultitonSpec
//
//  Created by Denys Telezhkin on 1/18/15.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "ABMultiton.h"
#import "ABMultitonSpec-Swift.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(ABMultitonSwiftSpec)

describe(@"ABMultiton Swift spec", ^{
    
    it(@"should create shared instance", ^
       {
           SwiftSingleton * instance = SwiftSingleton.shared;
           instance should_not be_nil;
           instance should be_instance_of(SwiftSingleton.class);
       });
    
});

SPEC_END