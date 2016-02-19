//
//  ViewController.m
//  BXTableViewTest
//
//  Created by bx_1512 on 16/1/21.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "CustomCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *bxArray = [[NSMutableArray alloc]initWithArray:@[@"xbx", @"xbx", @"xbx", @"xbx", @"xbx", @"xbx", @"xbx", @"xbx", @"xbx", @"xbx"]];
    NSMutableArray *ccArray = [[NSMutableArray alloc]initWithArray:@[@"cc", @"cc", @"cc", @"cc", @"cc", @"cc", @"cc", @"cc", @"cc"]];
    _dataArray = @[bxArray, ccArray];
    // Do any additional setup after loading the view, typically from a nib.
    // 个性化 table title
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    tableTitle.textColor = [UIColor blueColor];
    tableTitle.backgroundColor = self.myTableView.backgroundColor;
    tableTitle.font = [UIFont boldSystemFontOfSize:18];
    tableTitle.text = @"LOVE";
    // 设置 tableview 的 headerView
    self.myTableView.tableHeaderView = tableTitle;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    NSMutableArray *aArray = self.dataArray[section];
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
    NSMutableArray *nameArray = self.dataArray[indexPath.section];
    
    if (indexPath.section == 0) {
        static NSString *MyIdentifier = @"MyReuseIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
        }
        cell.textLabel.text = nameArray[indexPath.row];
        if (indexPath.row == self.selectedRow && indexPath.section == self.selectedSection) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    } else {
        static NSString *CellIdentifier = @"MyCustomCellReuseIdentifier";
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.customLabel.text = nameArray[indexPath.row];
        return cell;
    }
}

#pragma mark - ----tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ((NSArray*)self.dataArray[indexPath.section]).count - 1) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 操作 datasource 的更改
        [((NSMutableArray*)self.dataArray[indexPath.section]) removeObjectAtIndex:indexPath.row];
        // 删除选择的单元格
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:1];
        cell.backgroundColor = altCellColor;
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - ----showDetails segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        DetailViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        NSArray *nameArray = self.dataArray[indexPath.section];
        detailViewController.nameData = nameArray[indexPath.row];
    }
}

#pragma mark - ----edit mode action
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.myTableView setEditing:editing animated:YES];
}

@end
