//
//  ProfileViewController.m
//  Twitter
//
//  Created by Seth Bertalotto on 2/1/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "TweetTableViewCell.h"
#import "Tweet.h"
#import "User.h"
#import "Util.h"

@interface ProfileViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *nib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TweetTableViewCell"];
    
    // add rounded corners to profile image
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
    
    [self loadTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell" forIndexPath:indexPath];
    
    Tweet *model = [self.tweets objectAtIndex:indexPath.item];
    
    cell.model = model;
    
    return cell;
}

- (void) loadTweets
{
    [[TwitterClient sharedInstance] fetchProfileTimeline:self.user callback:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        if (self.user == nil) {
            Tweet *tweet = tweets[0];
            self.user = tweet.author;
        }
        [self updateProfile];
        [self.tableView reloadData];
    }];
}

- (void) updateProfile
{
    NSLog(@"user %@", self.user);
    
    Util *util = [[Util alloc] init];
    
    [self showBackgroundImage];
    [self showProfileImage];
    
    self.nameLabel.text = self.user.name;
    self.handleLabel.text = self.user.screenname;
    self.descriptionLabel.text = self.user.tagline;
    self.followingCount.text = [util getFormattedCount:self.user.following];
    self.followersCount.text = [util getFormattedCount:self.user.followers];
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
        self.backgroundImageView.image = [UIImage imageWithData:imageData];
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
        
        self.backgroundImageView.backgroundColor = color;
    }
}


@end
