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


@interface SmartClinetViewController ()
{
    MessageBox *box;
    NSString *hostip;
    int hostPort;
    CameraImage *cameraImage;
}

@property (nonatomic) SettingForRuntime *settings;
@property (nonatomic) SettingForConnect *settingStore;
@property (nonatomic) StringShowList *stringShowList;
@property (nonatomic, copy) NSString *outBuff;
@property (strong, nonatomic) UITextField *textView;
@property (strong, nonatomic) UIView *textUIView;

- (void) sendDataToSocket:(NSString *)output tag:(long)tag;
- (void) sendFirstConnectInfo;
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
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSLog(@" SmartClinetViewController  viewWillAppear....");
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:settingStore.isFullScreen];
    if (settingStore.isFullScreen) {
        mView.frame= self.view.frame;
    } else {
        if (OSVersionIsAtLeastiOS7()) {
            CGRect frame = self.view.frame;
            frame.origin.y = 20;
            mView.frame = frame;
        }

    }
    
    toolBar.frame = CGRectMake(0.0, self.view.frame.size.height - toolBar.frame.size.height-mView.frame.origin.y, toolBar.frame.size.width, toolBar.frame.size.height);
    
    [mView setNeedsDisplay];
    if (hostPort != [settingStore hostPort] || ![hostip isEqualToString:[settingStore hostIp]]) {
//        [parser reset];
        [socket disconnect];
        [self sendFirstConnectInfo];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [self.mView setNeedsDisplay];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.mView setNeedsDisplay];
}

- (IBAction)clickToolBarSetting:(id)sender
{
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)clickToolBarUp:(id)sender
{
    [self dispatchMessage:MYKEY_UP tag:1];
}

- (IBAction)clickToolBarDown:(id)sender
{
    [self dispatchMessage:MYKEY_DOWN tag:1];
}

- (IBAction)clickToolBarCode:(id)sender
{

}

- (IBAction)clickToolBarEnter:(id)sender
{
    [self dispatchMessage:MYKEY_ENTER tag:1];
}

-(void)hidenKeyboard
{
    [self.textView resignFirstResponder];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:
                                 [UIImage imageNamed:@"Setting_Image.png"] style:UIBarButtonItemStyleBordered
                                                               target:nil action:@selector(clickToolBarSetting:)];
    UIBarButtonItem *up = [[UIBarButtonItem alloc] initWithImage:
                                 [UIImage imageNamed:@"Up_Image.png"] style:UIBarButtonItemStyleBordered
                                                                target:nil action:@selector(clickToolBarUp:)];
    UIBarButtonItem *down = [[UIBarButtonItem alloc] initWithImage:
                                 [UIImage imageNamed:@"Down_Image.png"] style:UIBarButtonItemStyleBordered
                                                                target:nil action:@selector(clickToolBarDown:)];
    UIBarButtonItem *code = [[UIBarButtonItem alloc] initWithImage:
                                 [UIImage imageNamed:@"Code_Image.png"] style:UIBarButtonItemStyleBordered
                                                                target:nil action:@selector(clickToolBarCode:)];
    UIBarButtonItem *enter = [[UIBarButtonItem alloc] initWithImage:
                                 [UIImage imageNamed:@"Enter_Image.png"] style:UIBarButtonItemStyleBordered
                                                                target:nil action:@selector(clickToolBarEnter:)];
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [ self.toolBar setItems:[NSArray arrayWithObjects:flexItem, setting, flexItem, up, flexItem, down, flexItem, code, flexItem, enter, flexItem, nil]];
    
    // Do any additional setup after loading the view from its nib.
    textUIView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320,416)];
    textView = [[UITextField alloc] init];
//    [textUIView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.1]];
    [textUIView addSubview:textView];
    [self.mView addSubview:textUIView];
    
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self sendFirstConnectInfo];
    [mView setDelegate:self];
    
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
//    gesture.numberOfTapsRequired = 1;
//    
//    [self.mView addGestureRecognizer:gesture];
    
    if(IOS_VERSION<5.0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillHideNotification object:nil];
    }else{
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
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
            return;
        }
    }
    
    [textView setHidden: YES];
}

- (void)handleTouchMessage:(NSString *)msg
{
    [self hidenKeyboard];
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 270, 180)];
    
    [imageView setImage:image];
    
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    [demoView addSubview:imageView];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setContainerView:demoView];
    
    alertView.buttonTitles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Cancel", nil), NSLocalizedString(@"Send", nil), nil];
    
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
//        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
        if (buttonIndex == 1) {
            CGSize size2 = image.size;
            BOOL hw = size2.height > size2.width ;
            int top = hw ? size2.height : size2.width;
            int scaled = 1;
            while (top > 800) {
                top /= 2;
                scaled *= 2;
            }
            
            UIImage *newImage = [self imageWithImage:image scaledToSize:CGSizeMake(size2.width/scaled, size2.height/scaled)];
            
            NSData *data = UIImagePNGRepresentation(newImage);
            [cameraImage clearCameraImage];
            int len = [data length];
            int currentBufferPos = 0;
            int curretnBufferIndex = 1;
            while (currentBufferPos < len) {
                NSData *d;
                if (len - currentBufferPos > 4*1024) {
                    d = [data subdataWithRange:NSMakeRange(currentBufferPos, 4*1024)];
                    currentBufferPos += 4*1024;
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
@end
