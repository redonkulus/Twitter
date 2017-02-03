//
//  User.m
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        self.name = dictionary[@"name"];
        self.screenname = [@"@" stringByAppendingString:dictionary[@"screen_name"]];
        self.tagline = dictionary[@"description"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.profileBackgroundUrl = dictionary[@"profile_banner_url"];
        self.profileBackgroundColor = dictionary[@"profile_background_color"];
        self.following = [dictionary[@"friends_count"] integerValue];
        self.followers = [dictionary[@"followers_count"] integerValue];
    }
    
    return self;
}

@end
