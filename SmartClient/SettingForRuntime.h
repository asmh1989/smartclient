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

#define ESC 0x1b
#define CUSACTIVE(N)                [NSString stringWithFormat:@"%c%@",ESC,N]
#define CUSACTIVE_MSGBOX            CUSACTIVE(@"<MSGBOX >")
#define CUSACTIVE_MSGBOX_SEND       CUSACTIVE(@"<MSGBOX ")
#define CUSACTIVE_GPS               CUSACTIVE(@"<GPS >")
#define CUSACTIVE_GPS_SEND          CUSACTIVE(@"<GPS ")
#define CUSACTIVE_CAM               CUSACTIVE(@"<CAM >")
#define CUSACTIVE_CAM_SEND          CUSACTIVE(@"<CAM ")
#define CUSACTIVE_WEB               CUSACTIVE(@"<WEB >")
#define CUSACTIVE_CLICK_SEND        CUSACTIVE(@"<CLICK ")
#define CUSACTIVE_OPTIONDIALOG      CUSACTIVE(@"<OPTDLG >")
#define CUSACTIVE_VOICE             CUSACTIVE(@"<VOICE >")

#define CUSACTIVE_IMG               @""
#define CUSACTIVE_MSG               @""
#define CUSACTIVE_WAV               @""
#define CUSACTIVE_SIGN              @""


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
@property (nonatomic) CGSize charSizeEN;
@property (nonatomic) CGSize charSizeCN;


+ (SettingForRuntime *)shareStore;
@end
