//
//  ShowListEventArgs.h
//  SmartClient
//
//  Created by sun on 13-10-23.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CharAttribs.h"
#import "StringShowList.h"

@interface ShowListEventArgs : NSObject

//当前光标的位置
@property (nonatomic) CGPoint curCaretPos;
//起始的位置
@property (nonatomic) CGPoint curPoint;
//打印的字符
@property (nonatomic, copy) NSString *curString;
//当前字段的显示属性
@property (nonatomic) CharAttribs *curCharAttribute;

//@property (nonatomic) NSMutableDictionary *curChars;

- (id) initShowListEventArgs:(CGPoint) _curPoint  String:(NSString *) _curString CharAttribs: (CharAttribs *) ca Point:(CGPoint) _curCaretPos;

- (ShowListEventArgs*) AddShowList;
@end
