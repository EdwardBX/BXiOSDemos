//
//  DetailViewController.m
//  BXTableViewTest
//
//  Created by bx_1512 on 16/1/24.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    self.nameLabel.text = self.nameData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ----delegate
- (void)detailViewControllerDidCancel:(DetailViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)detailViewControllerDidFinish:(DetailViewController *)controller data:(NSString *)item {
    if ([item length]) {
//        [self.dataController addData:item];
//        [[self tableView] reloadData];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
