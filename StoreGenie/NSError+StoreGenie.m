//
//  NSError+StoreGenie.m
//  StoreGenie
//
//  Created by Boris Bügling on 10.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import "NSError+StoreGenie.h"

@implementation NSError (StoreGenie)

+(NSError*)errorWithCode:(int)code description:(NSString*)description {
    return [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:code 
                    userInfo:[NSDictionary dictionaryWithObject:description 
                                                         forKey:NSLocalizedDescriptionKey]];
}

@end
