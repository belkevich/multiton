//
//  ABMultiton+SetInstance.h
//  ABMultitonSpec
//
//  Created by Alexey Belkevich on 4/8/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "ABMultiton.h"

@interface ABMultiton (SetInstance)

+ (void)setInstance:(id)instance forClass:(Class)theClass;

@end
