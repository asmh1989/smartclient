//
//  SmartClinetLeftMenuViewController.m
//  SmartClient
//
//  Created by sun on 13-10-31.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "SmartClinetLeftMenuViewController.h"

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


- (id)init
{
    self = [super init];
    if (self) {
        [self setRestorationIdentifier:@"leftSideDrawerViewControllerRestorationKey"];
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
    NSLog(@"number = %d", [cells count]);
    return [cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    TableCellData *d = [cells objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:d.cellName];
    [[cell imageView] setImage:d.cellImage];
    return cell;
}

@end
