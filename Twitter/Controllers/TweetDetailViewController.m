//
//  TweetDetailViewController.m
//  Twitter
//
//  Created by Seth Bertalotto on 2/1/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>

#import "NavigationManager.h"
#import "Tweet.h"
#import "TweetDetailViewController.h"
#import "Util.h"

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // add tap gesture recognizer to go to profile page
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTap:)];
    [self.profileImageView addGestureRecognizer:tap];
    [self.profileImageView setUserInteractionEnabled:YES];
    
    // add rounded corners to profile image
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
    
    // store model in var to avoid re-setting of model
    Tweet *tweet = self.tweet;
    Util *util = [[Util alloc] init];
    
    // handle retweet use case
    if (self.tweet.retweeted != nil) {
        self.retweetedLabel.text = [tweet.author.name stringByAppendingString:@" Retweeted"];
        tweet = self.tweet.retweeted;
    } else {
        self.topContainer.hidden = YES;
    }
    
    self.nameLabel.text = tweet.author.name;
    self.handleLabel.text = tweet.author.screenname;
    self.contentLabel.text = tweet.text;
    
    // timestamp
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M/d/yyyy, h:MM a";
    self.timestampLabel.text = [formatter stringFromDate:tweet.createdAt];
    
    // set buttons
    self.retweetLabel.text = [util getFormattedCount:tweet.retweetCount];
    self.favoriteLabel.text = [util getFormattedCount:tweet.favoriteCount];
    
    [self showProfileImage:tweet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showProfileImage:(Tweet *)tweet
{
    // Establish the weak self reference
    __weak typeof(self) weakSelf = self;
    
    // load profile image and fade to view
    NSURL *profileImage = [NSURL URLWithString:tweet.author.profileImageUrl];
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

- (IBAction)onImageTap:(UITapGestureRecognizer *)sender {
    [[NavigationManager shared] showProfile:self.tweet.author];
}

@end
