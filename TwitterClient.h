//
//  TwitterClient.h
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "User.h"

@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient *)sharedInstance;

- (void) loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void) openURL:(NSURL *)url;

@end
