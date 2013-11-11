//
//  MessageBox.h
//  SmartClient
//
//  Created by sun on 13-10-28.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

enum MessageBox{
    Message,
    MessageOption,
    MEssageSendImage
};

@interface MessageBox : NSObject
{
}

@property (nonatomic) NSMutableDictionary *map;
@property (nonatomic) enum MessageBox messageType;

-(UIAlertView *) createDialog:(int) buttonType DefButtonType:(int)defaultButtonType;
-(UIAlertView *) createDialog:(NSString *)msg Options:(NSDictionary *)options;
-(UIAlertView *) createDialog:(NSString *)title;
@end
