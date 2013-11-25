//
//  ScreenSettingViewController.m
//  SmartClient
//
//  Created by sun on 13-11-4.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "ScreenSettingViewController.h"
#import "SettingStore.h"
#import "SettingForConnect.h"
#import "EditViewController.h"

#define INT_TO_STRONG(N) [NSString stringWithFormat:@"%d", (N)]

@interface ScreenSettingViewController ()
@property (nonatomic, retain) SettingForConnect *settings;
@property (nonatomic, retain) UISwitch *fullScreenSwitch;
@end

@implementation ScreenSettingViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(save:)];
        [[self navigationItem] setLeftBarButtonItem:doneItem];
        
        self.title = NSLocalizedString(@"Screen", nil);
        
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

- (void) _switchChanged:(UISwitch *)senderSwitch {
	if([senderSwitch isEqual:self.fullScreenSwitch]) {
        self.settings.isFullScreen = self.fullScreenSwitch.on;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.fullScreenSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];

    self.fullScreenSwitch.on = [self.settings isFullScreen];
    
    [self.fullScreenSwitch addTarget:self action:@selector(_switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    __unsafe_unretained __block ScreenSettingViewController *safeSelf = self;
    
	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"LeftMarginCell";
            
			cell.textLabel.text = NSLocalizedString(@"LeftMargin", nil);
            cell.detailTextLabel.text = INT_TO_STRONG([safeSelf.settings leftMargin]);
            
		}whenSelected:^(NSIndexPath *indexPath) {
            
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"LeftMargin", nil) Name:INT_TO_STRONG([safeSelf.settings leftMargin]) Complete:^(NSString *value){
                [safeSelf.settings setLeftMargin:[value intValue]];
                [safeSelf.tableView reloadData];
            } EnumType:EditCell] animated:YES];
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"TopMarginCell";
            
			cell.textLabel.text = NSLocalizedString(@"TopMargin", nil);
            cell.detailTextLabel.text = INT_TO_STRONG([safeSelf.settings topMargin]);
            
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"TopMargin", nil) Name:INT_TO_STRONG([safeSelf.settings topMargin]) Complete:^(NSString *value){
                [safeSelf.settings setTopMargin:[value intValue]];
                [safeSelf.tableView reloadData];
            } EnumType:EditCell] animated:YES];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"ColumnSpanCell";
            
			cell.textLabel.text = NSLocalizedString(@"ColumnSpan", nil);
            cell.detailTextLabel.text = INT_TO_STRONG([safeSelf.settings columnSpan]);
            
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"ColumnSpan", nil) Name:INT_TO_STRONG([safeSelf.settings columnSpan]) Complete:^(NSString *value){
                [safeSelf.settings setColumnSpan:[value intValue]];
                [safeSelf.tableView reloadData];
            } EnumType:EditCell] animated:YES];

		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"RowSpanCell";
            
			cell.textLabel.text = NSLocalizedString(@"RowSpan", nil);
            cell.detailTextLabel.text = INT_TO_STRONG([safeSelf.settings rowSpan]);
            
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"RowSpan", nil) Name:INT_TO_STRONG([safeSelf.settings rowSpan]) Complete:^(NSString *value){
                [safeSelf.settings setRowSpan:[value intValue]];
                [safeSelf.tableView reloadData];
                
            } EnumType:EditCell] animated:YES];
		}];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"CaretHeightCell";
            
			cell.textLabel.text = NSLocalizedString(@"CaretHeight", nil);
            cell.detailTextLabel.text = INT_TO_STRONG([safeSelf.settings cursorHeight]);
            
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"CaretHeight", nil) Name:INT_TO_STRONG([safeSelf.settings cursorHeight]) Complete:^(NSString *value){
                [safeSelf.settings setCursorHeight:[value intValue]];
                [safeSelf.tableView reloadData];
                
            } EnumType:EditCell] animated:YES];
		}];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"FullScreenCell";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

			cell.textLabel.text = NSLocalizedString(@"FullScreen", nil);
			cell.accessoryView = safeSelf.fullScreenSwitch;
		}];
        
//        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
//			staticContentCell.reuseIdentifier = @"LandScreenCell";
//			cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//			cell.textLabel.text = NSLocalizedString(@"Screen Orientation", nil);
//            cell.detailTextLabel.text = [safeSelf.settings getScreenOri][[safeSelf.settings screenOrientation]];
//		}whenSelected:^(NSIndexPath *indexPath) {
//            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"Screen Orientation", nil)  Complete:^(NSString *value) {
//                safeSelf.settings.screenOrientation = [value intValue];
//                [safeSelf.tableView reloadData];
//            } EnumType:RadioCell DataArray:[safeSelf.settings getScreenOri] FirstSelected:[safeSelf.settings screenOrientation]] animated:YES];
//		}];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
