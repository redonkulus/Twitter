//
//  NavigationManager.h
//  Twitter
//
//  Created by Seth Bertalotto on 2/1/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavigationManager : NSObject

+ (instancetype)shared;

- (UIViewController *)rootViewController;

- (void)logIn;
- (void)logOut;

@end
