//
//  NSError+StoreGenie.h
//  StoreGenie
//
//  Created by Boris Bügling on 10.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int kSGResultCount           = 100;
static const int kSGNoPasteboardData      = 200;

@interface NSError (StoreGenie)

+(NSError*)errorWithCode:(int)code description:(NSString*)description;

@end
