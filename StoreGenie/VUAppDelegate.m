//
//  VUAppDelegate.m
//  StoreGenie
//
//  Created by Boris Bügling on 08.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import "VUAppDelegate.h"
#import "VUiTunesStoreItem.h"

@implementation VUAppDelegate

@dynamic masterViewController;
@synthesize window;

#pragma mark -

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [VUiTunesStoreItem fetchItemWithId:@"479943969" toContainer:self.masterViewController];
    return;
    
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    [VUiTunesStoreItem fetchItemFromPasteboard:pasteboard toContainer:self.masterViewController];
    
    // TODO: Provide details, link to App Store and App Shopper as well as Sharing options in detail
}

- (VUMasterViewController*)masterViewController {
    UINavigationController* rootVC = (UINavigationController*)self.window.rootViewController;
    return (VUMasterViewController*)[rootVC.viewControllers objectAtIndex:0];
}

@end
