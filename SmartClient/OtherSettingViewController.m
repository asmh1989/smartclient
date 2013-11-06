//
//  OtherSettingViewController.m
//  SmartClient
//
//  Created by sun on 13-11-4.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "OtherSettingViewController.h"
#import "StringForNSUserDefaults.h"
#import "EditViewController.h"

#define INT_TO_STRONG(N)    [NSString stringWithFormat:@"%d", (N)]


@interface OtherSettingViewController ()

@property (nonatomic, retain) UISwitch *sendMacSwitch;
@property (nonatomic, retain) UISwitch *enableLogSwitch;
@property (nonatomic, retain) UISwitch *enableGpsSwitch;
@property (nonatomic, retain) UISwitch *startenableGpsSwitch;
@property (nonatomic, retain) UISwitch *notificationActiveSwithSwitch;
@property (nonatomic, retain) UISwitch *notificationVibrateSwithSwitch;
@end

@implementation OtherSettingViewController
- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(save:)];
        [[self navigationItem] setLeftBarButtonItem:doneItem];
        
        self.title = NSLocalizedString(@"OtherSetting", nil);
        
    }
    return self;
}

- (IBAction)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void) _switchChanged:(UISwitch *)senderSwitch {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
	if([senderSwitch isEqual:self.sendMacSwitch]) {
        [userDefaultes setBool:self.sendMacSwitch.on forKey:STR_MAC];
	} else if([senderSwitch isEqual:self.enableLogSwitch]) {
        [userDefaultes setBool:self.enableLogSwitch.on forKey:STR_LOG];
	} else if([senderSwitch isEqual:self.enableGpsSwitch]) {
        [userDefaultes setBool:self.enableGpsSwitch.on forKey:STR_ENABLE_GPS];
	} else if([senderSwitch isEqual:self.startenableGpsSwitch]) {
        [userDefaultes setBool:self.startenableGpsSwitch.on forKey:STR_STARTUP_GPS];
	} else if([senderSwitch isEqual:self.notificationActiveSwithSwitch]) {
        [userDefaultes setBool:self.notificationActiveSwithSwitch.on forKey:STR_NF_ACTIVE];
	} else if([senderSwitch isEqual:self.notificationVibrateSwithSwitch]) {
        [userDefaultes setBool:self.notificationVibrateSwithSwitch.on forKey:STR_NF_VIBRATE];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    SWITCH_INIT(self.sendMacSwitch);
    SWITCH_INIT(self.enableLogSwitch);
    SWITCH_INIT(self.enableGpsSwitch);
    SWITCH_INIT(self.startenableGpsSwitch);
    SWITCH_INIT(self.notificationActiveSwithSwitch);
    SWITCH_INIT(self.notificationVibrateSwithSwitch);
    
    SWITCH_ACTION(self.sendMacSwitch);
    SWITCH_ACTION(self.enableGpsSwitch);
    SWITCH_ACTION(self.enableLogSwitch);
    SWITCH_ACTION(self.startenableGpsSwitch);
    SWITCH_ACTION(self.notificationVibrateSwithSwitch);
    SWITCH_ACTION(self.notificationActiveSwithSwitch);
    
    self.sendMacSwitch.on = [userDefaultes boolForKey:STR_MAC];
    self.enableLogSwitch.on = [userDefaultes boolForKey:STR_LOG];
    self.enableGpsSwitch.on = [userDefaultes boolForKey:STR_ENABLE_GPS];
    self.startenableGpsSwitch.on = [userDefaultes boolForKey:STR_STARTUP_GPS];
    self.notificationActiveSwithSwitch.on = [userDefaultes boolForKey:STR_NF_ACTIVE];
    self.notificationVibrateSwithSwitch.on = [userDefaultes boolForKey:STR_NF_VIBRATE];
    
    __unsafe_unretained __block OtherSettingViewController *safeSelf = self;
    
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = NSLocalizedString(@"Additional Settings:", nil);
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"sendMacCell";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
			cell.textLabel.text = NSLocalizedString(@"sendMac", nil);
			cell.accessoryView = safeSelf.sendMacSwitch;
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"enableLogCell";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
			cell.textLabel.text = NSLocalizedString(@"enableLog", nil);
			cell.accessoryView = safeSelf.enableLogSwitch;
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"serialNumberCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
			cell.textLabel.text = NSLocalizedString(@"serivalNumber", nil);
            cell.detailTextLabel.text = [userDefaultes stringForKey:STR_SERIAL];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"ServerIp", nil) Name:[userDefaultes stringForKey:STR_SERIAL] Complete:^(NSString *value) {
                [userDefaultes setObject:value forKey:STR_SERIAL];
                [safeSelf.tableView reloadData];
            }] animated:YES];
		}];
    }];
    
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = NSLocalizedString(@"Gps settings:", nil);
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"enableGpsCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = NSLocalizedString(@"enableGps", nil);
            cell.accessoryView = safeSelf.enableGpsSwitch;
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"startupGpsCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = NSLocalizedString(@"startupGps", nil);
            cell.accessoryView = safeSelf.startenableGpsSwitch;
        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"gpsTimeCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
			cell.textLabel.text = NSLocalizedString(@"gpsTime", nil);
            cell.detailTextLabel.text = [userDefaultes stringForKey:STR_GPS_TIME];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"gpsTime", nil) Name:[userDefaultes stringForKey:STR_GPS_TIME] Complete:^(NSString *value) {
                [userDefaultes setObject:value forKey:STR_GPS_TIME];
                [safeSelf.tableView reloadData];
            }] animated:YES];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"gpsDistanceCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
			cell.textLabel.text = NSLocalizedString(@"gpsDistance", nil);
            cell.detailTextLabel.text = [userDefaultes stringForKey:STR_GPS_DISTANCE];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"gpsDistance", nil) Name:[userDefaultes stringForKey:STR_GPS_DISTANCE] Complete:^(NSString *value) {
                [userDefaultes setObject:value forKey:STR_GPS_DISTANCE];
                [safeSelf.tableView reloadData];
            }] animated:YES];
		}];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = NSLocalizedString(@"Notification Settings:", nil);
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"nfActiveCell";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
			cell.textLabel.text = NSLocalizedString(@"nfActive", nil);
			cell.accessoryView = safeSelf.notificationActiveSwithSwitch;
		}];
        
//        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
//			staticContentCell.reuseIdentifier = @"nfSoundCell";
//            staticContentCell.cellStyle = UITableViewCellStyleValue1;
//            
//			cell.textLabel.text = NSLocalizedString(@"nfSound", nil);
//            cell.detailTextLabel.text = [userDefaultes stringForKey:STR_SOUND];
//		}whenSelected:^(NSIndexPath *indexPath) {
//		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"nfVibrateCell";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
			cell.textLabel.text = NSLocalizedString(@"nfVibrate", nil);
			cell.accessoryView = safeSelf.notificationVibrateSwithSwitch;
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"nfTimeCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
			cell.textLabel.text = NSLocalizedString(@"nfTime", nil);
            cell.detailTextLabel.text = [userDefaultes stringForKey:STR_NF_TIME];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"nfTime", nil) Name:[userDefaultes stringForKey:STR_NF_TIME] Complete:^(NSString *value) {
                [userDefaultes setObject:value forKey:STR_NF_TIME];
                [safeSelf.tableView reloadData];
            }] animated:YES];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"nfServerCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
			cell.textLabel.text = NSLocalizedString(@"nfServer", nil);
            cell.detailTextLabel.text = [NSString stringWithString:[userDefaultes stringForKey:STR_NF_SERVER]];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"nfServer", nil) Name:[userDefaultes stringForKey:STR_NF_SERVER] Complete:^(NSString *value) {
                [userDefaultes setObject:value forKey:STR_NF_SERVER];
                [safeSelf.tableView reloadData];
            }] animated:YES];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"nfPortCell";
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            
			cell.textLabel.text = NSLocalizedString(@"nfPort", nil);
            cell.detailTextLabel.text = [userDefaultes stringForKey:STR_NF_PORT];
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"nfPort", nil) Name:[userDefaultes stringForKey:STR_NF_PORT] Complete:^(NSString *value) {
                [userDefaultes setObject:value forKey:STR_NF_PORT];
                [safeSelf.tableView reloadData];
            }] animated:YES];
		}];
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
