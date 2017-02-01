//
//  LoginViewController.m
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetListViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIViewController *tweetListViewController;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create the view
    TweetListViewController *viewController = [[TweetListViewController alloc] init];
    self.tweetListViewController = viewController;
}

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // present tweets view
            NSLog(@"welcome to %@", user.name);
        } else {
            // present error view
            NSLog(@"no user info");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
