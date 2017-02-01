//
//  TweetTableViewCell.m
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>

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

    // Configure the view for the selected state
}

- (void)reloadData
{
    NSLog(@"reload data");
    
    self.nameLabel.text = self.model.author.name;
    self.handleLabel.text = self.model.author.screenname;
    self.timestampLabel.text = [self.model getRelativeTimestamp];
    self.contentLabel.text = self.model.text;
    
    // check container height
    self.retweetContainerHeightConstant.constant = self.model.retweeted ? 24 : 0;
    [self setNeedsUpdateConstraints];
    
    [self showProfileImage];

    [self setNeedsLayout];
}

- (void)showProfileImage
{
    // Establish the weak self reference
    __weak typeof(self) weakSelf = self;
    
    // load profile image and fade to view
    NSURL *profileImage = [NSURL URLWithString:self.model.author.profileImageUrl];
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
    NSLog(@"view cell - set model");
    _model = model;
    [self reloadData];
}

@end
