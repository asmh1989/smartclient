//
//  SettingForConnect.m
//  SmartClient
//
//  Created by sun on 13-10-17.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "SettingForConnect.h"
#import "DefaultSettings.h"



@implementation SettingForConnect

@synthesize hostIp, hostPort,deviceID, enc, columnSpan, rowSpam, topMargin,
    leftMargin, isFullScreen, isBeep, cursorHeight, fontName, fontSize,
    fontStyle;


- (id)init
{
    [self setHostIp:_HOSTIP];
    [self setHostPort:_HOSTPORT];
    [self setColumnSpan:_COLUMNSPAN];
    [self setRowSpam:_ROWSPAN];
    [self setTopMargin:_TOPMARGIN];
    [self setLeftMargin:_LEFTMARGIN];
    [self setIsFullScreen:_ISFULLSCREEN];
    [self setIsBeep:_ISBEEP];
    [self setCursorHeight:_CURSORHEIGHT];
    [self setFontName:_FONTNAME];
    [self setFontStyle:_FONTSTYLE];
    [self setFontSize:_FONTSIZE];
    [self setDeviceID:[self uuid]];
    [self setEnc:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]; // use GB2312
    
    return self;
}

-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid );
    NSString * result = (__bridge NSString *)uuidString;
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setHostIp:[aDecoder decodeObjectForKey:STRING_HOSTIP]];
        [self setHostPort:[aDecoder decodeIntForKey:STRING_HOSTPORT]];
        [self setDeviceID:[aDecoder decodeObjectForKey:STRING_DEVICEID]];
        [self setEnc:[aDecoder decodeIntForKey:STRING_ENC]];
        [self setColumnSpan:[aDecoder decodeIntForKey:STRING_COLUMNSPAN]];
        [self setRowSpam:[aDecoder decodeIntForKey:STRING_ROWSPAN]];
        [self setTopMargin:[aDecoder decodeIntForKey:STRING_TOPMARGIN]];
        [self setLeftMargin:[aDecoder decodeIntForKey:STRING_LEFTMARGIN]];
        [self setIsFullScreen:[aDecoder decodeBoolForKey:STRING_ISFULLSCREEN]];
        [self setIsBeep:[aDecoder decodeBoolForKey:STRING_ISBEEP]];
        [self setCursorHeight:[aDecoder decodeIntForKey:STRING_CURSORHEIGHT]];
        [self setFontName:[aDecoder decodeObjectForKey:STRING_FONTNAME]];
        [self setFontStyle:[aDecoder decodeObjectForKey:STRING_FONTSTYLE]];
        [self setFontSize:[aDecoder decodeIntForKey:STRING_FONTSIZE]];
    }
    
    NSLog(@"initWithCoder, hostIp = %@", hostIp);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:hostIp forKey:STRING_HOSTIP];
    [aCoder encodeInt:hostPort forKey:STRING_HOSTPORT];
    [aCoder encodeObject:deviceID forKey:STRING_DEVICEID];
    [aCoder encodeInt:(int)enc forKey:STRING_ENC];
    [aCoder encodeInt:columnSpan forKey:STRING_COLUMNSPAN];
    [aCoder encodeInt:rowSpam forKey:STRING_ROWSPAN];
    [aCoder encodeInt:topMargin forKey:STRING_TOPMARGIN];
    [aCoder encodeInt:leftMargin forKey:STRING_LEFTMARGIN];
    [aCoder encodeBool:isFullScreen forKey:STRING_ISFULLSCREEN];
    [aCoder encodeBool:isBeep forKey:STRING_ISBEEP];
    [aCoder encodeInt:cursorHeight forKey:STRING_CURSORHEIGHT];
    [aCoder encodeObject:fontName forKey:STRING_FONTNAME];
    [aCoder encodeObject:fontStyle forKey:STRING_FONTSTYLE];
    [aCoder encodeInt:fontSize forKey:STRING_FONTSIZE];
    
    NSLog(@"encodeWithCoder, hostIp = %@", hostIp);
}



@end
