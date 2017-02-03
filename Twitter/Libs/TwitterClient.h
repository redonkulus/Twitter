//
//  TwitterClient.h
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "User.h"

typedef void (^TweetListCallback)(NSArray * tweets, NSError * error);

@interface TwitterClient : BDBOAuth1SessionManager

@property (nonatomic, strong) User *user;

+ (TwitterClient * _Nonnull)sharedInstance;

- (void) loginWithCompletion:(void (^)(User * user, NSError * error))completion;
- (void) openURL:(NSURL * _Nonnull)url;
- (void) fetchHomeTimeline:(_Nonnull TweetListCallback)callback;
- (void) fetchProfileTimeline:(nullable User *)user callback:(_Nonnull TweetListCallback)callback;

@end
