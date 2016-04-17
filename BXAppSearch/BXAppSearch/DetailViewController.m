//
//  DetailViewController.m
//  BXAppSearch
//
//  Created by bx_1512 on 16/4/15.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "DetailViewController.h"
#import "BXASDataManager.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = [self.personDetails objectForKey:BXASDataManagerKey];
}

@end
