//
//  SimpleObject.m
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 2/27/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "SimpleObject.h"
#import "ABMultiton.h"
#import <objc/objc-runtime.h>

@implementation SimpleObject

+ (instancetype)sharedInstance
{
//    [[self class] respondsToSelector:@selector(zalupa)];
//    Class huy = objc_getClass("SimpleObject");
//    NSLog(@"huy %d, %d, %d", class_respondsToSelector(huy, @selector(zalupa)), class_getClassMethod(self, @selector(zalupa)) != NULL, [self respondsToSelector:@selector(sharedInstance)]);
    return [ABMultiton sharedInstanceOfClass:self];
}

- (BOOL)isRemovableInstance
{
    return self.shouldRemove;
}

@end
