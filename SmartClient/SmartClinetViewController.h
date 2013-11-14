//
//  SmartClinetViewController.h
//  SmartClient
//
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "ParserMsg.h"
#import "VTSystemView.h"

#import "ScanViewController.h"

@interface SmartClinetViewController : UIViewController <GCDAsyncSocketDelegate, UITextFieldDelegate,
                                    ParserDelegate, UIAlertViewDelegate, VTSystemViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ZXingDelegate>
{
    GCDAsyncSocket *socket;
    NSStringEncoding enc;
    ParserMsg *parser;
}


- (void) dispatchMessage:(NSString *)output tag:(long)tag;
- (void) sendExMessage:(NSString *)errorCode Reason:(NSString *)message;
- (void) checkCurrentSocketStatus;

@end
