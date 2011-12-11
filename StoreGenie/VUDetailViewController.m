//
//  VUDetailViewController.m
//  StoreGenie
//
//  Created by Boris Bügling on 08.12.11.
//  Copyright (c) 2011 Crocodil.us. All rights reserved.
//

#import <Twitter/Twitter.h>

#import "VUDetailViewController.h"

enum {
    kOpenInAppStore         = 0,
    kShareWithShareables    = 1,
    kTweetLink              = 2,
    kCancel                 = 3,
};

@interface VUDetailViewController ()

- (void)configureView;

@end

#pragma mark -

@implementation VUDetailViewController

@synthesize detailDescriptionLabel;
@synthesize detailItem;

#pragma mark - Actions

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case kCancel:
            return;
        case kOpenInAppStore:
            [[UIApplication sharedApplication] openURL:self.detailItem.viewURL];
            return;
        case kShareWithShareables:
            [[UIApplication sharedApplication] openURL:[NSURL 
                                                        URLWithString:[NSString stringWithFormat:@"x-shareables://shrink?url=%@&title=%@", 
                                                                       [[self.detailItem.viewURL absoluteString] 
                                                                        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], 
                                                                       [self.detailItem.title 
                                                                        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
            return;
        case kTweetLink: {
            TWTweetComposeViewController* tweetSheet = [[TWTweetComposeViewController alloc] init];
            [tweetSheet addURL:self.detailItem.viewURL];
            [tweetSheet setInitialText:[NSString stringWithFormat:@"I am using %@.", self.detailItem.title]];
            [self presentModalViewController:tweetSheet animated:YES];
            return;
        }
    }
    
    [NSException raise:@"Unhandled button" format:@"Button with index %d not yet handled.", buttonIndex];
}

- (void)actionTapped:(UIBarButtonItem*)button {
    // TODO: Open in AppShopper action
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:self.detailItem.title delegate:self cancelButtonTitle:@"Cancel" 
                                               destructiveButtonTitle:nil otherButtonTitles:@"Open in App Store", 
                                  @"Share with Shareables", @"Tweet Link", nil];
    [actionSheet showFromBarButtonItem:button animated:YES];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (detailItem != newDetailItem) {
        detailItem = newDetailItem;
        [self configureView];
    }
}

- (void)configureView {
    // TODO: Implement detail view
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        self.navigationItem.title = [self.detailItem title];
    }
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
