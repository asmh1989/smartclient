//
//  SmartClinetViewController.m
//  SmartClient
//
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "SmartClinetViewController.h"
#import "SettingStore.h"
#import "SettingForRuntime.h"
#import "StringShowList.h"
#import "Functions.h"
#import "ShowListEventArgs.h"

@interface SmartClinetViewController ()

@property (nonatomic) SettingForRuntime *settings;
@property (nonatomic) StringShowList *stringShowList;
@end

@implementation SmartClinetViewController


@synthesize  mView, textView, settings, stringShowList;

- (SettingForRuntime *)settings
{
    if (settings) {
        return settings;
    }
    
    return settings = [SettingForRuntime shareStore];
}

- (StringShowList *)stringShowList
{
    if (stringShowList) {
        return stringShowList;
    }
    
    return stringShowList = [StringShowList shareStore];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        enc = [[[SettingStore shareStore] getSettings]enc];
        parser = [[ParserMsg alloc] init];
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
    [parser parserString:msg];
    [mView setNeedsDisplay];
    [self showTextView];
    [sock readDataWithTimeout:-1 tag:tag];

}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didReadPartialDataOfLength... %ld", tag);
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


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing text = %@", [textField text]);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing text = %@", [textField text]);
}

- (void) showTextView
{
    CGFloat y = settings.caret.pos.y;
    CGFloat x = settings.caret.pos.x;
    if ([stringShowList.stringShowDics objectForKey:_TOSTRIING(y)]) {
        NSArray *lines = [stringShowList.stringShowDics objectForKey:_TOSTRIING(y)];
        for (ShowListEventArgs *line in lines) {
            if (x >= line.curPoint.x && x < line.curCaretPos.x) {
                UIFont *myFont = [UIFont boldSystemFontOfSize:[[[SettingStore shareStore] getSettings] fontSize]];
                int leftMargin = [[[SettingStore shareStore] getSettings] leftMargin];
                int topMargin = [[[SettingStore shareStore] getSettings] topMargin];
                int columnSpan = [[[SettingStore shareStore] getSettings] columnSpan];
                int rowSpan = [[[SettingStore shareStore] getSettings] rowSpam];
                CGSize size = [settings getCharSizeEN:myFont];
                
                CGFloat X = leftMargin + (size.width+columnSpan) * line.curPoint.x;
                CGFloat Y = topMargin + (size.height+rowSpan) * line.curPoint.y;
                
                //            NSLog(@"Y : %d, BGcolor=%@, \tfgColor=%@, string=%@", (int)line.curPoint.y, bgColor, fgColor, line.curString);
                //            CGSize s = [line.curString sizeWithFont:myFont];
                CGSize s = CGSizeMake(size.width * (line.curCaretPos.x - line.curPoint.x), size.height);
                CGRect textRect = CGRectMake(X+mView.frame.origin.x, Y+mView.frame.origin.y, s.width, s.height);
                
                textView = [[UITextField alloc] initWithFrame:textRect];
                [textView setText:@"kjsdhfkjsdhfkjdsf"];
                [self.view addSubview:textView];
                break;
            }
        }
    }
    
}
@end
