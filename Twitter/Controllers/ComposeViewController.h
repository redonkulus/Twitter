//
//  ComposeViewController.h
//  Twitter
//
//  Created by Seth Bertalotto on 2/3/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tweet.h"
#import "User.h"

@protocol ComposeViewControllerDelegate <NSObject>

- (void)didTweet:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, weak) id <ComposeViewControllerDelegate> delegate;

@end
