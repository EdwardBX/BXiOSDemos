//
//  DetailViewController.h
//  BXAppSearch
//
//  Created by bx_1512 on 16/4/15.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property( nonatomic, strong) NSDictionary<NSString *, NSString *> *personDetails;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
