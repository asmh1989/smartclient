//
//  DefaultSettings.h
//  SmartClient
//  一切的默认设置都在此修改
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>


// 公司内网
//#define _HOSTIP                @"192.168.8.239"
// 外网
#define _HOSTIP                  @"searching-info.com"   //当前服务器ip
#define _HOSTPORT                23                      //当前服务器端口
#define _COLUMNSPAN              0                       //列间距
#define _ROWSPAN                 0                       //行间距
#define _TOPMARGIN               0                       //上边距
#define _LEFTMARGIN              0                       //左边距
#define _ISFULLSCREEN            NO                      //是否全屏显示
#define _ISBEEP                  YES                     //是否有声音
#define _SOUNDUSED               0                       //默认警告声
#define _CURSORHEIGHT            2                       //关标的高度
#define _FONTNAME                @"KaiTi"                //字体名
#define _FONTSTYLE               @"KaiTi"                //字体样式
#define _FONTSIZE                21                      //字体大小
#define _FONTSIZE_PAD            46                      //pad上字体大小

#define _SCREEN_ORI              0
#define _FONTSIZE_PAD_LAND       35                      //横屏字体默认大小
#define _FONTSIZE_LAND           18

#define _SHOW_CARET              YES                     //是否显示光标
#define _RECONNECT_TIME          5                       //重新连接时间
#define _FONTFGCOLOR             1
#define _FONTBGCOLOR             0
#define _CARET_HEIGHT            2                       //光标高度
#define _PICTURE_QUALITY         1                       //0： 低 1：中 2：高
#define _PICTURE_TIME_SIZE       2                       //0：慢 1： 一般 2：快 3：特快  4096 8096 16192
#define _PICTURE_TYPE            0                       //0 : JPEG 1:png

#define STRING_HOSTIP            @"hostIp"
#define STRING_HOSTPORT          @"hostPort"
#define STRING_DEVICEID          @"deviceID"
#define STRING_ENC               @"enc"
#define STRING_COLUMNSPAN        @"columnSpan"
#define STRING_ROWSPAN           @"rowSpan"
#define STRING_TOPMARGIN         @"topMargin"
#define STRING_LEFTMARGIN        @"leftMargin"
#define STRING_ISFULLSCREEN      @"isFullScreen"
#define STRING_ISBEEP            @"isBeep"
#define STRING_CURSORHEIGHT      @"cursorHeight"
#define STRING_FONTNAME          @"fontName"
#define STRING_FONTSTYLE         @"fontStyle"
#define STRING_FONTSIZE          @"fontSize"
#define STRING_FONTSIZE_LAND     @"fontsize_land"
#define STRING_SHOWCARET         @"showCaret"
#define STRING_RECONNECTTIME     @"reconnecttime"
#define STRING_FONTFGCOLOR       @"fontfgcolor"
#define STRING_FONTBGCOLOR       @"fontbgcolor"
#define STRING_SOUNDUSED         @"soundused"
#define STRING_PICTURE_Q         @"picturequality"
#define STRING_PICTURE_S         @"picturetimesize"
#define STRING_PICTURE_T         @"picturetype"
#define STRING_SCREEN_ORI        @"screenorientation"

@interface DefaultSettings : NSObject

@end

