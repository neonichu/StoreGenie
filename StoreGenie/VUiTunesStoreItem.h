//
//  VUiTunesStoreItem.h
//  StoreGenie
//
//  Created by Boris Bügling on 10.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    VUItemKind_Software,
} VUItemKind;

#pragma mark -

@class VUiTunesStoreItem;

@protocol VUiTunesStoreItemContainer <NSObject>

-(void)addStoreItem:(VUiTunesStoreItem*)storeItem;
-(void)failedToAddStoreItemWithId:(NSString*)itemId error:(NSError*)error;

@end

#pragma mark -

@interface VUiTunesStoreItem : NSObject

@property (nonatomic, readonly) NSURL* artworkSmallURL;
@property (nonatomic, readonly) NSString* itemId;
@property (nonatomic, readonly) VUItemKind kind;
@property (nonatomic, readonly) NSString* price;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSURL* viewURL;

+(void)fetchItemFromPasteboard:(UIPasteboard*)pasteboard toContainer:(id<VUiTunesStoreItemContainer>)container;
+(void)fetchItemWithId:(NSString*)itemId toContainer:(id<VUiTunesStoreItemContainer>)container;

-(id)initWithData:(NSData*)dataFromStore error:(NSError**)error;

@end
