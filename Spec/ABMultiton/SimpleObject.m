//
//  SimpleObject.m
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 2/27/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "SimpleObject.h"
#import "ABMultiton.h"

@implementation SimpleObject

+ (instancetype)shared
{
    return [ABMultiton sharedInstanceOfClass:self];
}

- (BOOL)isRemovableInstance
{
    return self.shouldRemove;
}

@end
