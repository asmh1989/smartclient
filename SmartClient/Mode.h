//
//  Mode.h
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

const int Locked = 1;
const int BackSpace = 2;
const int NewLine = 4;
const int Repeat = 8;
const int AutoWrap = 16;
const int CursorAppln = 32;
const int KeypadAppln = 64;
const int DataProcessing = 128;
const int PositionReports = 256;
const int LocalEchoOff = 512;
const int OriginRelative = 1024;
const int LightBackground = 2048;
const int National = 4096;
const int Any = 0x80000000;

@interface Mode : NSObject
{
    int modeInt;
}

@property (nonatomic) int flags;

@end
