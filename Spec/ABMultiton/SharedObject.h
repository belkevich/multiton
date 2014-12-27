//
//  SharedObject.h
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 5/15/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABMultitonProtocol.h"

@interface SharedObject : NSObject <ABMultitonProtocol>

@property (nonatomic, readonly) BOOL flag;

- (id)initWithFlagEqualYes;

@end
