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
#import "ProfileViewController.h"

@interface NavigationManager()

@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation NavigationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLoggedIn = NO;
        
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

+ (UINavigationController *)createTabVC:(Class)className :(NSString *)icon :(NSString *)label
{
    NSString *myClass = NSStringFromClass(className);

    // Create root VC for the tab's navigation controller
    UIViewController *vc = [[className alloc] initWithNibName:myClass bundle:nil];
    vc.title = label;
    
    // create tab item
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:label image:[UIImage imageNamed:icon] tag:0];
    vc.tabBarItem = item;
    
    // create navigation controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    return navController;
}

- (UIViewController *)loggedInVC
{
    UINavigationController *homeNavController = [self.class createTabVC:TweetListViewController.class :@"home-icon.png" :@"Home"];
    UINavigationController *profileNavController = [self.class createTabVC:ProfileViewController.class :@"profile-icon.png" :@"Profile"];
    
    // create tab bar view controller
    UITabBarController *tabController = [[UITabBarController alloc] init];
    
    // Add navigation controller to tab bar controller
    tabController.viewControllers = @[homeNavController, profileNavController];
    
    return tabController;
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
    
}

@end
