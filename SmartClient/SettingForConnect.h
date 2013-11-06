//
//  SettingForConnect.h
//  SmartClient
//
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingForConnect : NSObject <NSCoding>

@property (nonatomic, strong) NSString *hostIp;
@property (nonatomic) int hostPort;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic) NSStringEncoding enc;

@property (nonatomic) int columnSpan;           //列间距
@property (nonatomic) int rowSpan;              //行间距
@property (nonatomic) int topMargin;            //上边距
@property (nonatomic) int leftMargin;           //左边距

@property (nonatomic) int bottomMargin;

@property (nonatomic) BOOL isFullScreen;        //是否全屏显示
@property (nonatomic) BOOL isBeep;              //是否有声音
@property (nonatomic) int cursorHeight;         //关标的高度
@property (nonatomic) NSString *fontName;       //字体名
@property (nonatomic) NSString *fontStyle;      //字体样式
@property (nonatomic) int fontSize;             //字体大小
@property (nonatomic) int fontFgColor;
@property (nonatomic) int fontBgColor;

@property (nonatomic) BOOL  isShowCaret;        //是否显示关标
@property (nonatomic) int   reConnectTime;      //重新连接时间

@property (nonatomic) UIColor *blinkColor;
@property (nonatomic) UIColor *boldColor;
@property (nonatomic) UIColor *fgColor;
@property (nonatomic) UIColor *bgColor;


@property (nonatomic) NSArray *colors;
@property (nonatomic) int soundUsed;

- (UIFont *)getCurrentFont;
- (NSArray *)getSounds;
@end
