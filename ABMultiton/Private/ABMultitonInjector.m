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

@implementation ABMultitonInjector

+ (void)injectMultitonProtocolMethods
{
    unsigned int count = 0;
    Class *classesArray = objc_copyClassList(&count);
    if (classesArray)
    {
        Protocol *multitonProtocol = @protocol(ABMultitonProtocol);
        SEL multitonMethod = @selector(shared);
        for (unsigned int i = 0; i < count; i++)
        {
            Class currentClass = classesArray[i];
            if (class_conformsToProtocol(currentClass, multitonProtocol))
            {
                Class metaClass = object_getClass(currentClass);
                if (!class_respondsToSelector(metaClass, multitonMethod))
                {
                    if (!class_addMethod(metaClass, multitonMethod, (IMP)multitonInstance, "@@:"))
                    {
                        NSString *methodName = NSStringFromSelector(multitonMethod);
                        NSString *className = NSStringFromClass(currentClass);
                        NSString *format = @"Can't add method '%@' to class '%@'";
                        NSString *reason = [NSString stringWithFormat:format, methodName,
                                                     className];
                        @throw [NSException exceptionWithName:kMultitonInjectionException
                                                       reason:reason userInfo:nil];
                    }
                }
            }
        }
        free(classesArray);
    }
}

@end