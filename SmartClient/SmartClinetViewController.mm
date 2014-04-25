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
#import "StringForNSUserDefaults.h"
#import "CameraImage.h"
#import "CustomIOS7AlertView.h"
#import "MMDrawerBarButtonItem.h"
#import "RKTabView.h"

#import "IconArgs.h"
#import "ListFormArgs.h"
#import "LineArgs.h"
#import "InfobarArgs.h"
#import "InputArgs.h"
#import "ToolbarArgs.h"

#import <QRCodeReader.h>
#import <DataMatrixReader.h>
#import <MultiFormatOneDReader.h>
#import <MultiFormatReader.h>
#import <MultiFormatUPCEANReader.h>


@interface SmartClinetViewController ()
{
    MessageBox *box;
    NSString *hostip;
    int hostPort;
    CameraImage *cameraImage;
    UIView *infobar;
    UILabel *infobarText;
    UILabel *navTitle;
    NSMutableArray *myToolbars;
}

@property (nonatomic) SettingForRuntime *settings;
@property (nonatomic) SettingForConnect *settingStore;
@property (nonatomic) StringShowList *stringShowList;
@property (nonatomic, copy) NSString *outBuff;
@property (strong, nonatomic) UITextField *textView;
@property (strong, nonatomic) UIView *textUIView;
@property (strong, nonatomic) RKTabView *toolBar;
@property (strong, nonatomic) VTSystemView *mView;


- (void) sendDataToSocket:(NSString *)output tag:(long)tag;
- (void) sendFirstConnectInfo;
- (void) showInfoBar;
- (void) hideInfoBar;
@end

@implementation SmartClinetViewController


@synthesize  mView, textView, settings, stringShowList, settingStore, outBuff, toolBar;

@synthesize textUIView;

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
        __unsafe_unretained __block SmartClinetViewController *safeSelf = self;
        cameraImage = [[CameraImage alloc] init];
        [cameraImage setSendImageData:^(NSString *str) {
            [safeSelf dispatchMessage:str tag:1];
        }];
        myToolbars = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setRestorationIdentifier:@"MMSmartCenterControllerRestorationKey"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RKTabItem *backItem = [RKTabItem createUsualItemWithImageEnabled:nil imageDisabled:[UIImage imageNamed:@"vt_back.png"]];
    backItem.titleString = @"返回";
    
    RKTabItem *enterItem = [RKTabItem createUsualItemWithImageEnabled:nil imageDisabled:[UIImage imageNamed:@"vt_enter.png"]];
    enterItem.titleString = @"回车";
    
    RKTabItem *upItem = [RKTabItem createUsualItemWithImageEnabled:nil imageDisabled:[UIImage imageNamed:@"vt_up.png"]];
    upItem.titleString = @"向上";
    
    RKTabItem *downItem = [RKTabItem createUsualItemWithImageEnabled:nil imageDisabled:[UIImage imageNamed:@"vt_down.png"]];
    downItem.titleString = @"向下";
    
    RKTabItem *listItem = [RKTabItem createUsualItemWithImageEnabled:nil imageDisabled:[UIImage imageNamed:@"vt_list.png"]];
    listItem.titleString = @"列表";
    
    RKTabItem *playItem = [RKTabItem createUsualItemWithImageEnabled:nil imageDisabled:[UIImage imageNamed:@"vt_play.png"]];
    playItem.titleString = @"播放";
    
    RKTabItem *saveItem = [RKTabItem createUsualItemWithImageEnabled:nil imageDisabled:[UIImage imageNamed:@"vt_save.png"]];
    saveItem.titleString = @"保存";
    
    self.toolBar = [[RKTabView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    self.toolBar.tabItems = @[backItem, enterItem, upItem, downItem, listItem, playItem, saveItem];
    self.toolBar.rightItem = enterItem;
    
    self.toolBar.drawSeparators = YES;
    self.toolBar.horizontalInsets = HorizontalEdgeInsetsMake(0, 0);
    
    [self.toolBar setBackgroundColor:[UIColor whiteColor]];
    

    self.mView = [[VTSystemView alloc] init];
    textUIView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320,416)];
    textView = [[UITextField alloc] init];
    [textUIView addSubview:textView];
    [self.mView addSubview:textUIView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.mView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mView];
    [self.view addSubview:toolBar];

    
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self sendFirstConnectInfo];
    [mView setDelegate:self];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.mView addGestureRecognizer:pinch];
    
    if(IOS_VERSION<5.0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillHideNotification object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    
    infobar = [[UIView alloc] init];
    infobar.frame = CGRectMake(0, self.view.frame.origin.y+self.view.frame.size.height-44-20, self.view.frame.size.width, 20);
    infobar.backgroundColor = [UIColor grayColor];
    infobarText = [[UILabel alloc] init];
    infobarText.frame = CGRectMake(6, 0, infobar.frame.size.width, infobar.frame.size.height);
    
    [infobarText setText:@"this is infobar...."];
    infobarText.textColor = [UIColor blackColor];
    [infobar addSubview:infobarText];
    [self.view addSubview:infobar];
    infobar.alpha = 0;
    
    self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:5*16/255.0F];
}

-(void)setupLeftMenuButton{
    UIImage *img = [UIImage imageNamed:@"logo.png"];
    //    img = [Functions scaleImage:img maxWidth:36 maxHeight:36];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(0, 2, 36, 36);
    imgView.tintColor = [UIColor whiteColor];
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    navTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, 160, 36)];
    navTitle.text = @"SmartCilent";
    navTitle.textColor = [UIColor whiteColor];
    
    [left addSubview:imgView];
    [left addSubview:navTitle];
    UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithCustomView:left];
    [self.navigationItem setLeftBarButtonItem:logo animated:YES];
}

-(void)setupRightMenuButton{
    UIBarButtonItem *code = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Code_Image.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickToolBarCode:)];
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(clickToolBarSetting:)];
    
    [code  setTintColor:[UIColor  whiteColor]];
    [leftDrawerButton  setTintColor:[UIColor  whiteColor]];
    NSArray * item = @[leftDrawerButton, code];
    [self.navigationItem setRightBarButtonItems:item animated:YES];
    //    [self.navigationItem setRightBarButtonItem:code animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [self.settingStore setScreenOrientation:1];
    } else if(UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])){
        [self.settingStore setScreenOrientation:0];
    }
    
    //        NSLog(@"viewWillAppear ... current orientation is = %d", [[UIApplication sharedApplication] statusBarOrientation]);
    
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:settingStore.isFullScreen];
    CGRect frame = self.view.frame;
    if (settingStore.isFullScreen || !OSVersionIsAtLeastiOS7()) {
        frame.origin.y = 44;
        frame.size.height -= 44;
    } else {
        if (OSVersionIsAtLeastiOS7()) {
            frame.origin.y = 20+44;
            frame.size.height -= 20+44;
        }
    }
    mView.frame = frame;
    
    int toolbar_len = 44;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        toolbar_len = 60;
    }
    
    self.toolBar.frame = CGRectMake(0, self.view.frame.size.height-toolbar_len, self.view.frame.size.width, toolbar_len);
    [mView setNeedsDisplay];
    [toolBar setNeedsDisplay];
    if (hostPort != [settingStore hostPort] || ![hostip isEqualToString:[settingStore hostIp]]) {
        //        [parser reset];
        [socket disconnect];
        [self sendFirstConnectInfo];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)checkCurrentSocketStatus
{
    if (![socket isConnected]) {
        NSError *err = nil;
        if (![socket connectToHost:[settingStore hostIp] onPort:[settingStore hostPort] error:&err]) {
            NSLog(@"Error : %@", err);
        }
        NSLog(@"checkCurrentSocketStatus, and will restart connect socket server");
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.toolBar setHidden:YES];
    //    [self.mView setNeedsDisplay];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self viewWillAppear:NO];
    [self.toolBar setHidden:NO];
}


- (IBAction)clickToolBarSetting:(id)sender
{
    [self.mm_drawerController openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (IBAction)clickToolBarUp:(id)sender
{
    [mView setNeedsDisplay];
    [self dispatchMessage:MYKEY_UP tag:1];
}

- (IBAction)clickToolBarDown:(id)sender
{
    [self dispatchMessage:MYKEY_DOWN tag:1];
}

- (IBAction)clickToolBarback:(id)sender
{
    int alpha = (int)(infobar.alpha * 10);
    if(alpha < 1){
        [self showInfoBar];
    } else
    {
        [self hideInfoBar];
    }
    [self dispatchMessage:MYKEY_DEL tag:1];
}

- (IBAction)clickToolBarCode:(id)sender
{
    ScanViewController *widController = [[ScanViewController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    NSMutableSet *readers = [[NSMutableSet alloc] init];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    if ([userDefaultes boolForKey:STR_QR_DECODE] ) {
        QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
        [readers addObject:qrcodeReader];
    }
    if ([userDefaultes boolForKey:STR_RECT_DECODE]){
        DataMatrixReader *dataMatrixReader = [[DataMatrixReader alloc] init];
        [readers addObject:dataMatrixReader];
    }
    if ([userDefaultes boolForKey:STR_ONE_DECODE]) {
        MultiFormatOneDReader *multiFormatOneDReader = [[MultiFormatOneDReader alloc] init];
        [readers addObject:multiFormatOneDReader];
    }
    
    if ([readers count] < 1) {
        QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
        [readers addObject:qrcodeReader];
    }
    widController.readers = readers;
    [self presentViewController:widController animated:YES completion:^{}];
}

- (IBAction)clickToolBarEnter:(id)sender
{
    [self dispatchMessage:MYKEY_ENTER tag:1];
}

-(void)tap:(UITapGestureRecognizer *)gr
{
    //    [self.textView resignFirstResponder];
    NSLog(@"tap...");
    
}

int lastScale;
-(void)pinch:(UIPinchGestureRecognizer *)sender
{
    switch ([sender state]) {
        case UIGestureRecognizerStateBegan:
            lastScale = [[settingStore getCurrentFont] pointSize];
            lastScale = (int)(sender.scale*10);
            break;
        case UIGestureRecognizerStateChanged:
            if ((int)(sender.scale*10) - lastScale > 2) {
                if ([settingStore screenOrientation] == 0) {
                    settingStore.fontSize += 1;
                } else {
                    settingStore.fontSizeLand += 1;
                }
                
                lastScale = (int)(sender.scale*10);
            }  else if(lastScale - (int)(sender.scale*10) > 2){
                if ([settingStore screenOrientation] == 0) {
                    settingStore.fontSize -= 1;
                } else {
                    settingStore.fontSizeLand -= 1;
                }
                
                lastScale = (int)(sender.scale*10);
            }
            [mView setNeedsDisplay];
            break;
        case UIGestureRecognizerStateRecognized:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
    //    NSLog(@"lastScale = %d, sclae = %d,   velocity=%d",lastScale, (int)(sender.scale*10), (int)(sender.velocity*10));
    
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
#else
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
#endif
        CGRect keyboardBounds;
        [keyboardBoundsValue getValue:&keyboardBounds];
        int len =keyboardBounds.origin.y - (textView.frame.origin.y + textView.frame.size.height+mView.frame.origin.y);
        
        if (len > 20) {
            return;
        }
        
        NSInteger offset =20 - len;
        if (keyboardBounds.origin.y == 0 && 160 > (textView.frame.origin.y + textView.frame.size.height+mView.frame.origin.y)) {
            return;
        } else {
            offset = (textView.frame.origin.y + textView.frame.size.height+mView.frame.origin.y) - 160;
        }
        CGRect listFrame = CGRectMake(0, -offset, self.view.frame.size.width,self.view.frame.size.height);
        NSLog(@"offset is %d",offset);
        [UIView beginAnimations:@"anim" context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        //处理移动事件，将各视图设置最终要达到的状态
        
        self.view.frame=listFrame;
        
        [UIView commitAnimations];
        
    }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - socket action

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
    //    if ([msg length] != 7  && [msg length] != 6) {           //去除单独设置光标
    [mView setNeedsDisplay];
    //    }
    //    [textView setText:@""];
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


#pragma mark - textField Action

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    NSLog(@"textFieldDidBeginEditing text = %@", [textField text]);
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing text = %@", [textField text]);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    NSLog(@"shouldChangeCharactersInRange text = %@, string = %@", [textField text], string);
    if ([string isEqualToString:@""]) {
        [self dispatchMessage:MYKEY_DEL tag:1];
    } else {
        [self dispatchMessage:string tag:1];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    NSLog(@"textFieldShouldReturn...");
    //    NSString *str = [textView text];
    //    [self dispatchMessage:str tag:2];
    [textField resignFirstResponder];
    [self dispatchMessage:MYKEY_ENTER tag:1];
    [textView setText:@""];
    return YES;
}


#pragma mark - DispatchMessage Action

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
            UIFont *myFont = [settingStore getCurrentFont];
            int leftMargin = [settingStore leftMargin];
            int topMargin = [settingStore topMargin];
            int columnSpan = [settingStore columnSpan];
            int rowSpan = [settingStore rowSpan];
            CGSize size = [settings getCharSizeEN:myFont];
            
            CGFloat X = leftMargin + (size.width+columnSpan) * r.origin.x;
            CGFloat Y = topMargin + (size.height+rowSpan) * r.origin.y;
            
            CGSize s = CGSizeMake(size.width * r.size.width, size.height);
            CGRect textRect = CGRectMake(X, Y, s.width, s.height);
            
            //            [textView removeFromSuperview];
            self.textView.frame = textRect;
            //            [textView setFont:myFont];
            [textView setDelegate:self];
            [self.textView setHidden:NO];
            //            [self.textView becomeFirstResponder];
            [textView setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]]; //隐藏光标
            [textView setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]]; //隐藏textview的输入内容
            [textView setText:@"1234567890"];
            textView.keyboardType = UIKeyboardTypeAlphabet;
            return;
        }
    }
    
    [textView setHidden: YES];
}

- (void)handleTouchMessage:(NSString *)msg
{
    //    [self hidenKeyboard];
    [self.textView resignFirstResponder];
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



- (void)HandlerMessageBoxHandler:(NSString *)param
{
    [cameraImage clearCameraImage];
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
        
        UIAlertView *alert = [box createDialog:buttonType DefButtonType:defButtonType];
        [alert setDelegate:self];
        [alert setMessage:msgStr];
        [alert show];
    }
}

- (void)HandlerOptionDialogHandler:(NSString *)param
{
    if(param){
        NSString *msgStr=@"";
        NSString *restparamStr = @"";
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        if([param rangeOfString:@"Message"].location != NSNotFound)
        {
            NSString *msg = param;
            int pos1=(int)[msg rangeOfString:@"Message"].location+1;
            msg = [msg substringWithRange:NSMakeRange(pos1, [msg length] - pos1)];
            int pos2=(int)[msg rangeOfString:@"\""].location+1;
            msg = [msg substringWithRange:NSMakeRange(pos2, [msg length] - pos2)];
            int pos3=(int)[msg rangeOfString:@"\""].location;
            
            msgStr =  [msg substringWithRange:NSMakeRange(0, pos3)];
            restparamStr =[ msg substringFromIndex:pos3];
            
        }
        
        while (([restparamStr rangeOfString:@"="].location != NSNotFound)) {
            NSString *msg = restparamStr;
            int key = 0;
            int pos1=(int)[msg rangeOfString:@"="].location+1;
            key = [[msg substringWithRange:NSMakeRange(1, pos1 - 2)] intValue];
            msg = [msg substringWithRange:NSMakeRange(pos1, [msg length] - pos1)];
            int pos2=(int)[msg rangeOfString:@"\""].location+1;
            msg = [msg substringWithRange:NSMakeRange(pos2, [msg length] - pos2)];
            int pos3=(int)[msg rangeOfString:@"\""].location;
            
            NSString *obj =  [msg substringWithRange:NSMakeRange(0, pos3)];
            [dic setObject:obj forKey:_TOSTRIING(key)];
            restparamStr =[ msg substringFromIndex:pos3];
        }
        
        UIAlertView *alert = [box createDialog:msgStr Options:dic];
        [alert setDelegate:self];
        [alert setMessage:msgStr];
        [alert show];
    }
}

- (void)takePictureFromCamera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    //    [imagePicker setAllowsEditing:YES];
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void) takePictureFromLibrary
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    //    [imagePicker setAllowsEditing:YES];
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (NSString*)URLencode:(NSString *)originalString
        stringEncoding:(NSStringEncoding)stringEncoding {
    //!  @  $  &  (  )  =  +  ~  `  ;  '  :  ,  /  ?
    //%21%40%24%26%28%29%3D%2B%7E%60%3B%27%3A%2C%2F%3F
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                            @"@" , @"&" , @"=" , @"+" ,    @"$" , @"," ,
                            @"!", @"'", @"(", @")", @"*", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F", @"%3F" , @"%3A" ,
                             @"%40" , @"%26" , @"%3D" , @"%2B" , @"%24" , @"%2C" ,
                             @"%21", @"%27", @"%28", @"%29", @"%2A", nil];
    
    int len = [escapeChars count];
    
    NSMutableString *temp = [[originalString
                              stringByAddingPercentEscapesUsingEncoding:stringEncoding]
                             mutableCopy];
    
    int i;
    for (i = 0; i < len; i++) {
        
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    NSString *outStr = [NSString stringWithString: temp];
    
    return outStr;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    UIImageAlertView *alert = [[UIImageAlertView alloc] initWithImage:image title:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send"];
    
    CGSize size;
    if (image.size.width > image.size.height) {
        size.width = self.view.frame.size.width*2/3;
        size.height = size.width*image.size.height / image.size.width;
    } else {
        size.height = self.view.frame.size.height/2;
        size.width = size.height*image.size.width / image.size.height;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, size.width, size.height)];
    
    [imageView setImage:image];
    
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width + 20, size.height + 20)];
    
    [demoView addSubview:imageView];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setContainerView:demoView];
    
    alertView.buttonTitles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Cancel", nil), NSLocalizedString(@"Send", nil), nil];
    
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        //        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
        if (buttonIndex == 1) {
            NSData *data;
            int type = [settingStore pictureType];
            int quality = [settingStore pictureQuality];
            if (type == 0) { // jpeg
                data = UIImageJPEGRepresentation(image, 1.0 / (quality + 2));
            } else if(type == 1){ //png
                int scaled = 1+quality+2;
                UIImage *newImage = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width/scaled, image.size.height/scaled)];
                data = UIImagePNGRepresentation(newImage);
            }
            
            
            [cameraImage clearCameraImage];
            int len = [data length];
            int currentBufferPos = 0;
            int curretnBufferIndex = 1;
            while (currentBufferPos < len) {
                NSData *d;
                int oneTimeSize = ([settingStore pictureTimeSize] + 1) * 2048;
                if (len - currentBufferPos > oneTimeSize) {
                    d = [data subdataWithRange:NSMakeRange(currentBufferPos, oneTimeSize)];
                    currentBufferPos += oneTimeSize;
                } else {
                    d = [data subdataWithRange:NSMakeRange(currentBufferPos, len - currentBufferPos)];
                    currentBufferPos = len;
                }
                NSString *str = [d base64Encoding];
                //                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                str = [self URLencode:str stringEncoding:NSUTF8StringEncoding];
                [cameraImage addCameraImage:[NSNumber numberWithInt:curretnBufferIndex] Value:str];
                curretnBufferIndex += 1;
            }
            [self dispatchMessage:[NSString stringWithFormat:@"%@%@%d%@", CUSACTIVE_CAM_SEND, @" Result=\"1\" Size=\"", [cameraImage getCmaeraImageSize], @"\" />"] tag:1];
        }
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    [alertView show];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) takePicture
{
    UIAlertView *alertView = [box createDialog:@"Image"];
    alertView.delegate = self;
    [alertView show];
    
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
                
                [self takePicture];
            }
        } else if([param rangeOfString:@"GetData"].location != NSNotFound)
        {
            NSString *getDataIndex = [self getMessageBoxString:param param:@"GetData"];
            NSNumber *index = [NSNumber numberWithInt:[getDataIndex intValue]];
            [cameraImage sendCameraImage:index];
        }
    }
}

- (void)HandlerGpsLocationHandler:(NSString *)param
{
    
}

- (void)HandlerWEBHandler:(NSString *)param
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
    else
    {
        NSString *xml = [NSString stringWithFormat:@"%@%@%@",@"<param><msg ", msg, @"></param>"];
        NSDictionary *result = [Functions getXMLAttrs:xml xpath:@"msg"];
        
        if(result == nil && result.count == 0){
            return;
        }
        if ([vtProtocol isEqualToString:CUSACTIVE_TITLE])
        {
            navTitle.text = [result objectForKey:@"Text"];
        }
        else if ([vtProtocol isEqualToString:CUSACTIVE_ICON])
        {
            IconArgs *args = [[IconArgs alloc] init];
            args.Iconid = [Functions getRightValueFromDict:result key:@"ID" defValue:@""];//[result objectForKey:@"ID"];
            NSString *col = [Functions getRightValueFromDict:result key:@"Color" defValue:@"255255255"];//[result objectForKey:@"Color"];
            args.color = [Functions getColorFromRGB:col];
            args.X = [[Functions getRightValueFromDict:result key:@"X" defValue:@"0"] intValue];
            args.Y = [[Functions getRightValueFromDict:result key:@"Y" defValue:@"0"] intValue];
            args.width = [[Functions getRightValueFromDict:result key:@"Width" defValue:@"0"] intValue];
            args.height = [[Functions getRightValueFromDict:result key:@"Height" defValue:@"0"] intValue];
            [[[self stringShowList] iconDict] setObject:args forKey:[NSString stringWithFormat:@"%@%d%d", args.Iconid, args.X, args.Y]];
        }
        else if([vtProtocol isEqualToString:CUSACTIVE_LINE])
        {
            LineArgs *args = [[LineArgs alloc] init];
            args.X = [[Functions getRightValueFromDict:result key:@"X" defValue:@"0"] intValue];
            args.Y = [[Functions getRightValueFromDict:result key:@"Y" defValue:@"0"] intValue];
            args.length = [[Functions getRightValueFromDict:result key:@"Length" defValue:@"0"] intValue];
            args.orientation = [Functions getRightValueFromDict:result key:@"Orientation" defValue:args.orientation];
            NSString *col = [Functions getRightValueFromDict:result key:@"Color" defValue:@"255255255"];
            args.lineColor = [Functions getColorFromRGB:col];
            [[[self stringShowList] lineDict]setObject:args forKey:args.getKey];
        }
        else if([vtProtocol isEqualToString:CUSACTIVE_INPUT])
        {
            InputArgs *args = [[InputArgs alloc] init];
            args.X = [[Functions getRightValueFromDict:result key:@"X" defValue:@"0"] intValue];
            args.Y = [[Functions getRightValueFromDict:result key:@"Y" defValue:@"0"] intValue];
            args.width = [[Functions getRightValueFromDict:result key:@"Width" defValue:@"0"] intValue];
            args.height = [[Functions getRightValueFromDict:result key:@"Height" defValue:@"0"] intValue];
            args.maxLength = [[Functions getRightValueFromDict:result key:@"MaxLength" defValue:@"0"] intValue];
            args.maskChar = [Functions getRightValueFromDict:result key:@"MaskChar" defValue:args.maskChar];
            args.text = [Functions getRightValueFromDict:result key:@"Text" defValue:args.text];
            [[[self stringShowList] lineDict]setObject:args forKey:args.getKey];
        }
        else if([vtProtocol isEqualToString:CUSACTIVE_LIST])
        {
            ListFormArgs *args = [[ListFormArgs alloc] init];
            args.title = [Functions getRightValueFromDict:result key:@"Title" defValue:args.title];
            NSString *data = [Functions getRightValueFromDict:result key:@"Data" defValue:@""];
            if (data.length == 0) {
                NSLog(@"parse listform error");
                return;
            }
            data=[data stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"found listform data = %@", data);
            NSArray *parseData = [Functions getXMLAttrsFromList:data];
            if(!parseData && parseData.count != 2){
                return;
            }
            args.sectionTitle = parseData[0];
            args.listContents = parseData[1];
        }
        else if([vtProtocol isEqualToString:CUSACTIVE_HTML])
        {
            NSString *data = [Functions getRightValueFromDict:result key:@"Data" defValue:@""];
            if(data.length == 0){
                NSLog(@"parse Html error");
                return;
            }
            data=[data stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"found html data = %@", data);
            
        }
        else if([vtProtocol isEqualToString:CUSACTIVE_INFORBAR])
        {
            InfobarArgs *args = [[InfobarArgs alloc] init];
            args.text = [Functions getRightValueFromDict:result key:@"Text" defValue:args.text];
            NSString *col = [Functions getRightValueFromDict:result key:@"ForeColor" defValue:@"255255255"];
            args.fgColor = [Functions getColorFromRGB:col];
            col = [Functions getRightValueFromDict:result key:@"ForeColor" defValue:@"255255255"];
            args.bgColor = [Functions getColorFromRGB:col];
            
            if (args.text.length == 0) {
                [self hideInfoBar];
            }
            else
            {
                infobarText.text = args.text;
                infobar.backgroundColor = args.bgColor;
                infobarText.textColor = args.fgColor;
                [self showInfoBar];
            }
            
        }
        else if([vtProtocol isEqualToString:CUSACTIVE_TOOLBAR])
        {
            ToolbarArgs *args = [[ToolbarArgs alloc] init];
            args.action = [Functions getRightValueFromDict:result key:@"Action" defValue:args.action];
            args.icon = [Functions getRightValueFromDict:result key:@"Icon" defValue:args.icon];
            args.text = [Functions getRightValueFromDict:result key:@"Text" defValue:args.text];
            args.ID = [Functions getRightValueFromDict:result key:@"ID" defValue:args.ID];
            
            if([args.action isEqualToString:@"Clear"])
            {
                [myToolbars removeAllObjects];
            }
            else
            {
                [myToolbars addObject:args];
            }
        }
        
    }
}

+ (void)initialize
{
    NSArray *keys = [[NSArray alloc] initWithObjects:
                     //decode
                     STR_ONE_DECODE, STR_QR_DECODE, STR_RECT_DECODE, STR_SOUND, STR_VIBRATE,
                     //othersetting
                     STR_MAC, STR_LOG, STR_SERIAL,
                     //gps
                     STR_ENABLE_GPS, STR_STARTUP_GPS, STR_GPS_TIME, STR_GPS_DISTANCE,
                     //notification
                     STR_NF_ACTIVE, STR_NF_SOUND, STR_NF_VIBRATE, STR_NF_TIME, STR_NF_SERVER, STR_NF_PORT, STR_NF_USER, STR_NF_PASSWORD,
                     nil];
    
    NSArray *objects = [[NSArray alloc] initWithObjects:
                        [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],
                        [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], @"",
                        [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], @"1", @"1",
                        [NSNumber numberWithBool:YES], @"", [NSNumber numberWithBool:YES],
                        @"5", @"searching-info.com", @"80", @"", @"",
                        nil];
    NSDictionary *defaults = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButtonAtIndex %ld", (long)buttonIndex);
    
    if (box.messageType == Message) {
        NSDictionary *dic = [box map];
        NSString *msg = [dic objectForKey:_TOSTRIING(buttonIndex)];
        msg = [NSString stringWithFormat:@"%@%@%@%@", CUSACTIVE_MSGBOX_SEND, @" Result=\"", msg, @"\" />"];
        [self dispatchMessage:msg tag:1];
    } else if(box.messageType == MessageOption){
        [self dispatchMessage:[NSString stringWithFormat:@"%d", (int)buttonIndex] tag:1];
    } else if(box.messageType == MEssageSendImage){
        if (buttonIndex == 2) {
            [self takePictureFromCamera];
        } else if (buttonIndex == 1){
            [self takePictureFromLibrary];
        } else {
            
        }
    }
}

#pragma mark - ZXingDelegate

- (void)zxingController:(ScanViewController *)controller didScanResult:(NSString *)result
{
    [self dispatchMessage:result tag:1];
    [self dispatchMessage:MYKEY_ENTER tag:1];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)zxingControllerDidCancel:(ScanViewController *)controller
{
    [self dismissViewControllerAnimated:NO completion:^{NSLog(@"cancel!");}];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)hideInfoBar
{
    CGContextRef context = UIGraphicsGetCurrentContext(); //返回当前视图堆栈顶部的图形上下文
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:1.5];
    // View changes go here
    [infobar setAlpha:0.0f];     //设置属性的变换，可以对frame的位置进行变换来实现移动的效果
    [UIView commitAnimations];
}

- (void)showInfoBar
{
    CGContextRef context = UIGraphicsGetCurrentContext(); //返回当前视图堆栈顶部的图形上下文
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:1.5];
    // View changes go here
    [infobar setAlpha:0.8f];     //设置属性的变换，可以对frame的位置进行变换来实现移动的效果
    [UIView commitAnimations];
}

@end
