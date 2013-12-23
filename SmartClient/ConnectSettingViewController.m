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


@interface NSVTServiceContent : NSObject
@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, copy) NSString *serviceIp;
@property (nonatomic, copy) NSString *servicePort;

- (id)initWithContent:(NSString *)name IP:(NSString *)ip Port:(NSString *)port;
@end

@implementation NSVTServiceContent

@synthesize serviceIp, serviceName, servicePort;

- (id)initWithContent:(NSString *)name IP:(NSString *)ip Port:(NSString *)port{
    self = [super init];
    if (self) {
        servicePort = port;
        serviceName = name;
        serviceIp = ip;
    }
    return self;
}
@end

@interface ConnectSettingViewController ()

@property (nonatomic, retain) SettingForConnect *settings;
@property (nonatomic, retain) UISwitch *airplaneModeSwitch;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic) NSMutableArray *vtServices;
@property (nonatomic) int defaultSelect;
@property (nonatomic, strong) UIActivityIndicatorView *searchingForNetworksActivityIndicator;

- (void) _foundNetworks;

@end

@implementation ConnectSettingViewController

@synthesize segmentedControl, vtServices, defaultSelect, searchingForNetworksActivityIndicator;

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
        
        vtServices = [[NSMutableArray alloc] init];
        [vtServices addObject:[[NSVTServiceContent alloc] initWithContent:@"service1" IP:@"192.168.8.239" Port:@"23"]];
        [vtServices addObject:[[NSVTServiceContent alloc] initWithContent:@"service2" IP:@"192.168.8.240" Port:@"23"]];
        [vtServices addObject:[[NSVTServiceContent alloc] initWithContent:@"service3" IP:@"192.168.8.241" Port:@"23"]];
        [vtServices addObject:[[NSVTServiceContent alloc] initWithContent:@"service4" IP:@"192.168.8.242" Port:@"23"]];
        [vtServices addObject:[[NSVTServiceContent alloc] initWithContent:@"service5" IP:@"192.168.8.243" Port:@"23"]];
        [vtServices addObject:[[NSVTServiceContent alloc] initWithContent:@"service6" IP:@"192.168.8.244" Port:@"23"]];
        [vtServices addObject:[[NSVTServiceContent alloc] initWithContent:@"service7" IP:@"192.168.8.245" Port:@"23"]];
        [vtServices addObject:[[NSVTServiceContent alloc] initWithContent:@"service8" IP:@"192.168.8.246" Port:@"23"]];
        [vtServices addObject:[[NSVTServiceContent alloc] initWithContent:@"service9" IP:@"192.168.8.247" Port:@"23"]];
        [vtServices addObject:[[NSVTServiceContent alloc] initWithContent:@"service10" IP:@"192.168.8.248" Port:@"23"]];
        [vtServices addObject:[[NSVTServiceContent alloc] initWithContent:@"service11" IP:@"192.168.8.249" Port:@"23"]];
        
        defaultSelect = 0;

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


- (void) _foundNetworks {
	if([self numberOfSectionsInTableView:self.tableView] == 1) return;
    
	[self.tableView beginUpdates];
    
	for(NSUInteger i = 0; i < [self.vtServices count]; i++) {
		NSVTServiceContent *network = [self.vtServices objectAtIndex:i];
        
        __unsafe_unretained __block ConnectSettingViewController *safeSelf = self;
        
        JMStaticContentTableViewSection *section = [self sectionAtIndex:1];
		[section insertCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"WifiNetworkCell";
//			staticContentCell.tableViewCellSubclass = [WifiNetworkTableViewCell class];
            
			cell.textLabel.text = network.serviceName;
            if(OSVersionIsAtLeastiOS7()){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
            } else {
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            }
			cell.indentationLevel = 2;
			cell.indentationWidth = 10.0;
            
		} whenSelected:^(NSIndexPath *indexPath) {
            
		} atIndexPath:[NSIndexPath indexPathForRow:i inSection:1] animated:YES];
        
	}
    
	[self.tableView endUpdates];
    
	[self.searchingForNetworksActivityIndicator stopAnimating];
}



-(void)segmentAction:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"segmentAction Index %i", Index);
    __unsafe_unretained __block ConnectSettingViewController *safeSelf = self;

    [self removeAllSections];
    if(Index == 0){
        defaultSelect = 0;
        [self insertSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
            section.headerTitle = NSLocalizedString(@"Server Settings:", nil);
            
            [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                staticContentCell.cellStyle = UITableViewCellStyleValue1;
                staticContentCell.reuseIdentifier = @"ServerIpCell";
                
                cell.textLabel.text = @"自定义";
                cell.detailTextLabel.text =[safeSelf.settings hostIp];
            }];
            
        } atIndex:0];
        
        [self insertSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
            section.headerTitle = NSLocalizedString(@"Choose a Server", Nil);
            
            for(NSUInteger i = 0; i < [self.vtServices count]; i++) {
                NSVTServiceContent *network = [self.vtServices objectAtIndex:i];
                
                [section insertCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                    staticContentCell.reuseIdentifier = @"WifiNetworkCell";
//                    staticContentCell.tableViewCellSubclass = [WifiNetworkTableViewCell class];
                    
                    cell.textLabel.text = network.serviceName;
                    
                    if(OSVersionIsAtLeastiOS7()){
                        cell.accessoryType = UITableViewCellAccessoryDetailButton;
                    } else {
                        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                    }
                    
                    cell.indentationLevel = 2;
                    cell.indentationWidth = 10.0;
                    
                } whenSelected:^(NSIndexPath *indexPath) {
                    
                } atIndexPath:[NSIndexPath indexPathForRow:i inSection:1] animated:YES];
            }
        } atIndex:1];
        
//        [self performSelector:@selector(_foundNetworks) withObject:nil afterDelay:0.7];
        
    } else if( Index == 1){
        defaultSelect = 1;
            [self insertSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
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

            } atIndex:0];
    }
    
    [self.tableView reloadData];

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"快捷设置",@"自定义",nil];
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    self.segmentedControl.frame = CGRectMake(100, 20.0, self.tableView.tableHeaderView.frame.size.width/2, 36.0);
    
    self.segmentedControl.selectedSegmentIndex = defaultSelect;//设置默认选择项索引
    self.tableView.tableHeaderView = segmentedControl;
    
     [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.searchingForNetworksActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    __unsafe_unretained __block ConnectSettingViewController *safeSelf = self;
    
	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = NSLocalizedString(@"Server Settings:", nil);
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"ServerIpCell";
            
			cell.textLabel.text = @"自定义";
            cell.detailTextLabel.text =[safeSelf.settings hostIp];
		}];
        
    }];

    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		section.headerTitle = NSLocalizedString(@"Choose a Server...", Nil);
        
//		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
//			staticContentCell.reuseIdentifier = @"ServiceOtherCell";
//			cell.textLabel.text = NSLocalizedString(@"Other...", @"Other...");
//            
//			cell.indentationLevel = 2;
//			cell.indentationWidth = 10.0;
//		}];
	}];
    
    self.footerText = NSLocalizedString(@"Known Server will be joined automatically. If no known networks are available, you will be asked before joining a new network.", nil);

}


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	[self.searchingForNetworksActivityIndicator startAnimating];
}
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
	[self performSelector:@selector(_foundNetworks) withObject:nil afterDelay:0.7];
}

#pragma mark - Table View Delegate

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if(defaultSelect == 0 &&  section == 1) {
		UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 16.0)];
        
		UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 10.0, 320.0, 16.0)];
        
		headerLabel.backgroundColor = [tableView backgroundColor];
		headerLabel.text = NSLocalizedString(@"Choose a Server...", nil);
		headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
		headerLabel.textColor = [UIColor colorWithRed:61.0/255.0 green:77.0/255.0 blue:99.0/255.0 alpha:1.0];
		headerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.65];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        
		[header addSubview:headerLabel];
        
		self.searchingForNetworksActivityIndicator.frame = CGRectMake(190.0, 18.0, 0.0, 0.0);
		[header addSubview:self.searchingForNetworksActivityIndicator];
        
		return header;
	} else {
		return nil;
	}
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //	if(section == 1) {
    //		return 22.0;
    //	} else {
    return UITableViewAutomaticDimension;
    //	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSLog(@"点击了cell右边按钮 : %d", row);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
