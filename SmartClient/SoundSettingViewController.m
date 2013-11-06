//
//  SoundSettingViewController.m
//  SmartClient
//
//  Created by sun on 13-11-4.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "SoundSettingViewController.h"
#import "SettingStore.h"
#import "SettingForConnect.h"
#import "EditViewController.h"

#define INT_TO_STRONG(N) [NSString stringWithFormat:@"%d", (N)]

@interface SoundSettingViewController ()

@property (nonatomic, retain) SettingForConnect *settings;
@property (nonatomic, retain) UISwitch *IsBeepSwitch;
@property (nonatomic, readonly) NSArray *sounds;
@end

@implementation SoundSettingViewController
@synthesize sounds;
- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(save:)];
        [[self navigationItem] setLeftBarButtonItem:doneItem];
        
        self.title = NSLocalizedString(@"Sound", nil);
        
        self.settings = [[SettingStore shareStore] getSettings];
        sounds = self.settings.getSounds;
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

- (void) _switchChanged:(UISwitch *)senderSwitch {
	if([senderSwitch isEqual:self.IsBeepSwitch]) {
        self.settings.isBeep = self.IsBeepSwitch.on;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.IsBeepSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    self.IsBeepSwitch.on = [self.settings isFullScreen];
    
    [self.IsBeepSwitch addTarget:self action:@selector(_switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    __unsafe_unretained __block SoundSettingViewController *safeSelf = self;
    
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {

        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"IsBeepCell";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
			cell.textLabel.text = NSLocalizedString(@"IsBeep", nil);
			cell.accessoryView = safeSelf.IsBeepSwitch;
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"SoundCell";
            
			cell.textLabel.text = NSLocalizedString(@"SoundOptions", nil);
            cell.detailTextLabel.text = safeSelf.sounds[[safeSelf.settings soundUsed]];
            
		}whenSelected:^(NSIndexPath *indexPath) {
            
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"SoundOptions", nil) Complete:^(NSString *value){
                
                [safeSelf.settings setSoundUsed:[value intValue]];
                [safeSelf.tableView reloadData];
                
            } EnumType:RadioSoundCell DataArray:safeSelf.sounds FirstSelected:[safeSelf.settings soundUsed]] animated:YES];
		}];
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
