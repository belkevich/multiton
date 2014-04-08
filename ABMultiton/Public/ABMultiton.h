//
//  ABMultiton.h
//  ABMultiton
//
//  Created by Alexey Belkevich on 1/13/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABMultiton : NSObject

+ (id)sharedInstanceOfClass:(Class)theClass;
+ (id)sharedInstanceOfClass:(Class)theClass withInitBlock:(id (^)())initBlock;
+ (void)removeInstanceOfClass:(Class)theClass;
+ (void)purgeRemovableInstances;
+ (BOOL)containsInstanceOfClass:(Class)theClass;

@end
