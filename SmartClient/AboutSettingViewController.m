//
//  AboutSettingViewController.m
//  SmartClient
//
//  Created by sun on 13-11-4.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "AboutSettingViewController.h"
#import "SettingForConnect.h"
#import "SettingStore.h"


NSString * const WEBSITE = @"www.searching-info.com";
NSString * const NUMBER = @"021-63046241";

@interface AboutSettingViewController ()
{
    SettingForConnect *settings;
}
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet HTCopyableLabel *deviceID;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *www;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *phonenumber;

@end

@implementation AboutSettingViewController

@synthesize version, deviceID, www, phonenumber;

- (id)init
{
    self = [super init];
    if (self) {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(save:)];
        [[self navigationItem] setLeftBarButtonItem:doneItem];
        
        self.title = NSLocalizedString(@"About", nil);
        settings = [[SettingStore shareStore] getSettings];
    }
    return self;
}

- (IBAction)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    version.text = [@"V" stringByAppendingString: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    deviceID.text = [NSLocalizedString(@"DeviceID", nil) stringByAppendingString:settings.deviceID];
    deviceID.copyableLabelDelegate = self;
    
    www.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    [www setLineBreakMode:NSLineBreakByWordWrapping];
    [www setText:www.text];
    
    phonenumber.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    [phonenumber setLineBreakMode:NSLineBreakByWordWrapping];
    [phonenumber setText:phonenumber.text];
    
    [www addLinkToURL:[NSURL URLWithString:WEBSITE] withRange:NSMakeRange(3, WEBSITE.length)];
    [phonenumber addLinkToPhoneNumber:NUMBER withRange:NSMakeRange(3, NUMBER.length)];
    
    [www setDelegate:self];
    [phonenumber setDelegate:self];
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    [[[UIActionSheet alloc] initWithTitle:phoneNumber delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Phone Call", nil), nil] showInView:self.view];
}

- (NSString *)stringToCopyForCopyableLabel:(HTCopyableLabel *)copyableLabel
{
    return settings.deviceID;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if ([actionSheet.title isEqualToString:NUMBER]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:actionSheet.title]]];
    }else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
    }
}

@end
