//
//  SharedObject.m
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 5/15/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "SharedObject.h"
#import "ABMultiton.h"

@implementation SharedObject

- (id)initWithFlagEqualYes
{
    self = [super init];
    if (self)
    {
        _flag = YES;
    }
    return self;
}

+ (instancetype)shared
{
    return [ABMultiton sharedInstanceOfClass:self.class withInitBlock:^id
    {
        return [[self alloc] initWithFlagEqualYes];
    }];
}

@end
