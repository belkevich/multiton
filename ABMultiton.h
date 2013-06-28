//
//  ABMultiton.h
//  ABMultiton
//
//  Created by Alexey Belkevich on 1/13/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^ABInitBlock)();

@interface ABMultiton : NSObject
{
    NSMutableDictionary *instances;
    dispatch_queue_t lock;
}

// actions
+ (id)sharedInstanceOfClass:(Class)theClass;
+ (id)sharedInstanceOfClass:(Class)theClass withInitBlock:(ABInitBlock)initBlock;
+ (void)removeInstanceOfClass:(Class)theClass;
+ (void)purgeRemovableInstances;
+ (BOOL)containsInstanceOfClass:(Class)theClass;

@end
