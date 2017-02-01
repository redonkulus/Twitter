//
//  Tweet.m
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        self.author = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        
        if (dictionary[@"retweeted_status"] != nil) {
            self.retweeted = [[Tweet alloc] initWithDictionary:dictionary[@"retweeted_status"]];
        }
        
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
        
        // format date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        NSDate *date  = [formatter dateFromString:dictionary[@"created_at"]];
        // [formatter setDateFormat:@"MMMM d, yyyy"];
        self.createdAt = date;
    }
    
    return self;
}

- (NSString *)getRelativeTimestamp {
    NSString *relativeDate;
    NSTimeInterval secondsSinceTweet = -[self.createdAt timeIntervalSinceNow];
    if (secondsSinceTweet < 60) {
        // seconds
        relativeDate = [NSString stringWithFormat:@"%.0fs", secondsSinceTweet];
    } else if (secondsSinceTweet < 3600) {
        // minutes
        relativeDate = [NSString stringWithFormat:@"%.0fm", secondsSinceTweet / 60];
    } else if (secondsSinceTweet < 86400) {
        relativeDate = [NSString stringWithFormat:@"%.0fh", secondsSinceTweet / 3600];
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"M/d/yy"];
        relativeDate = [dateFormat stringFromDate:self.createdAt];
    }
    return relativeDate;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array
{
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

@end
