//
//  MessageBox.h
//  SmartClient
//
//  Created by sun on 13-10-28.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageBox : NSObject
{
    void (^sendResult)(void);
}

@property (nonatomic) NSMutableDictionary *map;

-(UIAlertView *) createDialog:(int) buttonType DefButtonType:(int)defaultButtonType;
@end
