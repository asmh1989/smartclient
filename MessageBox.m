//
//  MessageBox.m
//  SmartClient
//
//  Created by sun on 13-10-28.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "MessageBox.h"

#define _TONSNUMBER(N)           [NSNumber numberWithInt:(int)(N)]
/**
 * 该消息框包含“中止”、“重试”和“忽略”按钮
 */
#define  MessageBoxButtons_AbortRetryIgnore         2
/**
 * 该消息框包含“确定”按钮
 */
#define  MessageBoxButtons_OK                       0
/**
 * 该消息框包含“确定”和“取消”按钮
 */
#define  MessageBoxButtons_OKCancel                 1
/**
 * 该消息框包含“重试”和“取消”按钮
 */
#define  MessageBoxButtons_RetryCancel              5
/**
 * 该消息框包含“是”和“否”按钮
 */
#define  MessageBoxButtons_YesNo                    4
/**
 * 该消息框包含“是”、“否”和“取消”按钮
 */
#define  MessageBoxButtons_YesNoCancel              3

#define  MessageBoxDefaultButton_Button1            0
#define  MessageBoxDefaultButton_Button2            256
#define  MessageBoxDefaultButton_Button3            512
#define  MessageBoxDefaultButton_NoDefault          1024

/**
 * 返回值是 Abort（通常由标签为“中止”的按钮发送）
 */
#define  MessageBoxShowResult_Abort                 _TONSNUMBER(0)
/**
 * 返回值是 Cancel（通常由标签为“取消”的按钮发送）
 */
#define  MessageBoxShowResult_Cancel                _TONSNUMBER(1)
/**
 * 返回值是 Ignore（通常由标签为“忽略”的按钮发送）
 */
#define  MessageBoxShowResult_Ignore                _TONSNUMBER(2)
/**
 * 返回值是 No（通常由标签为“否”的按钮发送）
 */
#define  MessageBoxShowResult_No                    _TONSNUMBER(3)
/**
 * 返回了 Nothing
 */
#define  MessageBoxShowResult_None                  _TONSNUMBER(4)
/**
 * 返回值是 OK（通常由标签为“确定”的按钮发送）
 */
#define  MessageBoxShowResult_OK                    _TONSNUMBER(5)
/**
 * 返回值是 Retry（通常由标签为“重试”的按钮发送）
 */
#define  MessageBoxShowResult_Retry                 _TONSNUMBER(6)
/**
 * 返回值是 Yes（通常由标签为“是”的按钮发送）
 */
#define  MessageBoxShowResult_Yes                   _TONSNUMBER(7)

@implementation MessageBox

@synthesize map, messageType;

- (id)init
{
    self = [super init];
    if (self) {
        self.map = [[NSMutableDictionary alloc]init];
        messageType = Message;
    }
    return self;
}
- (UIAlertView *)createDialog:(int)buttonType DefButtonType:(int)defaultButtonType
{
    NSMutableDictionary *titleBtn = [[NSMutableDictionary alloc] init];
    messageType = Message;
    [map removeAllObjects];
    switch(buttonType){
		case MessageBoxButtons_OK:
            [titleBtn setObject:@"确定" forKey:_TONSNUMBER(0)];
            [map setObject:MessageBoxShowResult_OK forKey:_TONSNUMBER(0)];
            break;
		case MessageBoxButtons_AbortRetryIgnore:
            [titleBtn setObject:@"中止" forKey:_TONSNUMBER(0)];
            [titleBtn setObject:@"重试" forKey:_TONSNUMBER(1)];
            [titleBtn setObject:@"忽略" forKey:_TONSNUMBER(2)];
            
            [map setObject:MessageBoxShowResult_Abort forKey:_TONSNUMBER(0)];
            [map setObject:MessageBoxShowResult_Retry forKey:_TONSNUMBER(1)];
            [map setObject:MessageBoxShowResult_Ignore forKey:_TONSNUMBER(2)];
			break;
		case MessageBoxButtons_OKCancel:
            [titleBtn setObject:@"确定" forKey:_TONSNUMBER(0)];
            [titleBtn setObject:@"取消" forKey:_TONSNUMBER(1)];
            
            [map setObject:MessageBoxShowResult_OK forKey:_TONSNUMBER(0)];
            [map setObject:MessageBoxShowResult_Cancel forKey:_TONSNUMBER(1)];
			break;
		case MessageBoxButtons_RetryCancel:
            [titleBtn setObject:@"重试" forKey:_TONSNUMBER(0)];
            [titleBtn setObject:@"取消" forKey:_TONSNUMBER(1)];
            [map setObject:MessageBoxShowResult_Retry forKey:_TONSNUMBER(0)];
            [map setObject:MessageBoxShowResult_Cancel forKey:_TONSNUMBER(1)];
			break;
		case MessageBoxButtons_YesNo:
            [titleBtn setObject:@"是" forKey:_TONSNUMBER(0)];
            [titleBtn setObject:@"否" forKey:_TONSNUMBER(1)];
            [map setObject:MessageBoxShowResult_Yes forKey:_TONSNUMBER(0)];
            [map setObject:MessageBoxShowResult_No forKey:_TONSNUMBER(1)];
			break;
		case MessageBoxButtons_YesNoCancel:
            [titleBtn setObject:@"是" forKey:_TONSNUMBER(0)];
            [titleBtn setObject:@"否" forKey:_TONSNUMBER(1)];
            [titleBtn setObject:@"取消" forKey:_TONSNUMBER(2)];
            [map setObject:MessageBoxShowResult_Yes forKey:_TONSNUMBER(0)];
            [map setObject:MessageBoxShowResult_No forKey:_TONSNUMBER(1)];
            [map setObject:MessageBoxShowResult_Cancel forKey:_TONSNUMBER(2)];
			break;
    }
    
    /*
     switch(defButtonType){
     case MessageBoxDefaultButton_Button1:
     break;
     case MessageBoxDefaultButton_Button2:
     break;
     case MessageBoxDefaultButton_Button3:
     break;
     case MessageBoxDefaultButton_NoDefault:
     break;
     }
     */
    NSArray *sortKey = [[titleBtn allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                        {
                            int v1 = [obj1 intValue];
                            int v2 = [obj2 intValue];
                            if (v1 < v2)
                                return NSOrderedAscending;
                            else if (v1 > v2)
                                return NSOrderedDescending;
                            else
                                return NSOrderedSame;
                        }];
    UIAlertView *view;
    int len = (int)[sortKey count];
    if (len == 1) {
        NSString * str = [titleBtn objectForKey:sortKey[0]];

            view = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:str otherButtonTitles: nil];
    } else if (len == 2) {
        NSString * str = [titleBtn objectForKey:sortKey[0]];
        NSString * str2 = [titleBtn objectForKey:sortKey[1]];

        view = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:str otherButtonTitles:str2, nil];
    } else if(len == 3) {
        NSString * str = [titleBtn objectForKey:sortKey[0]];
        NSString * str2 = [titleBtn objectForKey:sortKey[1]];
        NSString * str3 = [titleBtn objectForKey:sortKey[2]];
        
        view = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:str otherButtonTitles:str2, str3, nil];
    }

    return view;
}

- (UIAlertView *)createDialog:(NSString *)msg Options:(NSDictionary *)options
{
    messageType = MessageOption;
    UIAlertView *view;
    int len = (int)[options count];
    NSArray *sortKey = [options allKeys];
    if (len == 1) {
        NSString * str = [options objectForKey:sortKey[0]];
        
//        [map setObject:sortKey[0] forKey:_TONSNUMBER(0)];
        view = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:str otherButtonTitles: nil];
    } else if (len == 2) {
        NSString * str = [options objectForKey:sortKey[0]];
        NSString * str2 = [options objectForKey:sortKey[1]];
        
//        [map setObject:sortKey[0] forKey:_TONSNUMBER(0)];
//        [map setObject:sortKey[1] forKey:_TONSNUMBER(1)];
        view = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:str otherButtonTitles:str2, nil];
    } else if(len == 3) {
        NSString * str = [options objectForKey:sortKey[0]];
        NSString * str2 = [options objectForKey:sortKey[1]];
        NSString * str3 = [options objectForKey:sortKey[2]];
        
//        [map setObject:sortKey[0] forKey:_TONSNUMBER(0)];
//        [map setObject:sortKey[1] forKey:_TONSNUMBER(1)];
//        [map setObject:sortKey[2] forKey:_TONSNUMBER(2)];
        view = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:str otherButtonTitles:str2, str3, nil];
    }
    return view;
}

- (UIAlertView *)createDialog:(NSString *)title
{
    messageType = MEssageSendImage;
    UIAlertView *view;
    view = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil)  otherButtonTitles:NSLocalizedString(@"ImageFromLibrary", nil),NSLocalizedString(@"ImageFromCamera", nil) , nil];
    
    return view;
}
@end
