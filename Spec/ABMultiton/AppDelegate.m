//
//  AppDelegate.m
//  ABMultiton
//
//  Created by Alex on 12/27/14.
//  Copyright (c) 2014 Okolodev. All rights reserved.
//

#import "AppDelegate.h"
#import "MagicObject.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    MagicObject *object = MagicObject.shared;
    NSLog(@"%@", object);
    return YES;
}

@end
