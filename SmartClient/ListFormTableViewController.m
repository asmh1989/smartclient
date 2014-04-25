//
//  ListFormTableViewController.m
//  SmartClient
//
//  Created by sun on 14-4-25.
//  Copyright (c) 2014年 searching. All rights reserved.
//

#import "ListFormTableViewController.h"

@interface ListFormTableViewController ()
{
    ListFormArgs *datas;
    SmartClinetViewController * parentController;
}

@end

@implementation ListFormTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithData:(ListFormArgs *)args parent:(SmartClinetViewController *)controller
{
    self = [super init];
    if (self) {
        // Custom initialization
        datas = args;
        self.title = args.title;
        parentController = controller;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return datas.sectionTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *row = (NSArray *)[datas.listContents objectForKey:[NSNumber numberWithInt:section]];
    return row.count/2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@", datas.sectionTitle[section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *row = (NSArray *)[datas.listContents objectForKey:[NSNumber numberWithInt:indexPath.section]];
    NSString *listFormResult = [NSString stringWithFormat:@"%@Value=\"%@\" Text=\"%@\" />", CUSACTIVE_LIST_SEND, row[indexPath.row], row[indexPath.row+1]];
    [parentController dispatchMessage:listFormResult tag:1];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSArray *row = (NSArray *)[datas.listContents objectForKey:[NSNumber numberWithInt:indexPath.section]];
    
//    NSLog(@"[%ld, %ld] -- text = %@", (long)indexPath.section, (long)indexPath.row, row[indexPath.row]);
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", row[indexPath.row*2+1]];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

@end
