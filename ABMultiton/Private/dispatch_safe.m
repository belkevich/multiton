//
//  dispatch_safe.m
//
//  Created by Alexey Belkevich on 6/16/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "dispatch_safe.h"

dispatch_queue_t dispatch_safe_queue_create(const char *label, const void *specific)
{
    dispatch_queue_t queue = dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL);
    dispatch_queue_set_specific(queue, specific, (void *)CFSTR(""), (dispatch_function_t)CFRelease);
    return queue;
}

void dispatch_safe_sync(dispatch_queue_t queue, const void *specific, dispatch_block_t block)
{
    void *value = dispatch_get_specific(specific);
    if (value)
    {
        block ? block() : nil;
    }
    else
    {
        dispatch_sync(queue, block);
    }
}
