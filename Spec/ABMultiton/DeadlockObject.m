//
//  DeadlockObject.m
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 5/21/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "DeadlockObject.h"
#import "SimpleObject.h"
#import "ABMultiton.h"

@implementation DeadlockObject

- (id)init
{
    self = [super init];
    if (self)
    {
        SimpleObject.shared;
    }
    return self;
}

+ (instancetype)shared
{
    return [ABMultiton sharedInstanceOfClass:self];
}

@end
