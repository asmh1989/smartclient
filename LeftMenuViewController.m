//
//  LeftMenuViewController.m
//  SmartClient
//
//  Created by sun on 13-11-25.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ConnectSettingViewController.h"
#import "FontSettingViewController.h"
#import "ScanSettingViewController.h"
#import "ScreenSettingViewController.h"
#import "OtherSettingViewController.h"
#import "AboutSettingViewController.h"
#import "SoundSettingViewController.h"

enum SettingType{
    SETTING_CONNECT = 0,
    SETTING_FONT,
    SETTING_SCREEN,
    SETTING_SOUND,
    SETTING_SCAN,
    SETTING_OTHER,
    SETTING_RECONNECT,
    SETTING_ABOUT
};

@interface LeftMenuViewController ()

- (void)didAction:(enum SettingType)type;
@end

@implementation LeftMenuViewController
@synthesize centerController;

//- (id)init
//{
//    self = [super initWithStyle:UITableViewStyleGrouped];
//    if (self) {
//        
//        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
//                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                     target:self
//                                     action:@selector(save:)];
//        [[self navigationItem] setLeftBarButtonItem:doneItem];
//        
//        self.title = NSLocalizedString(@"ConnectSettings", @"Connect");
//        
//    }
//    return self;
//}

- (id)initWithCenterController:(SmartClinetViewController *)controller
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self setRestorationIdentifier:@"leftSideDrawerViewControllerRestorationKey"];
        self.centerController = controller;
        
        self.title = NSLocalizedString(@"Settings", nil);

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    __unsafe_unretained __block LeftMenuViewController *safeSelf = self;
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"ConnectSettingsCell";
            
			cell.textLabel.text = NSLocalizedString(@"ConnectSettings", @"Connect");
            [cell.imageView setImage:[UIImage imageNamed:@"Connect_Image.png"]];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf didAction:SETTING_CONNECT];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"FontSettingsCell";
            
			cell.textLabel.text = NSLocalizedString(@"FontSettings", nil);
            [cell.imageView setImage:[UIImage imageNamed:@"Font_Image.png"]];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf didAction:SETTING_FONT];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"ScreenCell";
            
			cell.textLabel.text = NSLocalizedString(@"Screen", nil);
            [cell.imageView setImage:[UIImage imageNamed:@"Screen_Image.png"]];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf didAction:SETTING_SCREEN];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"SoundCell";
            
			cell.textLabel.text = NSLocalizedString(@"Sound", nil);
            [cell.imageView setImage:[UIImage imageNamed:@"Sound_Image.png"]];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf didAction:SETTING_SOUND];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"ScanSettingCell";
            
			cell.textLabel.text = NSLocalizedString(@"ScanSetting", nil);
            [cell.imageView setImage:[UIImage imageNamed:@"Scan_Image.png"]];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf didAction:SETTING_SCAN];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"OtherSettingCell";
            
			cell.textLabel.text = NSLocalizedString(@"OtherSetting", nil);
            [cell.imageView setImage:[UIImage imageNamed:@"Other_Image.png"]];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf didAction:SETTING_OTHER];
		}];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
            
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"ReconnectedCell";
            
			cell.textLabel.text = NSLocalizedString(@"Reconnected", nil);
            [cell.imageView setImage:[UIImage imageNamed:@"Reconnect_Image.png"]];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf didAction:SETTING_RECONNECT];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"AboutCell";
            
			cell.textLabel.text = NSLocalizedString(@"About", nil);
            [cell.imageView setImage:[UIImage imageNamed:@"About_Image.png"]];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf didAction:SETTING_ABOUT];
		}];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didAction:(enum SettingType)type
{
    UINavigationController *navController = [[UINavigationController alloc] init];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    if (type == SETTING_RECONNECT) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            [centerController sendExMessage:@"Menu" Reason:@"reconnected"];
        }];
        return;
    } else if(type == SETTING_CONNECT){
        navController = [navController initWithRootViewController:[[ConnectSettingViewController alloc]init]];
    } else if(type == SETTING_FONT){
        navController = [navController initWithRootViewController:[[FontSettingViewController alloc]init]];
    } else if(type == SETTING_SCREEN){
        navController = [navController initWithRootViewController:[[ScreenSettingViewController alloc]init]];
    } else if(type == SETTING_SOUND){
        navController = [navController initWithRootViewController:[[SoundSettingViewController alloc]init]];
    } else if(type == SETTING_SCAN){
        navController = [navController initWithRootViewController:[[ScanSettingViewController alloc]init]];
    } else if(type == SETTING_OTHER){
        navController = [navController initWithRootViewController:[[OtherSettingViewController alloc]init]];
    } else if(type == SETTING_ABOUT){
        navController = [navController initWithRootViewController:[[AboutSettingViewController alloc]init]];
    }
    
    [self presentViewController:navController animated:YES completion:^{
        
    }];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
@end
