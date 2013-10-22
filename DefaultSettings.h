//
//  DefaultSettings.h
//  SmartClient
//  一切的默认设置都在此修改
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>


// 公司内网
//#define HOSTIP                @"192.168.8.239"
// 外网
#define _HOSTIP                  @"searching-info.com"   //当前服务器ip
#define _HOSTPORT                23                      //当前服务器端口
#define _COLUMNSPAN              0                       //列间距
#define _ROWSPAN                 2                       //行间距
#define _TOPMARGIN               2                       //上边距
#define _LEFTMARGIN              2                       //左边距
#define _ISFULLSCREEN            NO                      //是否全屏显示
#define _ISBEEP                  YES                     //是否有声音
#define _CURSORHEIGHT            2                       //关标的高度
#define _FONTNAME                @""                     //字体名
#define _FONTSTYLE               @""                     //字体样式
#define _FONTSIZE                20                      //字体大小

NSString *const STRING_HOSTIP           = @"hostIp";
NSString *const STRING_HOSTPORT         = @"hostPort";
NSString *const STRING_DEVICEID         = @"deviceID";
NSString *const STRING_ENC              = @"enc";
NSString *const STRING_COLUMNSPAN       = @"columnSpan";
NSString *const STRING_ROWSPAN          = @"rowSpan";
NSString *const STRING_TOPMARGIN        = @"topMargin";
NSString *const STRING_LEFTMARGIN       = @"leftMargin";
NSString *const STRING_ISFULLSCREEN     = @"isFullScreen";
NSString *const STRING_ISBEEP           = @"isBeep";
NSString *const STRING_CURSORHEIGHT     = @"cursorHeight";
NSString *const STRING_FONTNAME         = @"fontName";
NSString *const STRING_FONTSTYLE        = @"fontStyle";
NSString *const STRING_FONTSIZE         = @"fontSize";


@interface DefaultSettings : NSObject

@end

