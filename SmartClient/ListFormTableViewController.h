//
//  ListFormTableViewController.h
//  SmartClient
//
//  Created by sun on 14-4-25.
//  Copyright (c) 2014年 searching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListFormArgs.h"
#import "SmartClinetViewController.h"

@interface ListFormTableViewController : UITableViewController

-(id) initWithData:(ListFormArgs *)args parent:(SmartClinetViewController*)controller;

@end
