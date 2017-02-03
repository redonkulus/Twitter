//
//  NavigationManager.m
//  Twitter
//
//  Created by Seth Bertalotto on 2/1/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import "NavigationManager.h"
#import "TwitterClient.h"
#import "LoginViewController.h"
#import "TweetListViewController.h"
#import "User.h"

@interface NavigationManager()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UINavigationController *homeNavController;
@property (nonatomic, strong) UINavigationController *mentionsNavController;
@property (nonatomic, strong) UINavigationController *profileNavController;
@property (nonatomic, strong) UITabBarController *tabController;

@end

@implementation NavigationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIViewController *root = [[TwitterClient sharedInstance] isAuthorized] ? [self loggedInVC] : [self loggedOutVC];
        
        self.navigationController = [[UINavigationController alloc] init];
        self.navigationController.viewControllers = @[root];
        [self.navigationController setNavigationBarHidden:YES];
    }
    return self;
}

- (UIViewController *)rootViewController
{
    return self.navigationController;
}

+(instancetype)shared
{
    static NavigationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NavigationManager alloc] init];
    });
    return sharedInstance;
}

+ (UINavigationController *)createTabVC:(NSString *)icon label:(NSString *)label type:(TweetsViewType)type
{
    // Create root VC for the tab's navigation controller
    TweetListViewController *vc = [[TweetListViewController alloc] initWithNibName:@"TweetListViewController" bundle:nil];
    vc.title = label;
    vc.tweetsViewType = type;
    
    // create tab item
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:label image:[UIImage imageNamed:icon] tag:0];
    vc.tabBarItem = item;
    
    // create navigation controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    return navController;
}

- (UIViewController *)loggedInVC
{
    self.homeNavController = [self.class createTabVC:@"home-icon.png" label:@"Home" type:TweetsViewTypeHome];
    self.mentionsNavController = [self.class createTabVC:@"notification-icon.png" label:@"Mentions" type:TweetsViewTypeMentions];
    self.profileNavController = [self.class createTabVC:@"profile-icon.png" label:@"Me" type:TweetsViewTypeProfile];
    
    // create tab bar view controller
    self.tabController = [[UITabBarController alloc] init];
    
    // Add navigation controller to tab bar controller
    self.tabController.viewControllers = @[self.homeNavController, self.mentionsNavController, self.profileNavController];
    
    return self.tabController;
}

- (UIViewController *)loggedOutVC
{
    LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    return vc;
}

- (void)logIn
{
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // present tweets view
            NSLog(@"welcome to %@", user.name);
            [self.navigationController setViewControllers:@[[self loggedInVC]]];
        } else {
            // present error view
            NSLog(@"no user info");
        }
    }];
}

- (void)logOut
{
    [[TwitterClient sharedInstance] logout];
    UIViewController *vc = [self loggedOutVC];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)showProfile:(nullable User *)user
{
    TweetListViewController *vc = [[TweetListViewController alloc] initWithNibName:@"TweetListViewController" bundle:nil];
    vc.tweetsViewType = TweetsViewTypeProfile;
    if (user != nil) {
        vc.user = user;
    }
    
    UINavigationController *selected = [self.tabController.viewControllers objectAtIndex:self.tabController.selectedIndex];
    
    // hide nav bar
//    [selected.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    selected.navigationBar.shadowImage = [UIImage new];
//    selected.navigationBar.translucent = YES;
//    
//    selected.navigationBar.tintColor = [UIColor whiteColor];
//    selected.navigationBar.topItem.title = @"";
    
    [selected pushViewController:vc animated:YES];
}

@end
