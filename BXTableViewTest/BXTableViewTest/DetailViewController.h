//
//  DetailViewController.h
//  BXTableViewTest
//
//  Created by bx_1512 on 16/1/24.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailViewController;

@protocol MyAddViewControllerDelegate <NSObject>

- (void)detailViewControllerDidCancel:(DetailViewController *)controller;
- (void)detailViewControllerDidFinish:(DetailViewController *)controller data:(NSString *)item;

@end


@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSString *nameData;

@end
