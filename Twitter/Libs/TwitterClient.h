//
//  TwitterClient.h
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "User.h"
#import "Tweet.h"

typedef void (^TweetCallback)(Tweet * tweet, NSError * error);
typedef void (^TweetListCallback)(NSArray * tweets, NSError * error);

@interface TwitterClient : BDBOAuth1SessionManager

@property (nonatomic, strong) User *user;

+ (TwitterClient * _Nonnull)sharedInstance;

- (void)loginWithCompletion:(void (^)(User * user, NSError * error))completion;
- (void)logout;
- (void)openURL:(NSURL * _Nonnull)url;
- (void)fetchHomeTimeline:(_Nonnull TweetListCallback)callback;
- (void)fetchMentionsTimeline:(_Nonnull TweetListCallback)callback;
- (void)fetchProfileTimeline:(nullable User *)user callback:(_Nonnull TweetListCallback)callback;
- (void)createTweet:(Tweet * _Nonnull)tweet callback:(TweetCallback)callback;

@end
