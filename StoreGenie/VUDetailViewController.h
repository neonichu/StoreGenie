//
//  VUDetailViewController.h
//  StoreGenie
//
//  Created by Boris Bügling on 08.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VUiTunesStoreItem.h"

@interface VUDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel* detailDescriptionLabel;
@property (strong, nonatomic) VUiTunesStoreItem* detailItem;

@end
