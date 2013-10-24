//
//  Mode.h
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>



#define MODE_Locked                      1
#define MODE_BackSpace                   2
#define MODE_NewLine                     4
#define MODE_Repeat                      8
#define MODE_AutoWrap                   16
#define MODE_CursorAppln                32
#define MODE_KeypadAppln                64
#define MODE_DataProcessing            128
#define MODE_PositionReports           256
#define MODE_LocalEchoOff              512
#define MODE_OriginRelative           1024
#define MODE_LightBackground          2048
#define MODE_National                 4096
#define MODE_Any                0x80000000

//const int MODE_Locked = 1;
//const int MODE_BackSpace = 2;
//const int MODE_NewLine = 4;
//const int MODE_Repeat = 8;
//const int MODE_AutoWrap = 16;
//const int MODE_CursorAppln = 32;
//const int MODE_KeypadAppln = 64;
//const int MODE_DataProcessing = 128;
//const int MODE_PositionReports = 256;
//const int MODE_LocalEchoOff = 512;
//const int MODE_OriginRelative = 1024;
//const int MODE_LightBackground = 2048;
//const int MODE_National = 4096;
//const int MODE_Any = 0x80000000;

@interface Mode : NSObject
{
    int modeInt;
}

@property (nonatomic) int flags;

@end
