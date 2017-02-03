//
//  ProfileViewController.h
//  Twitter
//
//  Created by Seth Bertalotto on 2/1/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) User *user;
+ (UIColor *)colorWithHex:(UInt32)col;

@end
