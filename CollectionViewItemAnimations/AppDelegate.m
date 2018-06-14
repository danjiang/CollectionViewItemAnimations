//
//  AppDelegate.m
//  CollectionViewItemAnimations
//
//  Created by Nick Donaldson on 8/27/13.
//  Copyright (c) 2013 nd. All rights reserved.
//

#import "AppDelegate.h"

#import "ColorCollectionViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ColorCollectionViewController *collectionVC = [[ColorCollectionViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = collectionVC;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
