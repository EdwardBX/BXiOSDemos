//
//  ViewController.m
//  BXAppSearch
//
//  Created by bx_1512 on 16/4/15.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "ViewController.h"
#import "BXASDataManager.h"
#import "DetailViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated {
    [self initActivity];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)restoreUserActivityStateWithPersonIndex:(NSUInteger)index {
    NSArray *people = [BXASDataManager sharedInstance].people;
    
    if (index >= people.count) {
        return;
    }
    
    NSDictionary *person = people[index];
    DetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    controller.personDetails = person;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)initActivity{
    NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:@"xbx.BXAppSearch.appcontent"];
    activity.eligibleForSearch = YES;
    activity.needsSave = YES;
    self.userActivity = activity;
    [self.userActivity becomeCurrent];
}

- (void)updateUserActivityState:(NSUserActivity *)activity {
    activity.title = @"第一个搜索条目";
    activity.userInfo = @{@"id": @"123"};
    [super updateUserActivityState:activity];
}

- (void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender {
    NSString *identifier = segue.identifier;
    NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
    
    if ([identifier isEqualToString:@"resultsSegue"]) {
        NSDictionary *person = [BXASDataManager sharedInstance].people[indexPath.row];
        
        DetailViewController *page = (DetailViewController *)segue.destinationViewController;
        page.personDetails = person;
    }
}

#pragma mark - ----UITableView delegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [BXASDataManager sharedInstance].people.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *person = [BXASDataManager sharedInstance].people[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    cell.textLabel.text =  person[BXASDataManagerKey];
    cell.detailTextLabel.text =  person[BXASDataManagerValue];
    
    return cell;
}

@end
