//
//  NavigationManager.h
//  Twitter
//
//  Created by Seth Bertalotto on 2/1/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Tweet.h"
#import "User.h"

@interface NavigationManager : NSObject

+ (instancetype)shared;

- (UIViewController *)rootViewController;

- (void)logIn;
- (void)logOut;
- (void)showProfile:(nullable User *)user;
- (void)showTweet:(nullable Tweet *)tweet;

@end
