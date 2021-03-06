//
//  Tweet.h
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *author;

@property (nonatomic, strong) Tweet *retweeted;
@property (nonatomic) NSUInteger retweetCount;
@property (nonatomic) NSUInteger favoriteCount;


- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)getRelativeTimestamp;

+ (NSArray * )tweetsWithArray:(NSArray *)array;

@end
