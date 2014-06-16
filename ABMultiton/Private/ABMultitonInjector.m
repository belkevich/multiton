//
//  ABMultitonInjector.m
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 2/28/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <objc/runtime.h>
#import "ABMultitonInjector.h"
#import "ABMultitonProtocol.h"
#import "ABMultiton.h"

NSString *const kMultitonInjectionException = @"Can't dynamically add method";

id multitonInstance(id self, __unused SEL _cmd)
{
    return [ABMultiton sharedInstanceOfClass:[self class]];
}

void removeMultitonInstance(id self, __unused SEL _cmd)
{
    [ABMultiton removeInstanceOfClass:[self class]];
}

@implementation ABMultitonInjector

#pragma mark - public

+ (void)injectMultitonProtocolMethods
{
    unsigned int count = 0;
    Class *classesArray = objc_copyClassList(&count);
    if (classesArray)
    {
        Protocol *multitonProtocol = @protocol(ABMultitonProtocol);
        SEL multitonMethod = @selector(shared);
        SEL removeMethod = @selector(removeShared);
        for (unsigned int i = 0; i < count; i++)
        {
            Class currentClass = classesArray[i];
            if (class_conformsToProtocol(currentClass, multitonProtocol))
            {
                [self addMethod:multitonMethod implementation:(IMP)multitonInstance
                        toClass:currentClass];
                [self addMethod:removeMethod implementation:(IMP)removeMultitonInstance
                        toClass:currentClass];
            }
        }
        free(classesArray);
    }
}

#pragma mark - private

+ (void)addMethod:(SEL)method implementation:(IMP)implementation toClass:(Class)theClass
{
    Class metaClass = object_getClass(theClass);
    if (!class_respondsToSelector(metaClass, method))
    {
        if (!class_addMethod(metaClass, method, implementation, "@@:"))
        {
            NSString *methodName = NSStringFromSelector(method);
            NSString *className = NSStringFromClass(theClass);
            NSString *format = @"Can't add method '%@' to class '%@'";
            NSString *reason = [NSString stringWithFormat:format, methodName,
                                                          className];
            @throw [NSException exceptionWithName:kMultitonInjectionException
                                           reason:reason userInfo:nil];
        }
    }
}

@end