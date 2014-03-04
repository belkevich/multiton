//
//  AppDelegate.m
//  ABMultitonApp
//
//  Created by Alexey Belkevich on 3/4/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "AppDelegate.h"
#import "MagicObject.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MagicObject *object = MagicObject.shared;
    NSLog(@"%@", object);
    return YES;
}

@end
