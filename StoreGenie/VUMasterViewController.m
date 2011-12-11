//
//  VUMasterViewController.m
//  StoreGenie
//
//  Created by Boris Bügling on 08.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import "VUiTunesStoreItemCell.h"
#import "VUDetailViewController.h"
#import "VUMasterViewController.h"

enum {
    kAbout              = 0,
    kCancel             = 1,
};

@interface VUMasterViewController ()

@property (nonatomic, strong) NSMutableArray* storeItems;
@property (nonatomic, strong) NSString* persistencePath;

@end

#pragma mark -

@implementation VUMasterViewController

@dynamic persistencePath;
@synthesize storeItems;

#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.persistencePath]) {
        self.storeItems = [NSMutableArray arrayWithContentsOfFile:self.persistencePath];
    } else {
        self.storeItems = [[NSMutableArray alloc] init];
    }
}

- (NSString*)persistencePath {
    NSArray* searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (searchPaths.count < 1) return nil;
    return [[searchPaths objectAtIndex:0] stringByAppendingPathComponent:@"StoreGenieWishlist.plist"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Actions

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            // TODO: Show about message
            return;
        case 1:
            return;
    }
    
    [NSException raise:@"Unhandled button" format:@"Button with index %d not yet handled.", buttonIndex];
}

-(void)settingsTapped:(UIBarButtonItem*)button {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Settings" delegate:self cancelButtonTitle:@"Cancel" 
                                               destructiveButtonTitle:nil otherButtonTitles:@"About", nil];
    [actionSheet showFromBarButtonItem:button animated:YES];
}

// TODO: Allow deleting and reordering of items

#pragma mark -
#pragma mark UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VUDetailViewController* detailVC = (VUDetailViewController*)[self.navigationController topViewController];
    detailVC.detailItem = [self.storeItems objectAtIndex:indexPath.row];
}

#pragma mark -
#pragma mark UITableViewDataSource delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VUiTunesStoreItemCell *cell = (VUiTunesStoreItemCell *)[tableView dequeueReusableCellWithIdentifier:@"VUiTunesStoreItemCell"];
    
    if (cell == nil) {
        cell = [[VUiTunesStoreItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VUiTunesStoreItemCell"];
    }
    
    cell.item = [self.storeItems objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    return self.storeItems.count;
}

#pragma mark -
#pragma mark VUiTunesStoreItemContainer delegate methods

-(void)addStoreItem:(VUiTunesStoreItem *)storeItem {
    for (VUiTunesStoreItem* item in self.storeItems) {
        if ([item.itemId isEqualToString:storeItem.itemId]) {
            return;
        }
    }
    
    [self.storeItems addObject:storeItem];
    [self.storeItems writeToFile:self.persistencePath atomically:NO];
    
    [self.tableView reloadData];
}

-(void)failedToAddStoreItemWithId:(NSString *)itemId error:(NSError *)error {
    // TODO: Display error
    NSLog(@"Failed to load item '%@': %@", itemId, error);
}

@end
