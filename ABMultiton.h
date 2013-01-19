//
//  ABMultiton.h
//  ABMultiton
//
//  Created by Alexey Belkevich on 1/13/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABSingletonProtocol.h"

@interface ABMultiton : NSObject <ABSingletonProtocol>
{
    NSMutableDictionary *singletones;
}

// actions
+ (id)sharedInstanceOfClass:(Class)theClass;

@end
