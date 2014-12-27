//
//  SimpleObject.h
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 2/27/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABMultitonProtocol.h"

@interface SimpleObject : NSObject <ABMultitonProtocol>

@property (nonatomic, assign) BOOL shouldRemove;

@end
