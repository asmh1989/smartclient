//
//  FontSettingViewController.m
//  SmartClient
//
//  Created by sun on 13-11-4.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "FontSettingViewController.h"
#import "SettingStore.h"
#import "SettingForConnect.h"

@interface FontSettingViewController ()
@property (nonatomic, retain) SettingForConnect *settings;
@property (nonatomic, retain) UISwitch *airplaneModeSwitch;

@end

@implementation FontSettingViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(save:)];
        [[self navigationItem] setLeftBarButtonItem:doneItem];
        
        self.title = NSLocalizedString(@"Font", nil);
        
        self.settings = [[SettingStore shareStore] getSettings];
    }
    return self;
}

- (IBAction)save:(id)sender
{
    [[SettingStore shareStore] saveSettingsConfig];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.airplaneModeSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    __unsafe_unretained __block FontSettingViewController *safeSelf = self;
    
	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"ServerIpCell";
            
			cell.textLabel.text = NSLocalizedString(@"ServerIp", nil);
            cell.detailTextLabel.text =[safeSelf.settings hostIp];
		}whenSelected:^(NSIndexPath *indexPath) {
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"ServerPortCell";
            
			cell.textLabel.text = NSLocalizedString(@"ServerPort", nil);
			cell.detailTextLabel.text =[NSString stringWithFormat:@"%d", [safeSelf.settings hostPort]];
		} whenSelected:^(NSIndexPath *indexPath) {

		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"ReconnectTimeCell";
            
			cell.textLabel.text = NSLocalizedString(@"ReconnectTime", nil);
            cell.detailTextLabel.text =[NSString stringWithFormat:@"%d", [safeSelf.settings reConnectTime]];
		} whenSelected:^(NSIndexPath *indexPath) {

		}];
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
