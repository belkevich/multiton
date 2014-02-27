//
//  ABMultitonProtocol.h
//  ABMultiton
//
//  Created by Alexey Belkevich on 1/16/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ABMultitonProtocol <NSObject>

@required
+ (instancetype)sharedInstance;

@optional
- (BOOL)isRemovableInstance;

@end
