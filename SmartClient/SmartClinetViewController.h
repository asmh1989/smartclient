//
//  SmartClinetViewController.h
//  SmartClient
//
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"

@interface SmartClinetViewController : UIViewController <GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *socket;
    NSStringEncoding enc;
}

@property (weak, nonatomic) IBOutlet UILabel *content;

@end
