//
//  VUAppDelegate.m
//  StoreGenie
//
//  Created by Boris Bügling on 08.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import "VUAppDelegate.h"
#import "VUiTunesStoreItem.h"

static NSString* kCustomURLScheme = @"storegenie";

@implementation VUAppDelegate

@dynamic masterViewController;
@synthesize window;

#pragma mark -

- (void)applicationDidBecomeActive:(UIApplication *)application {
#if TARGET_IPHONE_SIMULATOR
    // Add a fixed item for "Tetris"
    [VUiTunesStoreItem fetchItemWithId:@"479943969" toContainer:self.masterViewController];
#else
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    [VUiTunesStoreItem fetchItemFromPasteboard:pasteboard toContainer:self.masterViewController];
#endif
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation {
    url = [NSURL URLWithString:[[url absoluteString] stringByReplacingOccurrencesOfString:kCustomURLScheme withString:@"http"]];
    [VUiTunesStoreItem fetchItemWithStoreURL:url toContainer:self.masterViewController];
    return YES;
}

- (VUMasterViewController*)masterViewController {
    UINavigationController* rootVC = (UINavigationController*)self.window.rootViewController;
    return (VUMasterViewController*)[rootVC.viewControllers objectAtIndex:0];
}

@end
