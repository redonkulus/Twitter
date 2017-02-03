//
//  LoginViewController.m
//  Twitter
//
//  Created by Seth Bertalotto on 1/30/17.
//  Copyright © 2017 Seth Bertalotto. All rights reserved.
//

#import "LoginViewController.h"
#import "NavigationManager.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.layer.cornerRadius = 5.0;
    self.loginButton.layer.masksToBounds = YES;
}

- (IBAction)onLogin:(id)sender {
    [[NavigationManager shared] logIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
