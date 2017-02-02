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

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onLogin:(id)sender {
    [[NavigationManager shared] logIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
