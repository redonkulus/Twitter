//
//  ComposeViewController.m
//  Twitter
//
//  Created by Seth Bertalotto on 2/3/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *tweetCount;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // focus the text field
    self.tweetTextView.delegate = self;
    [self.tweetTextView becomeFirstResponder];
    [self.tweetTextView selectAll:self];
    
    // style the tweet button
    self.tweetButton.layer.cornerRadius = 5.0;
    self.tweetButton.layer.masksToBounds = YES;
    
    // update profile image
    NSURL *profileImage = [NSURL URLWithString:self.user.profileImageUrl];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:profileImage];
    self.profileImageView.image = [UIImage imageWithData:imageData];
    
    [self updateTweetCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onCloseTap:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateTweetCount];
}

- (void)updateTweetCount {
    int remaining = 140 - (int)self.tweetTextView.text.length;
    
    self.tweetCount.text = [NSString stringWithFormat:@"%d", remaining];
    
    if (remaining <= 0) {
        self.tweetCount.textColor = [UIColor redColor];
        self.tweetButton.enabled = NO;
    } else {
        self.tweetCount.textColor = [UIColor lightGrayColor];
        self.tweetButton.enabled = YES;
    }
}

- (IBAction)onSubmit:(UIButton *)sender {
    NSString *text = self.tweetTextView.text;
    NSDictionary *dictionary = @{
        @"text": text
    };
    Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];

    // save status
    [[TwitterClient sharedInstance] createTweet:tweet callback:^(Tweet *tweet, NSError *error) {
        if (self.delegate) {
            [self.delegate didTweet:tweet];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
