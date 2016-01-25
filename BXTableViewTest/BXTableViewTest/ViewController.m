//
//  ViewController.m
//  BXTableViewTest
//
//  Created by bx_1512 on 16/1/21.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *bxArray = @[@"xbx", @"xbx"];
    NSArray *ccArray = @[@"cc", @"cc"];
    _dataArray = @[bxArray, ccArray];
    // Do any additional setup after loading the view, typically from a nib.
    // 个性化 table title
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    tableTitle.textColor = [UIColor blueColor];
    tableTitle.backgroundColor = self.myTableView.backgroundColor;
    tableTitle.font = [UIFont boldSystemFontOfSize:18];
    tableTitle.text = @"LOVE";
    self.myTableView.tableHeaderView = tableTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ----tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    NSArray *aArray = self.dataArray[section];
    return [aArray count];
}

- (NSArray <NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return @[@"x",@"c"];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"x";
    }
    if (section == 1) {
        return @"c";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    NSArray *nameArray = self.dataArray[indexPath.section];
    cell.textLabel.text = nameArray[indexPath.row];
    if (indexPath.row == self.selectedRow && indexPath.section == self.selectedSection) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - ----tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    self.selectedSection = indexPath.section;
    [self.myTableView reloadData];
}

// cell 内的缩进
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0;
    }
    return 2;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        DetailViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        NSArray *nameArray = self.dataArray[indexPath.section];
        detailViewController.nameData = nameArray[indexPath.row];
    }
}
@end
