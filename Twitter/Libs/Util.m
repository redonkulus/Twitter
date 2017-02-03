//
//  Util.m
//  Twitter
//
//  Created by Seth Bertalotto on 2/2/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import "Util.h"

@implementation Util

- (NSString *)getFormattedCount:(NSInteger)count {
    NSString *str;
    if (count >= 1000000) {
        str = [NSString stringWithFormat:@"%0.2fM", count / 1000000.0];
    } else if (count >= 1000) {
        str = [NSString stringWithFormat:@"%ldK", lroundf(count / 1000.0)];
    } else {
        str = [NSString stringWithFormat:@"%ld", count];
    }
    return str;
}

@end
