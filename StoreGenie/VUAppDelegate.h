//
//  VUAppDelegate.h
//  StoreGenie
//
//  Created by Boris Bügling on 08.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VUMasterViewController.h"

@interface VUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) VUMasterViewController* masterViewController;

@end
