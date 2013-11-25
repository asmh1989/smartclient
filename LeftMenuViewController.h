//
//  LeftMenuViewController.h
//  SmartClient
//
//  Created by sun on 13-11-25.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartClinetViewController.h"
#import "JMStaticContentTableViewController.h"

@interface LeftMenuViewController : JMStaticContentTableViewController

@property (nonatomic, strong) SmartClinetViewController *centerController;

-(id) initWithCenterController:(SmartClinetViewController *)controller;
@end