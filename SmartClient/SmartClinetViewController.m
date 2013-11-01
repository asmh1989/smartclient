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
#import "MessageBox.h"
#import "UIViewController+MMDrawerController.h"

@interface SmartClinetViewController ()
{
    MessageBox *box;
    NSString *hostip;
    int hostPort;
}

@property (nonatomic) SettingForRuntime *settings;
@property (nonatomic) SettingForConnect *settingStore;
@property (nonatomic) StringShowList *stringShowList;
@property (nonatomic, copy) NSString *outBuff;

- (void) sendDataToSocket:(NSString *)output tag:(long)tag;
- (void) sendFirstConnectInfo;
@end

@implementation SmartClinetViewController


@synthesize  mView, textView, settings, stringShowList, settingStore, outBuff, toolBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        settingStore = [[SettingStore shareStore] getSettings];
        settings = [SettingForRuntime shareStore];
        stringShowList = [StringShowList shareStore];
        enc = [settingStore enc];
        parser = [[ParserMsg alloc] init];
        outBuff = @"";
        [textView setHidden:YES];
        [parser setDelegate:self];
        box = [[MessageBox alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@" SmartClinetViewController  viewWillAppear....");
    [self.navigationController setNavigationBarHidden:YES];

    [mView setNeedsDisplay];
    if (hostPort != [settingStore hostPort] || ![hostip isEqualToString:[settingStore hostIp]]) {
//        [parser reset];
        [socket disconnect];
        [self sendFirstConnectInfo];
    }
}

- (void)checkCurrentSocketStatus
{
    if (![socket isConnected]) {
        NSError *err = nil;
        if (![socket connectToHost:[settingStore hostIp] onPort:[settingStore hostPort] error:&err]) {
            NSLog(@"Error : %@", err);
        }
//        [socket readDataWithTimeout:-1 tag:1];
        NSLog(@"checkCurrentSocketStatus, and will restart connect socket server");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:
                                 [UIImage imageNamed:@"Setting_Image.png"] style:UIBarButtonItemStyleBordered
                                                                target:nil action:nil];
    UIBarButtonItem *up = [[UIBarButtonItem alloc] initWithImage:
                                 [UIImage imageNamed:@"Up_Image.png"] style:UIBarButtonItemStyleBordered
                                                                target:nil action:nil];
    UIBarButtonItem *down = [[UIBarButtonItem alloc] initWithImage:
                                 [UIImage imageNamed:@"Down_Image.png"] style:UIBarButtonItemStyleBordered
                                                                target:nil action:nil];
    UIBarButtonItem *code = [[UIBarButtonItem alloc] initWithImage:
                                 [UIImage imageNamed:@"Code_Image.png"] style:UIBarButtonItemStyleBordered
                                                                target:nil action:nil];
    UIBarButtonItem *enter = [[UIBarButtonItem alloc] initWithImage:
                                 [UIImage imageNamed:@"Enter_Image.png"] style:UIBarButtonItemStyleBordered
                                                                target:nil action:nil];
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [ self.toolBar setItems:[NSArray arrayWithObjects:flexItem, setting, flexItem, up, flexItem, down, flexItem, code, flexItem, enter, flexItem, nil]];
    
    
    // Do any additional setup after loading the view from its nib.
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self sendFirstConnectInfo];
    [mView setDelegate:self];
}

- (void)sendFirstConnectInfo
{
    NSError *err = nil;
    hostip = [NSString stringWithString:[settingStore hostIp]];
    hostPort = [settingStore hostPort];
    
    [parser parserString:[NSString stringWithFormat:@"[47m[30m[2JH[?25l[1;1H正在连接%@...[1;25H", hostip]];
    [mView setNeedsDisplay];
    
    NSString *deviceId =[settingStore deviceID];
    NSString *os = [[UIDevice currentDevice] systemName];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
//    NSLog(@"connect ip = %@, port = %d, deviceID = %@", hostip, hostPort, deviceId);
    
    if (![socket connectToHost:hostip onPort:hostPort error:&err]) {
        NSLog(@"Error : %@", err);
    }
    
    NSString *setStr = [NSString stringWithFormat:@"%c<SET ID=\"%@\" RFID=\"False\" Gps=\"False\" CAM=\"True\" MSGBOX=\"True\" OptionDialog=\"True\" OS=\"%@\" OSVersion=\"%@\" />", (char)0x1b,deviceId, os, version];
    NSLog(@"first send : %@", setStr);
    
    [self sendDataToSocket:setStr tag:1];

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
    if ([msg length] != 7  && [msg length] != 6) {           //去除单独设置光标
        [mView setNeedsDisplay];
    }
    [textView setText:@""];
    msg = nil;
    [self showTextView];
    [sock readDataWithTimeout:-1 tag:tag];

}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didReadPartialDataOfLength... %ld", tag);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    NSLog(@"didWriteDataWithTag...tag = %ld", tag);
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


//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    NSLog(@"textFieldDidBeginEditing text = %@", [textField text]);
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSLog(@"textFieldDidBeginEditing text = %@", [textField text]);
//}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    NSLog(@"textFieldShouldBeginEditing text = %@", [textField text]);
//    return YES;
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    NSLog(@"textFieldShouldEndEditing text = %@", [textField text]);
//    return YES;
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSLog(@"shouldChangeCharactersInRange text = %@, string = %@", [textField text], string);
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn...");
    NSString *str = [textView text];
    [self dispatchMessage:str tag:2];
    [textField resignFirstResponder];
    [self dispatchMessage:MYKEY_ENTER tag:1];
    
    return YES;
}

-(void)sendExMessage:(NSString *)errorCode Reason:(NSString *)message
{
    [socket disconnect];
    [self sendFirstConnectInfo];
}

- (void)dispatchMessage:(NSString *)output tag:(long)tag
{
    if ([output length] < 1) {
        return;
    }
    
    if (parser.XOFF) {
        output = [output stringByAppendingString:output];
        return;
    }
    
    if ([socket isConnected]) {
        NSLog(@"dispatchMessage str=%@, tag=%ld", output, tag);
        NSString *str = @"";
        if (![self.outBuff  isEqual: @""]) {
            str = [outBuff stringByAppendingString:output];
            outBuff = @"";
        } else {
            str = output;
        }
        
        [self sendDataToSocket:str tag:tag];
    }
    
}

- (void) showTextView
{
    CGFloat y = settings.caret.pos.y;
    CGFloat x = settings.caret.pos.x;
    
    for (id obj in stringShowList.inputStrings) {
        CGRect r = [obj CGRectValue];
        if (y == r.origin.y   && x >= r.origin.x && x < (r.origin.x + r.size.width)) {
            UIFont *myFont = [UIFont boldSystemFontOfSize:[settingStore fontSize]];
            int leftMargin = [settingStore leftMargin];
            int topMargin = [settingStore topMargin];
            int columnSpan = [settingStore columnSpan];
            int rowSpan = [settingStore rowSpam];
            CGSize size = [settings getCharSizeEN:myFont];
            
            CGFloat X = leftMargin + (size.width+columnSpan) * r.origin.x;
            CGFloat Y = topMargin + (size.height+rowSpan) * r.origin.y;
            
            CGSize s = CGSizeMake(size.width * r.size.width, size.height);
            CGRect textRect = CGRectMake(X+mView.frame.origin.x, Y+mView.frame.origin.y, s.width, s.height);
            [textView removeFromSuperview];
            textView = [[UITextField alloc] initWithFrame:textRect];
            [textView setFont:myFont];
            [textView setDelegate:self];
            [self.view addSubview:textView];
            [textView setHidden:NO];
//            [textView setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]]; //隐藏光标
//            [textView setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]]; //隐藏textview的输入内容
            return;
        }
    }
    
    [textView setHidden: YES];
}

- (void)handleTouchMessage:(NSString *)msg
{
    [self dispatchMessage:msg tag:3];
}

- (void)sendDataToSocket:(NSString *)output tag:(long)tag
{
    NSData *data = [output dataUsingEncoding:enc];
    
    [socket writeData:data withTimeout:-1 tag:tag];
    
    data = nil;
}

- (NSString *)getMessageBoxString:(NSString *)str param:(NSString *)param
{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    int pos1=(int)[msg rangeOfString:param].location+1;
    msg = [msg substringWithRange:NSMakeRange(pos1, [msg length] - pos1)];
    int pos2=(int)[msg rangeOfString:@"\""].location+1;
    msg = [msg substringWithRange:NSMakeRange(pos2, [msg length] - pos2)];
    int pos3=(int)[msg rangeOfString:@"\""].location;
    
    return [msg substringWithRange:NSMakeRange(0, pos3)];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButtonAtIndex %ld", (long)buttonIndex);
    NSDictionary *dic = [box map];
    NSString *msg = [dic objectForKey:_TOSTRIING(buttonIndex)];
    msg = [NSString stringWithFormat:@"%@%@%@%@", CUSACTIVE_MSGBOX_SEND, @" Result=\"", msg, @"\" />"];
    [self dispatchMessage:msg tag:1];
}

- (void)HandlerMessageBoxHandler:(NSString *)param
{
    if(param){
        NSString *msgStr=@"";
        int buttonType=0;
        int defButtonType=0;
    
        if([param rangeOfString:@"Message"].location != NSNotFound)
        {
            msgStr = [self getMessageBoxString:param param:@"Message"];
            msgStr=[msgStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }else{
            [self dispatchMessage:[NSString stringWithFormat:@"%@%@",CUSACTIVE_MSGBOX_SEND, @" Result=\"-1\" />"] tag:1];
            return;
        }
    
        if([param rangeOfString:@"Buttons"].location != NSNotFound)
        {
            buttonType = [[self getMessageBoxString:param param:@"Buttons"] intValue];
        }
        else
        {
            [self dispatchMessage:[NSString stringWithFormat:@"%@%@",CUSACTIVE_MSGBOX_SEND, @" Result=\"-1\" />"] tag:1];
            return;
        }

        if([param rangeOfString:@"DefaultButton"].location != NSNotFound)
        {
            defButtonType = [[self getMessageBoxString:param param:@"DefaultButton"] intValue];
        }
        else
        {
            [self dispatchMessage:[NSString stringWithFormat:@"%@%@",CUSACTIVE_MSGBOX_SEND, @" Result=\"-1\" />"] tag:1];
            return;
        }
        
        [box.map removeAllObjects];
        UIAlertView *alert = [box createDialog:buttonType DefButtonType:defButtonType];
        [alert setDelegate:self];
        [alert setMessage:msgStr];
        [alert show];
    }
}

- (void)HandlerCAMHandler:(NSString *)param
{
    if (param) {
        int readMode = -1;
        if([param rangeOfString:@"ReadMode"].location != NSNotFound)
        {
            readMode = [[self getMessageBoxString:param param:@"ReadMode"] intValue];
            if (readMode == 1) {
                //open camera
            }
        } else if([param rangeOfString:@"GetData"].location != NSNotFound)
        {
            NSString *getDataIndex = [self getMessageBoxString:param param:@"GetData"];
            // start send image
        }
    }
}

- (void)HandlerGpsLocationHandler:(NSString *)param
{
    
}

- (void)HandlerWEBHandler:(NSString *)param
{
    
}

- (void)HandlerOptionDialogHandler:(NSString *)param
{
    
}

- (void)HandlerVoiceHandler:(NSString *)param
{
    
}

- (void)VTProtocolExtend:(NSString *)vtProtocol Message:(NSString *)msg
{
//    NSLog(@"VTProtocolExtend vtvtProtocol = %@, Message = %@", vtProtocol, msg);
    if ([vtProtocol isEqualToString:CUSACTIVE_MSGBOX])
    {
        [self HandlerMessageBoxHandler:msg];
    }
    else if([vtProtocol isEqualToString:CUSACTIVE_CAM])
    {
        [self HandlerCAMHandler:msg];
    }
    else if([vtProtocol isEqualToString:CUSACTIVE_GPS])
    {//cusActive_GPS)){
        [self HandlerGpsLocationHandler:msg];
    }
    else if([vtProtocol isEqualToString:CUSACTIVE_WEB])
    {
        [self HandlerWEBHandler:msg];
    }
    else if([vtProtocol isEqualToString:CUSACTIVE_OPTIONDIALOG])
    {
        [self HandlerOptionDialogHandler:msg];
    }
    else if([vtProtocol isEqualToString:CUSACTIVE_VOICE])
    {
        [self HandlerVoiceHandler:msg];
    }
}

@end
