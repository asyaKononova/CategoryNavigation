//
//  CategoryViewController.m
//  CategoryNavigation
//
//  Created by Anastasia Kononova on 9/13/15.
//  Copyright (c) 2015 Asya Kononova. All rights reserved.
//

#import "CategoryViewController.h"
#import "InstrumentCategory.h"
#import "UIViewController+StackNavigationController.h"

@implementation CategoryViewController {
    NSArray *_categories;
}

- (id)initWithCaregories:(NSArray *)categories
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _categories = categories;
    }
    return self;
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (parent != nil) {
        NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
        if (selectedPath != nil) {
            [self.tableView deselectRowAtIndexPath:selectedPath animated:YES];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    cell.textLabel.text = ((InstrumentCategory *)[_categories objectAtIndex:indexPath.row]).name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subcategories = ((InstrumentCategory *)[_categories objectAtIndex:indexPath.row]).subcategories;
    
    if (subcategories.count == 0) return;
    
    CategoryViewController *controller = [[CategoryViewController alloc] initWithCaregories:subcategories];
    
    if (self.stackNavigationController.viewControllers.count == 1 || [self.stackNavigationController.topViewController isEqual:self]) {
        [self.stackNavigationController pushViewController:controller animated:YES];
    } else {
        [self.stackNavigationController pushViewController:controller dismissControllersBeyond:self animated:YES];
    }
}

@end
