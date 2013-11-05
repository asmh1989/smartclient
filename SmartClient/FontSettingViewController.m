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
#import "EditViewController.h"

@interface FontSettingViewController ()
@property (nonatomic, retain) SettingForConnect *settings;
@property (nonatomic, retain) UISwitch *airplaneModeSwitch;
@property (nonatomic, readonly) NSArray *colors;
@end

@implementation FontSettingViewController
@synthesize colors;
- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(save:)];
        [[self navigationItem] setLeftBarButtonItem:doneItem];
        
        self.title = NSLocalizedString(@"FontSettings", nil);
        
        self.settings = [[SettingStore shareStore] getSettings];
        
        colors = [[NSArray alloc] initWithObjects:@"White", @"Black", @"Red", @"Blue", @"Green", @"Yellow", @"Purple", nil];
        
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
			staticContentCell.reuseIdentifier = @"FontfamilyCell";
            
			cell.textLabel.text = NSLocalizedString(@"FontFamily", nil);
            NSString *fontName = [safeSelf.settings fontName];
            cell.detailTextLabel.text = fontName;
		}whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"FontFamily", nil) Name:[safeSelf.settings fontName] Complete:^(NSString *value){
                if (![safeSelf.settings.fontName isEqualToString:value]) {
                    safeSelf.settings.fontName = value;
                    NSArray * fontname = [UIFont fontNamesForFamilyName:value];
                    safeSelf.settings.fontStyle = fontname[0];
                    [safeSelf.tableView reloadData];
                }

              } EnumType:RadioCell] animated:YES];
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"FontNameCell";
            
			cell.textLabel.text = NSLocalizedString(@"FontName", nil);
            NSString *fontStyle = [safeSelf.settings fontStyle];
			cell.detailTextLabel.text = fontStyle;
		} whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"FontName", nil) Name:[safeSelf.settings fontStyle] Complete:^(NSString *value){
                    safeSelf.settings.fontStyle = value;
                    [safeSelf.tableView reloadData];
                
                } EnumType:RadioCell DataArray:[UIFont fontNamesForFamilyName:safeSelf.settings.fontName]] animated:YES];
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"FontSizeCell";
            
			cell.textLabel.text = NSLocalizedString(@"FontSize", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [safeSelf.settings fontSize]];
            [cell.detailTextLabel setFont:[UIFont fontWithName:[safeSelf.settings fontStyle] size:[safeSelf.settings fontSize]]];
		} whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"FontSize", nil)
                Name:[NSString stringWithFormat:@"%d", [safeSelf.settings fontSize]]
                Complete:^(NSString *value) {
                    
                safeSelf.settings.fontSize = [value intValue];
                [safeSelf.tableView reloadData];
            }] animated:YES];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"FontEncCell";
            
			cell.textLabel.text = NSLocalizedString(@"FontEnc", nil);
            cell.detailTextLabel.text =@"GB2312";
            [cell.detailTextLabel setFont:[UIFont fontWithName:[safeSelf.settings fontStyle] size:[safeSelf.settings fontSize]]];
		} whenSelected:^(NSIndexPath *indexPath) {

		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"FontfgColorCell";
            
			cell.textLabel.text = NSLocalizedString(@"FontFgColor", nil);
            cell.detailTextLabel.text =[safeSelf.colors objectAtIndex:[safeSelf.settings fontFgColor]];
		} whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"FontFgColor", nil) Complete:^(NSString *value){
                safeSelf.settings.fontFgColor = [value intValue];
                [safeSelf.tableView reloadData];
                
            } EnumType:RadioCell DataArray:safeSelf.colors FirstSelected:[safeSelf.settings fontFgColor]] animated:YES];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            staticContentCell.reuseIdentifier = @"FontBgColorCell";
            
			cell.textLabel.text = NSLocalizedString(@"FontBgColor", nil);
            cell.detailTextLabel.text =[safeSelf.colors objectAtIndex:[safeSelf.settings fontBgColor]];
		} whenSelected:^(NSIndexPath *indexPath) {
            [safeSelf.navigationController pushViewController:[[EditViewController alloc] initWithTitleAndName:NSLocalizedString(@"FontBgColor", nil) Complete:^(NSString *value){
                safeSelf.settings.fontBgColor = [value intValue];
                [safeSelf.tableView reloadData];
                
            } EnumType:RadioCell DataArray:safeSelf.colors FirstSelected:[safeSelf.settings fontBgColor]] animated:YES];
		}];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
