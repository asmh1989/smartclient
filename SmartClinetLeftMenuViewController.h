//
//  SmartClinetLeftMenuViewController.h
//  SmartClient
//
//  Created by sun on 13-10-31.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartClinetViewController.h"

@interface SmartClinetLeftMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SmartClinetViewController *centerController;

-(id) initWithCenterController:(SmartClinetViewController *)controller;
@end
