//
//  TweetTableViewCell.m
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import "TweetTableViewCell.h"

@interface TweetTableViewCell ()

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
    self.nameLabel.text = @"My Twitter Name";
    self.handleLabel.text = @"sbertalyahoosbertalyahoosbertalyahoosbertalyahoosbertalyahoosbertalyahoo";
    self.timestampLabel.text = @"4h";
    self.contentLabel.text = @"My first tweet. My first tweet. My first tweet. My first tweet. My first tweet. My first tweet. My first tweet. My first tweet. My first tweet. My first tweet. My first tweet. My first tweet. My first tweet. ";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
