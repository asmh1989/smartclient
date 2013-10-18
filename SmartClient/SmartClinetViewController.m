//
//  SmartClinetViewController.m
//  SmartClient
//
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "SmartClinetViewController.h"
#import "SettingStore.h"

@interface SmartClinetViewController ()


@end

@implementation SmartClinetViewController


@synthesize content;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        enc = [[[SettingStore shareStore] getSettings]enc];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    NSString *ip = [[[SettingStore shareStore] getSettings] hostIp];
    int port = [[[SettingStore shareStore] getSettings] hostPort];
    NSString *deviceId =[[[SettingStore shareStore] getSettings] deviceID];
    NSString *os = [[UIDevice currentDevice] systemName];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    NSLog(@"connect ip = %@, port = %d, deviceID = %@", ip, port, deviceId);
    
    if (![socket connectToHost:ip onPort:port error:&err]) {
        NSLog(@"Error : %@", err);
    }
    
    NSString *setStr = [NSString stringWithFormat:@"%c<SET ID=\"%@\" RFID=\"False\" Gps=\"False\" CAM=\"True\" MSGBOX=\"True\" OptionDialog=\"True\" OS=\"%@\" OSVersion=\"%@\" />", (char)0x1b,deviceId, os, version];
    NSLog(@"first send : %@", setStr);
    
    NSData *data = [setStr dataUsingEncoding:enc];
    
    [socket writeData:data withTimeout:-1 tag:1];
}



- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"didAcceptNewSocket ..");
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"didConnectToHost host = %@, port=%d", host, port);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:enc];
    NSLog(@"didReadData data = %@, tag = %ld", msg, tag);
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didReadPartialDataOfLength... %ld", partialLength);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"didWriteDataWithTag...tag = %ld", tag);
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didWritePartialDataOfLength...");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
