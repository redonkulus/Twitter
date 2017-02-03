//
//  TweetListViewController.m
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import "ComposeViewController.h"
#import "NavigationManager.h"
#import "ProfileTableViewCell.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetListViewController.h"
#import "TweetTableViewCell.h"

@interface TweetListViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;

@end

@implementation TweetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.tweetsViewType == TweetsViewTypeHome) {
        // add twitter image to nav
        UIImage *image = [UIImage imageNamed:@"Twitter_Logo_Blue.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 40, 40);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.navigationItem.titleView = imageView;
        
        // add logout button
        UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Logout"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(logOut:)];
        self.navigationItem.leftBarButtonItem = logOutButton;
        
        // add compose button
        UIImage *editImage = [UIImage imageNamed:@"edit-icon.png"];
        UIBarButtonItem *composeButton = [[UIBarButtonItem alloc]
                                         initWithImage:editImage
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:@selector(compose:)];
        self.navigationItem.rightBarButtonItem = composeButton;
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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

- (IBAction)compose:(id)sender
{
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.user = [TwitterClient sharedInstance].user;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion: nil];
}

- (IBAction)logOut:(id)sender
{
    [[NavigationManager shared] logOut];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tweetsViewType == TweetsViewTypeProfile) {
        return self.tweets.count + 1;
    } else {
        return self.tweets.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tweetIndex = indexPath.row;
    if (self.tweetsViewType == TweetsViewTypeProfile && tweetIndex > 0) {
        tweetIndex--;
    }
    
    if (self.tweetsViewType == TweetsViewTypeProfile && indexPath.row == 0) {
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

- (void)reloadView
{
    if (self.user == nil) {
        Tweet *tweet = self.tweets[0];
        self.user = tweet.author;
    }
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)loadTweets
{
    switch (self.tweetsViewType) {
        case TweetsViewTypeHome: {
            [[TwitterClient sharedInstance] fetchHomeTimeline:^(NSArray *tweets, NSError *error) {
                self.tweets = tweets;
                [self reloadView];
            }];
            break;
        }
        case TweetsViewTypeMentions: {
            [[TwitterClient sharedInstance] fetchMentionsTimeline:^(NSArray *tweets, NSError *error) {
                self.tweets = tweets;
                [self reloadView];
            }];
            break;
        }
        case TweetsViewTypeProfile: {
            [[TwitterClient sharedInstance] fetchProfileTimeline:self.user callback:^(NSArray *tweets, NSError *error) {
                self.tweets = tweets;
                [self reloadView];
            }];
            break;
        }
        default:
            break;
    }
}

- (void)didTweet:(Tweet *)tweet {
    if (self.tweetsViewType == TweetsViewTypeHome || (self.user && [self.user.screenname isEqualToString:tweet.author.screenname])) {
        NSArray* tweets = [[NSArray alloc] initWithObjects:tweet, nil];
        self.tweets = [tweets arrayByAddingObjectsFromArray:self.tweets];
        [self.tableView reloadData];
    }
}

@end
