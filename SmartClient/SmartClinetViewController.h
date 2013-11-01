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

@interface SmartClinetViewController : UIViewController <GCDAsyncSocketDelegate, UITextFieldDelegate,
                                    ParserDelegate, UIAlertViewDelegate, VTSystemViewDelegate>
{
    GCDAsyncSocket *socket;
    NSStringEncoding enc;
    ParserMsg *parser;
}
- (IBAction)backgroudTapped:(id)sender;
@property (weak, nonatomic) IBOutlet VTSystemView *mView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) UITextField *textView;

- (void) dispatchMessage:(NSString *)output tag:(long)tag;

@end
