//
//  ScanSettingViewController.m
//  SmartClient
//
//  Created by sun on 13-11-4.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "ScanSettingViewController.h"
#import "StringForNSUserDefaults.h"

#define INT_TO_STRONG(N)    [NSString stringWithFormat:@"%d", (N)]


@interface ScanSettingViewController ()

@property (nonatomic, retain) UISwitch *decodeOneBarcodeSwitch;
@property (nonatomic, retain) UISwitch *decodeQRBarcodeSwitch;
@property (nonatomic, retain) UISwitch *decodeRectBarcodeSwitch;
@property (nonatomic, retain) UISwitch *soundSwitch;
@property (nonatomic, retain) UISwitch *vibrateSwitch;
@end

@implementation ScanSettingViewController
- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(save:)];
        [[self navigationItem] setLeftBarButtonItem:doneItem];
        
        self.title = NSLocalizedString(@"ScanSetting", nil);
        
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
	if([senderSwitch isEqual:self.decodeOneBarcodeSwitch]) {
        [userDefaultes setBool:self.decodeOneBarcodeSwitch.on forKey:STR_ONE_DECODE];
	} else if([senderSwitch isEqual:self.decodeQRBarcodeSwitch]) {
        [userDefaultes setBool:self.decodeQRBarcodeSwitch.on forKey:STR_QR_DECODE];
	} else if([senderSwitch isEqual:self.decodeRectBarcodeSwitch]) {
        [userDefaultes setBool:self.decodeRectBarcodeSwitch.on forKey:STR_RECT_DECODE];
	} else if([senderSwitch isEqual:self.soundSwitch]) {
        [userDefaultes setBool:self.soundSwitch.on forKey:STR_SOUND];
	} else if([senderSwitch isEqual:self.vibrateSwitch]) {
        [userDefaultes setBool:self.vibrateSwitch.on forKey:STR_VIBRATE];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    SWITCH_INIT(self.decodeOneBarcodeSwitch);
    SWITCH_INIT(self.decodeQRBarcodeSwitch);
    SWITCH_INIT(self.decodeRectBarcodeSwitch);
    SWITCH_INIT(self.soundSwitch);
    SWITCH_INIT(self.vibrateSwitch);
    
    SWITCH_ACTION(self.decodeOneBarcodeSwitch);
    SWITCH_ACTION(self.decodeQRBarcodeSwitch);
    SWITCH_ACTION(self.decodeRectBarcodeSwitch);
    SWITCH_ACTION(self.soundSwitch);
    SWITCH_ACTION(self.vibrateSwitch);
    
    self.decodeOneBarcodeSwitch.on = [userDefaultes boolForKey:STR_ONE_DECODE];
    self.decodeQRBarcodeSwitch.on = [userDefaultes boolForKey:STR_QR_DECODE];
    self.decodeRectBarcodeSwitch.on = [userDefaultes boolForKey:STR_RECT_DECODE];
    self.soundSwitch.on = [userDefaultes boolForKey:STR_SOUND];
    self.vibrateSwitch.on = [userDefaultes boolForKey:STR_VIBRATE];
    
//    [self.decodeOneBarcodeSwitch addTarget:self action:@selector(_switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    __unsafe_unretained __block ScanSettingViewController *safeSelf = self;
    
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"decodeOneBarcodeCell";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
			cell.textLabel.text = NSLocalizedString(@"decodeOneBarcode", nil);
			cell.accessoryView = safeSelf.decodeOneBarcodeSwitch;
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"decodeQRBarcodeCell";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
			cell.textLabel.text = NSLocalizedString(@"decodeQRBarcode", nil);
			cell.accessoryView = safeSelf.decodeQRBarcodeSwitch;
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"decodeRectBarcodeCell";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
			cell.textLabel.text = NSLocalizedString(@"decodeRectBarcode", nil);
			cell.accessoryView = safeSelf.decodeRectBarcodeSwitch;
		}];
    }];
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        
//        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
//            staticContentCell.reuseIdentifier = @"decodeSoundCell";
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            cell.textLabel.text = NSLocalizedString(@"decodeSound", nil);
//            cell.accessoryView = safeSelf.soundSwitch;
//        }];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.reuseIdentifier = @"decodeVibrateCell";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = NSLocalizedString(@"decodeVibrate", nil);
            cell.accessoryView = safeSelf.vibrateSwitch;
        }];
            
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
