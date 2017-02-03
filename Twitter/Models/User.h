//
//  User.h
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *profileBackgroundUrl;
@property (nonatomic, strong) NSString *profileBackgroundColor;
@property (nonatomic) NSUInteger following;
@property (nonatomic) NSUInteger followers;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
