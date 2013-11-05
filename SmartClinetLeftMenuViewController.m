//
//  SmartClinetLeftMenuViewController.m
//  SmartClient
//
//  Created by sun on 13-10-31.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "SmartClinetLeftMenuViewController.h"
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
@interface TableCellData : NSObject
@property (nonatomic) NSString *cellName;
@property (nonatomic) UIImage *cellImage;

-(id)initWithData:(NSString *)name Image:(UIImage *)image;
@end

@implementation TableCellData

@synthesize cellImage, cellName;

- (id)initWithData:(NSString *)name Image:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.cellName = name;
        self.cellImage = image;
    }
    return self;
}

@end


@interface SmartClinetLeftMenuViewController ()
{
    NSArray *cells;
}
@end

@implementation SmartClinetLeftMenuViewController
@synthesize centerController;

- (id)initWithCenterController:(SmartClinetViewController *)controller
{
    self = [super init];
    if (self) {
        [self setRestorationIdentifier:@"leftSideDrawerViewControllerRestorationKey"];
        self.centerController = controller;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    cells = [[NSArray alloc] initWithObjects:
             [[TableCellData alloc] initWithData:@"连接" Image:[UIImage imageNamed:@"Connect_Image.png"]],
             [[TableCellData alloc] initWithData:@"字体" Image:[UIImage imageNamed:@"Font_Image.png"]],
             [[TableCellData alloc] initWithData:@"屏幕" Image:[UIImage imageNamed:@"Screen_Image.png"]],
             [[TableCellData alloc] initWithData:@"声音" Image:[UIImage imageNamed:@"Sound_Image.png"]],
             [[TableCellData alloc] initWithData:@"扫描设置" Image:[UIImage imageNamed:@"Scan_Image.png"]],
             [[TableCellData alloc] initWithData:@"其他" Image:[UIImage imageNamed:@"Other_Image.png"]],
             [[TableCellData alloc] initWithData:@"重新连接" Image:[UIImage imageNamed:@"Reconnect_Image.png"]],
             [[TableCellData alloc] initWithData:@"关于" Image:[UIImage imageNamed:@"About_Image.png"]],
             nil];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setTableHeaderView:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    
    TableCellData *d = [cells objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:d.cellName];
    [[cell imageView] setImage:d.cellImage];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    enum SettingType type = (enum SettingType)[indexPath row];
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
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}
@end
