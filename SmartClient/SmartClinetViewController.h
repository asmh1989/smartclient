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

@interface SmartClinetViewController : UIViewController <GCDAsyncSocketDelegate, UITextFieldDelegate>
{
    GCDAsyncSocket *socket;
    NSStringEncoding enc;
    ParserMsg *parser;
}
@property (weak, nonatomic) IBOutlet VTSystemView *mView;

@property (strong, nonatomic) UITextField *textView;

@end
