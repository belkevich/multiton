//
//  NSOperationQueue+GCD.m
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 5/21/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "NSOperationQueue+GCD.h"

@implementation NSOperationQueue (GCD)

+ (instancetype)serialQueue
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    return queue;
}

- (void)asyncBlock:(void (^)())block
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
    operation.queuePriority = NSOperationQueuePriorityNormal;
    [self addOperation:operation];
}

- (void)syncBlock:(void (^)())block
{
    if (![self isEqual:NSOperationQueue.currentQueue])
    {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
        operation.queuePriority = NSOperationQueuePriorityVeryHigh;
        [self addOperations:@[operation] waitUntilFinished:YES];
    }
    else
    {
        block();
    }
}


@end
