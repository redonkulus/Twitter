//
//  TweetListViewController.h
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

typedef enum {
    TweetsViewTypeHome,
    TweetsViewTypeMentions,
    TweetsViewTypeProfile
} TweetsViewType;

@interface TweetListViewController : UIViewController

@property (nonatomic) TweetsViewType tweetsViewType;
@property (nonatomic, strong) User *user;

@end
