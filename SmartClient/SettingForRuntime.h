//
//  SettingForRuntime.h
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mode.h"
#import "Chars.h"
#import "CharAttribs.h"
#import "Caret.h"



@interface SettingForRuntime : NSObject

@property (nonatomic) CGPoint caretPreXY;       //当前光标的位置
@property (nonatomic) NSMutableArray *saveCarets;   //保存当前的光标量
@property (nonatomic) Mode *mode;                   //当前模式
@property (nonatomic) Chars *G0;
@property (nonatomic) Chars *G1;
@property (nonatomic) Chars *G2;
@property (nonatomic) Chars *G3;
@property (nonatomic) CharAttribs *charAttribs;
@property (nonatomic) Caret *caret;
@property (nonatomic) Caret *preCaret;

+ (SettingForRuntime *)shareStore;
- (CGSize)getCharSizeCN:(UIFont *) font;
- (CGSize)getCharSizeEN:(UIFont *) font;

@end
