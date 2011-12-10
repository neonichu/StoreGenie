//
//  VUMasterViewController.m
//  StoreGenie
//
//  Created by Boris Bügling on 08.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import "VUiTunesStoreItemCell.h"
#import "VUMasterViewController.h"

@interface VUMasterViewController ()

// TODO: persist store items
@property (nonatomic, strong) NSMutableArray* storeItems;

@end

#pragma mark -

@implementation VUMasterViewController

@synthesize storeItems;

#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    self.storeItems = [[NSMutableArray alloc] init];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
    [self.storeItems addObject:storeItem];
    [self.tableView reloadData];
}

-(void)failedToAddStoreItemWithId:(NSString *)itemId error:(NSError *)error {
    NSLog(@"Failed to load item '%@': %@", itemId, error);
}

@end
