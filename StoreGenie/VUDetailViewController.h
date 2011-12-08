//
//  VUDetailViewController.h
//  StoreGenie
//
//  Created by Boris Bügling on 08.12.11.
//  Copyright (c) 2011 Extessy AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VUDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
