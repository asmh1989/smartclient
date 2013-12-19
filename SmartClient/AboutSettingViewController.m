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


@interface AboutSettingViewController ()
{
    SettingForConnect *settings;
}
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet HTCopyableLabel *deviceID;

@end

@implementation AboutSettingViewController

@synthesize version, deviceID;

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

@end
