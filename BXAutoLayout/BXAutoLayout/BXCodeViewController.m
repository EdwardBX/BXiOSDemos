//
//  BXCodeViewController.m
//  BXAutoLayout
//
//  Created by bx_1512 on 16/1/29.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "BXCodeViewController.h"

@interface BXCodeViewController ()

@end

@implementation BXCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBaseView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"纯代码使用 Autolayout";
    
    UIView *subRedView = [[UIView alloc] init];
    subRedView.layer.cornerRadius = 5;
    subRedView.layer.masksToBounds = YES;
    subRedView.backgroundColor = [UIColor redColor];
    subRedView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *subBlueView = [UIView new];
    subBlueView.layer.cornerRadius = 5;
    subBlueView.layer.masksToBounds = YES;
    subBlueView.backgroundColor = [UIColor blueColor];
    subBlueView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:subRedView];
    [self.view addSubview:subBlueView];
    
    // Using NSLayoutConstraint..... what a load of crap!
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:subRedView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:subRedView
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:0
                                                                        constant:50];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:subRedView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:subRedView
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0
                                                                         constant:50];
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:subRedView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1
                                                                          constant:0];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:subRedView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0];
    
    [self.view addConstraints:@[widthConstraint, heightConstraint, centerXConstraint, centerYConstraint]];
    
    // Using NSLayoutAnchor
    UILayoutGuide *redviewMargins = subRedView.layoutMarginsGuide;
    [subBlueView.centerXAnchor constraintEqualToAnchor:redviewMargins.centerXAnchor].active = YES;
    [subBlueView.centerYAnchor constraintEqualToAnchor:redviewMargins.centerYAnchor constant:60].active = YES;
    NSLayoutConstraint *hConstraint = [NSLayoutConstraint constraintWithItem:subRedView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:subBlueView
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:1
                                                                          constant:0];
    NSLayoutConstraint *wConstraint = [NSLayoutConstraint constraintWithItem:subRedView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:subBlueView
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1
                                                                    constant:0];
    [self.view addConstraints:@[hConstraint, wConstraint]];
    
    
}

@end
