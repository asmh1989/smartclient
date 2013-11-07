//
//  DefaultSettings.h
//  SmartClient
//  一切的默认设置都在此修改
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>


// 公司内网
#define _HOSTIP                @"192.168.8.239"
// 外网
//#define _HOSTIP                  @"searching-info.com"   //当前服务器ip
#define _HOSTPORT                23                      //当前服务器端口
#define _COLUMNSPAN              0                       //列间距
#define _ROWSPAN                 0                       //行间距
#define _TOPMARGIN               0                       //上边距
#define _LEFTMARGIN              0                       //左边距
#define _ISFULLSCREEN            NO                      //是否全屏显示
#define _ISBEEP                  YES                     //是否有声音
#define _SOUNDUSED               0                       //默认警告声
#define _CURSORHEIGHT            2                       //关标的高度
#define _FONTNAME                @"Helvetica"            //字体名
#define _FONTSTYLE               @"Helvetica"            //字体样式
#define _FONTSIZE                18                      //字体大小
#define _SHOW_CARET              YES                     //是否显示光标
#define _RECONNECT_TIME          5                       //重新连接时间
#define _FONTFGCOLOR             1
#define _FONTBGCOLOR             0
#define _CARET_HEIGHT            2                       //光标高度

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
#define STRING_SHOWCARET         @"showCaret"
#define STRING_RECONNECTTIME     @"reconnecttime"
#define STRING_FONTFGCOLOR       @"fontfgcolor"
#define STRING_FONTBGCOLOR       @"fontbgcolor"
#define STRING_SOUNDUSED         @"soundused"

@interface DefaultSettings : NSObject

@end

