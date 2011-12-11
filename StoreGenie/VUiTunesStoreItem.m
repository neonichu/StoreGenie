//
//  VUiTunesStoreItem.m
//  StoreGenie
//
//  Created by Boris Bügling on 10.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import "DTWebArchive.h"
#import "NSError+StoreGenie.h"
#import "UIPasteboard+DTWebArchive.h"
#import "VUiTunesStoreItem.h"

static NSString* kiTunesDataURL = @"http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStoreServices.woa/wa/wsLookup?id=%@";
static NSString* kURLFragment = @"href=\"http://itunes.apple.com/";
static NSUInteger kURLLength = 6;

static NSString* kArtworkUrlSmall   = @"artworkUrl60";
static NSString* kItemId            = @"trackId";
static NSString* kItemKind          = @"kind";
static NSString* kPrice             = @"price";
static NSString* kResultCount       = @"resultCount";
static NSString* kResults           = @"results";
static NSString* kTitle             = @"trackName";
static NSString* kViewUrl           = @"trackViewUrl";

@interface VUiTunesStoreItem ()

@property (nonatomic, readonly) NSDictionary* firstResult;
@property (nonatomic, strong) id storeData;

@end

#pragma mark -

@implementation VUiTunesStoreItem

@dynamic artworkSmallURL;
@dynamic firstResult;
@dynamic itemId;
@dynamic price;
@dynamic title;
@dynamic viewURL;

@synthesize kind;
@synthesize storeData;

#pragma mark -

+(void)fetchItemFromPasteboard:(UIPasteboard*)pasteboard toContainer:(id<VUiTunesStoreItemContainer>)container {
    DTWebArchive* webArchive = pasteboard.webArchive;
    if (!webArchive) {
        [container failedToAddStoreItemWithId:nil error:[NSError errorWithCode:kSGNoPasteboardData description:@"No HTML in pasteboard"]];
        return;
    }
    
    NSString* htmlString = [[NSString alloc] initWithData:webArchive.mainResource.data encoding:NSUTF8StringEncoding];
    
    NSRange iTunesLinkLocation = [htmlString rangeOfString:kURLFragment];
    if (iTunesLinkLocation.location == NSNotFound) return;
    
    NSRange end = [htmlString rangeOfString:@"\"" options:0 range:NSMakeRange(iTunesLinkLocation.location + kURLLength, htmlString.length -
                                                                              iTunesLinkLocation.location - kURLLength)];
    if (end.location == NSNotFound) return;
    
    NSInteger start = iTunesLinkLocation.location + kURLLength;
    htmlString = [htmlString substringWithRange:NSMakeRange(start, end.location - start)];
    
    [self fetchItemWithStoreURL:[NSURL URLWithString:htmlString] toContainer:container];
}

+(void)fetchItemWithStoreURL:(NSURL*)storeURL toContainer:(id<VUiTunesStoreItemContainer>)container {
    NSString* urlString = [storeURL absoluteString];
    NSRange iTunesLinkLocation = [urlString rangeOfString:@"id"];
    if (iTunesLinkLocation.location == NSNotFound) return;
    NSRange end = [urlString rangeOfString:@"?"];
    if (iTunesLinkLocation.location == NSNotFound) return;
    urlString = [urlString substringWithRange:NSMakeRange(iTunesLinkLocation.location + 2, 
                                                            end.location - iTunesLinkLocation.location - 2)];
    
    [self fetchItemWithId:urlString toContainer:container];
}

+(void)fetchItemWithId:(NSString*)itemId toContainer:(id<VUiTunesStoreItemContainer>)container {
    NSURL* iTunesDataURL = [NSURL URLWithString:[NSString stringWithFormat:kiTunesDataURL, itemId]];
    NSURLRequest* request = [NSURLRequest requestWithURL:iTunesDataURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] 
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
                               if (!data) {
                                   [container failedToAddStoreItemWithId:itemId error:error];
                                   return;
                               }
                               
                               VUiTunesStoreItem* item = [[self alloc] initWithData:data error:&error];
                               
                               if (!item) {
                                   [container failedToAddStoreItemWithId:itemId error:error];
                                   return;
                               }
                               
                               [container addStoreItem:item];
                           }];
}

-(id)initWithData:(NSData*)dataFromStore error:(NSError**)error {
    self = [super init];
    if (self) {
        self.storeData = [NSJSONSerialization JSONObjectWithData:dataFromStore options:0 error:error];
        if (!self.storeData) {
            return nil;
        }
        if ([[self.storeData valueForKey:kResultCount] intValue] != 1) {
            if (error) {
                *error = [NSError errorWithCode:kSGResultCount description:@"Result count mismatch."];
            }
            self.storeData = nil;
            return nil;
        }
    }
    return self;
}

#pragma mark -

-(NSDictionary*)firstResult {
    return [[storeData objectForKey:kResults] objectAtIndex:0];
}

-(NSURL*)artworkSmallURL {
    return [NSURL URLWithString:[self.firstResult objectForKey:kArtworkUrlSmall] ];
}

-(NSString*)itemId {
    return [self.firstResult objectForKey:kItemId];
}

-(NSString*)price {
    return [self.firstResult objectForKey:kPrice];
}

-(NSString*)title {
    return [self.firstResult objectForKey:kTitle];
}

-(NSURL*)viewURL {
    return [NSURL URLWithString:[self.firstResult objectForKey:kViewUrl]];
}

@end
