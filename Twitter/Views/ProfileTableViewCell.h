//
//  ProfileTableViewCell.h
//  Twitter
//
//  Created by Seth Bertalotto on 2/2/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileTableViewCell : UITableViewCell

@property (strong, nonatomic) User *user;

@end
