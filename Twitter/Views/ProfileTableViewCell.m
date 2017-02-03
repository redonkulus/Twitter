//
//  ProfileTableViewCell.m
//  Twitter
//
//  Created by Seth Bertalotto on 2/2/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>

#import "ProfileTableViewCell.h"
#import "User.h"
#import "Util.h"

@interface ProfileTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@end

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // add rounded corners to profile image
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData
{
    // store model in var to avoid re-setting of model
    Util *util = [[Util alloc] init];
    
    self.nameLabel.text = self.user.name;
    self.screennameLabel.text = self.user.screenname;
    self.taglineLabel.text = self.user.tagline;
    self.followingCountLabel.text = [util getFormattedCount:self.user.following];
    self.followersCountLabel.text = [util getFormattedCount:self.user.followers];
    
    [self showProfileImage];
    [self showBackgroundImage];
}

- (void)showProfileImage
{
    // Establish the weak self reference
    __weak typeof(self) weakSelf = self;
    
    // load profile image and fade to view
    NSURL *profileImage = [NSURL URLWithString:self.user.profileImageUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:profileImage];
    [self.profileImageView setImageWithURLRequest:request placeholderImage:nil
          success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
              weakSelf.profileImageView.contentMode = UIViewContentModeScaleAspectFit;
              
              weakSelf.profileImageView.alpha = 0.0;
              weakSelf.profileImageView.image = image;
              [UIView animateWithDuration:0.3 animations:^{
                  weakSelf.profileImageView.alpha = 1.0;
              }];
          }
          failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
              NSLog(@"Image fetch error %@", response);
          }
     ];
}

- (void)showBackgroundImage
{
    if (self.user.profileBackgroundUrl != nil) {
        NSURL *backgroundImage = [NSURL URLWithString:self.user.profileBackgroundUrl];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:backgroundImage];
        self.profileBackgroundImageView.image = [UIImage imageWithData:imageData];
    } else if (self.user.profileBackgroundColor != nil) {
        // get color from hex
        const char *cStr = [self.user.profileBackgroundColor cStringUsingEncoding:NSASCIIStringEncoding];
        long x = strtol(cStr+1, NULL, 16);
        
        // create from RGB
        unsigned char r, g, b;
        b = x & 0xFF;
        g = (x >> 8) & 0xFF;
        r = (x >> 16) & 0xFF;
        UIColor *color = [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
        
        self.profileBackgroundImageView.backgroundColor = color;
    }
}


- (void)setUser:(User *)user
{
    _user = user;
    [self reloadData];
}

@end
