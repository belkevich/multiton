//
//  ABMultiton+SetInstance.m
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 4/8/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "ABMultiton+SetInstance.h"

@interface ABMultiton ()
@property (nonatomic, readonly) NSMutableDictionary *instances;
@property (nonatomic, readonly) dispatch_queue_t concurrentQueue;
+ (instancetype)sharedInstance;
@end

@implementation ABMultiton (SetInstance)

#pragma mark - public

+ (void)setInstance:(id)instance forClass:(Class)theClass
{
    [[ABMultiton sharedInstance] setInstance:instance forClass:theClass];
}

#pragma mark - private

- (void)setInstance:(id)instance forClass:(Class)theClass
{
    NSString *className = NSStringFromClass(theClass);
    dispatch_barrier_async(self.concurrentQueue, ^
    {
        [self.instances setObject:instance forKey:className];
    });
}

@end
