//
//  VUiTunesStoreItemCell.m
//  StoreGenie
//
//  Created by Boris Bügling on 10.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import "EGOImageView.h"
#import "VUiTunesStoreItem.h"
#import "VUiTunesStoreItemCell.h"

@interface VUiTunesStoreItemCell ()

@property (nonatomic, strong) EGOImageView* iconView;
@property (nonatomic, strong) UILabel* priceLabel;
@property (nonatomic, strong) UILabel* titleLabel;

@end

#pragma mark -

@implementation VUiTunesStoreItemCell

@synthesize iconView;
@synthesize item;
@synthesize priceLabel;
@synthesize titleLabel;

#pragma mark -

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // TODO: Add placeholder image
        self.iconView = [[EGOImageView alloc] initWithPlaceholderImage:nil];
        [self.contentView addSubview:self.iconView];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.priceLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat tempSize = self.contentView.frame.size.height - 4.0;
    
    self.iconView.frame = CGRectMake(2.0, 2.0, tempSize, tempSize);
    self.priceLabel.frame = CGRectMake(self.contentView.frame.size.width - 60.0, 0.0, 50.0, tempSize);
    self.titleLabel.frame = CGRectMake(tempSize + 10.0, 0.0, 80.0, tempSize);
}

-(void)setItem:(VUiTunesStoreItem *)anItem {
    if (anItem == item) {
        return;
    }
    item = anItem;
    
    self.iconView.imageURL = anItem.artworkSmallURL;
    self.priceLabel.text = [NSString stringWithFormat:@"$%@", anItem.price];
    self.titleLabel.text = anItem.title;
}

@end
