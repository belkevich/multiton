//
//  dispatch_safe.h
//
//  Created by Alexey Belkevich on 6/16/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

dispatch_queue_t dispatch_safe_queue_create(const char *label, const void *specific);
void dispatch_safe_sync(dispatch_queue_t queue, const void *specific, dispatch_block_t block);
