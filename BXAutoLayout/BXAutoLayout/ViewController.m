//
//  ViewController.m
//  BXAutoLayout
//
//  Created by bx_1512 on 16/1/27.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "ViewController.h"
#import "BXXibViewController.h"
#import "BXStackViewController.h"
#import "BXCodeViewController.h"
#import "BXSizeClassesViewController.h"

#define UITableViewCellIdentifier   @"UITableViewCellIdentifier"

typedef NS_ENUM(NSInteger, BXViewControllerType) {
    BXViewControllerTypeNib,
    BXViewControllerTypeStackView,
    BXViewControllerTypeCode,
    BXViewControllerTypeSizeClasses,
} ;

typedef void (^CellClickActions)(void);

@interface ViewController ()

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) NSArray *actionList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initBaseData];
    [self initBaseView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBaseData {
    self.dataList = @[
                      @{@(BXViewControllerTypeNib):@"Xib 文件使用 Autolayout"},
                      @{@(BXViewControllerTypeStackView):@"StackView 例子"},
                      @{@(BXViewControllerTypeCode):@"纯代码使用 Autolayout"},
                      @{@(BXViewControllerTypeSizeClasses):@"Size Classes 例子"},
                      ];
    
    self.actionList = @[
                        @{@(BXViewControllerTypeNib):^{[self.navigationController pushViewController:[[BXXibViewController alloc] init] animated:YES];}},
                        @{@(BXViewControllerTypeStackView):^{[self.navigationController pushViewController:[[BXStackViewController alloc] init] animated:YES];}},
                        @{@(BXViewControllerTypeCode):^{[self.navigationController pushViewController:[[BXCodeViewController alloc] init] animated:YES];}},
                        @{@(BXViewControllerTypeSizeClasses):^{[self.navigationController pushViewController:[[BXSizeClassesViewController alloc] init] animated:YES];}},
                        ];
    
}

-(void)initBaseView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:UITableViewCellIdentifier];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIdentifier forIndexPath:indexPath];
    NSDictionary *dataDic = [self.dataList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dataDic objectForKey:[[dataDic allKeys] objectAtIndex:0]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.actionList count] > indexPath.row) {
        NSDictionary *dic = [self.actionList objectAtIndex:indexPath.row];
        CellClickActions action = [dic objectForKey:@(indexPath.row)];
        if (action) {
            action();
        }
    }
}

@end
