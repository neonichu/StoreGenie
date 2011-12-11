//
//  VUMasterViewController.h
//  StoreGenie
//
//  Created by Boris Bügling on 08.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VUiTunesStoreItem.h"

@interface VUMasterViewController : UITableViewController <UIActionSheetDelegate, VUiTunesStoreItemContainer>

-(IBAction)settingsTapped:(UIBarButtonItem*)button;

@end
