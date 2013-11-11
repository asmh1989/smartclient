//
//  ConnectSettingViewController.m
//  SmartClient
//
//  Created by sun on 13-11-1.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "ConnectSettingViewController.h"
#import "SettingStore.h"
#import "SettingForConnect.h"
#import "EditViewController.h"

@interface ConnectSettingViewController ()

@property (nonatomic, retain) SettingForConnect *settings;
@property (nonatomic, retain) UISwitch *airplaneModeSwitch;
@end

@implementation ConnectSettingViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(save:)];
        [[self navigationItem] setLeftBarButtonItem:doneItem];
        
        self.title = NSLocalizedString(@"ConnectSettings", @"Connect");
        
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
    
    __unsafe_unretained __block ConnectSettingViewController *safeSelf = self;
    
	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = NSLocalizedString(@"Server Settings:", nil);
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"ServerIpCell";
            
			cell.textLabel.text = NSLocalizedString(@"ServerIp", nil);
            cell.detailTextLabel.text =[safeSelf.settings hostIp];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"ServerIp", nil) Name:[safeSelf.settings hostIp] Complete:^(NSString *value) {
                safeSelf.settings.hostIp = value;
                [safeSelf.tableView reloadData];
            }] animated:YES];
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"ServerPortCell";
            
			cell.textLabel.text = NSLocalizedString(@"ServerPort", nil);
			cell.detailTextLabel.text =[NSString stringWithFormat:@"%d", [safeSelf.settings hostPort]];
		} whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController
                                pushViewController:[[EditViewController alloc]
                                initWithTitleAndName:NSLocalizedString(@"ServerPort", nil)
                                Name:[NSString stringWithFormat:@"%d", [safeSelf.settings hostPort]]
                                Complete:^(NSString *value) {
                safeSelf.settings.hostPort = [value intValue];
                [safeSelf.tableView reloadData];
            }] animated:YES];
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"ReconnectTimeCell";
            
			cell.textLabel.text = NSLocalizedString(@"ReconnectTime", nil);
            cell.detailTextLabel.text =[NSString stringWithFormat:@"%d", [safeSelf.settings reConnectTime]];
		} whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController
             pushViewController:[[EditViewController alloc]
                                 initWithTitleAndName:NSLocalizedString(@"ReconnectTime", nil)
                                 Name:[NSString stringWithFormat:@"%d", [safeSelf.settings reConnectTime]]
                                 Complete:^(NSString *value) {
                                     safeSelf.settings.reConnectTime = [value intValue];
                                     [safeSelf.tableView reloadData];
                                 }] animated:YES];
		}];
        
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = NSLocalizedString(@"Picture Settings:", nil);
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"pictureQuailityCell";
            
			cell.textLabel.text = NSLocalizedString(@"PictureQuality", nil);
            cell.detailTextLabel.text = [safeSelf.settings getPictureQualityArray][[safeSelf.settings pictureQuality]];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"PictureQuality", nil)  Complete:^(NSString *value) {
                safeSelf.settings.pictureQuality = [value intValue];
                [safeSelf.tableView reloadData];
            } EnumType:RadioCell DataArray:[safeSelf.settings getPictureQualityArray] FirstSelected:[safeSelf.settings pictureQuality]] animated:YES];
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"pictureTimeSizeCell";
            
			cell.textLabel.text = NSLocalizedString(@"PictureTimeSize", nil);
            cell.detailTextLabel.text = [safeSelf.settings getPictureTimeSizeArray][[safeSelf.settings pictureTimeSize]];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"PictureTimeSize", nil)  Complete:^(NSString *value) {
                safeSelf.settings.pictureTimeSize = [value intValue];
                [safeSelf.tableView reloadData];
            } EnumType:RadioCell DataArray:[safeSelf.settings getPictureTimeSizeArray] FirstSelected:[safeSelf.settings pictureTimeSize]] animated:YES];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"pictureTypeCell";
            
			cell.textLabel.text = NSLocalizedString(@"PictureType", nil);
            cell.detailTextLabel.text = [safeSelf.settings getPictureTypeArray][[safeSelf.settings pictureType]];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"PictureType", nil)  Complete:^(NSString *value) {
                safeSelf.settings.pictureType = [value intValue];
                [safeSelf.tableView reloadData];
            } EnumType:RadioCell DataArray:[safeSelf.settings getPictureTypeArray] FirstSelected:[safeSelf.settings pictureType]] animated:YES];
		}];
    }];
    
//    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
//		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
//			staticContentCell.reuseIdentifier = @"ProxyCell";
//			cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//			cell.textLabel.text = NSLocalizedString(@"UseProxy", nil);
//			cell.accessoryView = safeSelf.airplaneModeSwitch;
//		}];
//	}];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
