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

static NSString* kArtworkUrlSmall   = @"artworkUrl60";
static NSString* kItemId            = @"trackId";
static NSString* kItemKind          = @"kind";
static NSString* kPrice             = @"price";
static NSString* kResultCount       = @"resultCount";
static NSString* kResults           = @"results";
static NSString* kTitle             = @"trackName";
static NSString* kViewUrl           = @"trackViewUrl";

@interface VUiTunesStoreItem ()

@property (nonatomic, strong) id storeData;

@end

#pragma mark -

@implementation VUiTunesStoreItem

@dynamic artworkSmall;
@dynamic itemId;
@dynamic price;
@dynamic title;
@dynamic viewUrl;

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
    NSRange iTunesLinkLocation = [htmlString rangeOfString:@"label=\"View In iTunes\""];
    htmlString = [htmlString substringWithRange:NSMakeRange(iTunesLinkLocation.location, 100)];
    iTunesLinkLocation = [htmlString rangeOfString:@"http://"];
    NSRange end = [htmlString rangeOfString:@"\"" options:0 
                                      range:NSMakeRange(iTunesLinkLocation.location, htmlString.length - iTunesLinkLocation.location)];
    htmlString = [htmlString substringWithRange:NSMakeRange(iTunesLinkLocation.location, end.location - iTunesLinkLocation.location)];
    
    // TODO: Get ID from HTML and download data
    NSLog(@"htmlString: %@", htmlString);
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

-(NSString*)itemId {
    return [[[storeData objectForKey:kResults] objectAtIndex:0] objectForKey:kItemId];
}

@end
