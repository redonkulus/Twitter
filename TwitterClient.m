//
//  TwitterClient.m
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTwitterConsumerKey = @"E9IemXo95JImu3JKFAuz7E78D";
NSString * const kTwitterConsumerSecret = @"mxyQa9VQqkarxQljxxnsqpLENAQ6KqY9eRdi9EfF0aR1hj7P86";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance
{
    static TwitterClient *instance = nil;
    
    // make it threadsafe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl]
                                               consumerKey:kTwitterConsumerKey
                                               consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void) loginWithCompletion:(void (^)(User *user, NSError *error))completion
{
    // save for later
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"got the request token");
        
        NSURL *authURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        [[UIApplication sharedApplication] openURL:authURL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"auth complete");
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"failed to get request token");
        self.loginCompletion(nil, error);
    }];
    
}

- (void) openURL:(NSURL *)url
{
    // fetch access token after user authorizes
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        // NSLog(@"access token = %@", accessToken);
        
        // save access token for later use
        [self.requestSerializer saveAccessToken:accessToken];
        
        // get current user data
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // NSLog(@"current user %@", responseObject);
            
            User *user = [[User alloc] initWithDictionary:responseObject];
            NSLog(@"current user %@", user.name);
            
            self.loginCompletion(user, nil);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failed to receive user %@", error);
            self.loginCompletion(nil, error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"no access token received %@", error);
    }];
}

//        [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            // NSLog(@"current user %@", responseObject);
//
//            //
//            NSArray *tweets = [Tweet tweetsWithArray:responseObject];
//            for (Tweet *tweet in tweets) {
//                NSLog(@"tweet: %@, created: %@", tweet.text, tweet.createdAt);
//            }
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"failed to receive user %@", error);
//        }];

@end
