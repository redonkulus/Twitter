//
//  TweetTableViewCell.m
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>

#import "TweetTableViewCell.h"

@interface TweetTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetContainerHeightConstant;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweenButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;

@end

@implementation TweetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // add rounded corners to profile image
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
}

- (void)reloadData
{
    // store model in var to avoid re-setting of model
    Tweet *model = self.model;
    
    // handle retweet use case
    if (self.model.retweeted != nil) {
        self.retweetContainerHeightConstant.constant = 24;
        self.retweetedLabel.text = [model.author.name stringByAppendingString:@" Retweeted"];
        model = self.model.retweeted;
    } else {
        self.retweetContainerHeightConstant.constant = 0;
    }
    [self setNeedsUpdateConstraints];
    
    self.nameLabel.text = model.author.name;
    self.handleLabel.text = model.author.screenname;
    self.timestampLabel.text = [self.model getRelativeTimestamp];
    self.contentLabel.text = model.text;
    
    [self showProfileImage:model];
}

- (void)showProfileImage:(Tweet *)model
{
    // Establish the weak self reference
    __weak typeof(self) weakSelf = self;
    
    // load profile image and fade to view
    NSURL *profileImage = [NSURL URLWithString:model.author.profileImageUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:profileImage];
    [self.imageView setImageWithURLRequest:request placeholderImage:nil
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

- (void)setModel:(Tweet *)model
{
    _model = model;
    [self reloadData];
}

@end
