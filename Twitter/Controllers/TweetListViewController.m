//
//  TweetListViewController.m
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import "TwitterClient.h"
#import "TweetListViewController.h"
#import "TweetTableViewCell.h"
#import "ProfileTableViewCell.h"
#import "Tweet.h"

@interface TweetListViewController () <UITableViewDataSource>

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;

@end

@implementation TweetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.tweetsViewType == TweetsViewTypeHome) {
        UIImage *image = [UIImage imageNamed:@"Twitter_Logo_Blue.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 40, 40);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.navigationItem.titleView = imageView;
    }
    
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *nib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TweetTableViewCell"];
    
    UINib *pnib = [UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil];
    [self.tableView registerNib:pnib forCellReuseIdentifier:@"ProfileTableViewCell"];
    
    // setup pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    
    [self loadTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.user) {
        return self.tweets.count + 1;
    } else {
        return self.tweets.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tweetIndex = indexPath.row;
    if (self.user && tweetIndex > 0) {
        tweetIndex--;
    }
    
    if (self.user && indexPath.row == 0) {
        ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell"];
        cell.user = self.user;
        return cell;
    } else {
        TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
        Tweet *model = [self.tweets objectAtIndex:tweetIndex];
        cell.model = model;
        return cell;
    }
}

- (void) loadTweets
{
    switch (self.tweetsViewType) {
        case TweetsViewTypeHome: {
            [[TwitterClient sharedInstance] fetchHomeTimeline:^(NSArray *tweets, NSError *error) {
                self.tweets = tweets;
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
            }];
            break;
        }
        case TweetsViewTypeMentions: {
            [[TwitterClient sharedInstance] fetchMentionsTimeline:^(NSArray *tweets, NSError *error) {
                self.tweets = tweets;
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
            }];
            break;
        }
        case TweetsViewTypeProfile: {
            [[TwitterClient sharedInstance] fetchProfileTimeline:self.user callback:^(NSArray *tweets, NSError *error) {
                self.tweets = tweets;
                if (self.user == nil) {
                    Tweet *tweet = tweets[0];
                    self.user = tweet.author;
                }
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
            }];
            break;
        }
        default:
            break;
    }
}

@end
