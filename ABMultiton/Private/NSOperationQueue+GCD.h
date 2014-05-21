//
//  NSOperationQueue+GCD.h
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 5/21/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (GCD)

+ (instancetype)serialQueue;
- (void)asyncBlock:(void (^)())block;
- (void)syncBlock:(void (^)())block;

@end
