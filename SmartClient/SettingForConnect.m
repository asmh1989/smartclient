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

@synthesize hostIp, hostPort,deviceID, enc, columnSpan, rowSpan, topMargin,
    leftMargin, isFullScreen, isBeep, cursorHeight, fontName, fontSize,fontSizeLand,
    fontStyle, isShowCaret, reConnectTime;

@synthesize  bgColor, fgColor, blinkColor, boldColor, fontBgColor, fontFgColor;

@synthesize soundUsed;

@synthesize pictureQuality, pictureTimeSize, pictureType;

@synthesize screenOrientation;

- (void) getFontFamily
{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for(indFamily=0;indFamily<[familyNames count];++indFamily)
    {
        NSLog(@"%d Family name: %@", indFamily,[familyNames objectAtIndex:indFamily]);
        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for(indFont=0; indFont<[fontNames count]; ++indFont)
        {
//            NSLog(@" Font name: %@",[fontNames objectAtIndex:indFont]);
        }
    }
}

- (UIFont *)getCurrentFont
{
//    [self getFontFamily];
//    [self setFontStyle:@"WenQuanYi Zen Hei Mono"];
    [self setFontStyle:_FONTSTYLE];
    if([self screenOrientation] == 0){
        return [UIFont fontWithName:fontStyle size:fontSize];
    } else {
        return [UIFont fontWithName:fontStyle size:fontSizeLand];
    }

}

- (NSArray *)getSounds{
//    return [[NSArray alloc] initWithObjects:@"alpha", @"ascend", @"color", @"confirm", @"epsilon", @"gamma", @"major", @"modern", @"ripple", @"soft", @"weight", @"vector", @"zing", @"zeta", nil];
    return [[NSArray alloc] initWithObjects:@"alpha", @"ascend", @"color", @"confirm", @"major", @"modern", @"vector", @"zing", @"zeta", nil];
}

- (NSArray *)getPictureQualityArray
{
    return [[NSArray alloc] initWithObjects:NSLocalizedString(@"quality_high", nil), NSLocalizedString(@"quality_middle", nil),NSLocalizedString(@"quality_low", nil),   nil];
}

- (NSArray *)getPictureTimeSizeArray
{
    return [[NSArray alloc] initWithObjects:NSLocalizedString(@"slow", nil), NSLocalizedString(@"general", nil), NSLocalizedString(@"fast", nil), NSLocalizedString(@"very fast", nil), nil];
}

-  (NSArray *)getPictureTypeArray
{
    return  [[NSArray alloc] initWithObjects:@"jpeg", @"png", nil];
}

- (NSArray *) getScreenOri
{
    return [[NSArray alloc] initWithObjects:NSLocalizedString(@"Portrait", nil), NSLocalizedString(@"Landscape", nil),  nil];
}


-(UIColor *)getUIColor:(int) n
{
    switch (n) {
        case 0:
            return [UIColor whiteColor];
        case 1:
            return [UIColor blackColor];
        case 2:
            return [UIColor redColor];
        case 3:
            return [UIColor blueColor];
        case 4:
            return [UIColor greenColor];
        case 5:
            return [UIColor yellowColor];
        case 6:
            return [UIColor purpleColor];
        default:
            return [UIColor whiteColor];
    }
}


- (UIColor *)bgColor
{
    if (!bgColor) {
        return bgColor = [self getUIColor:fontBgColor];
    }
    
    return bgColor;
}

-  (UIColor *)fgColor
{
    if (fgColor) {
        return fgColor;
    }
    
    return fgColor = [self getUIColor:fontFgColor];
}

- (UIColor *)blinkColor
{
    if (blinkColor) {
        return blinkColor;
    }
    
    return [UIColor redColor];
}

- (UIColor *)boldColor
{
    if (boldColor) {
        return boldColor;
    }
    
    return [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0f];
}

- (id)init
{
    [self setHostIp:_HOSTIP];
    [self setHostPort:_HOSTPORT];
    [self setColumnSpan:_COLUMNSPAN];
    [self setRowSpan:_ROWSPAN];
    [self setTopMargin:_TOPMARGIN];
    [self setLeftMargin:_LEFTMARGIN];
    [self setIsFullScreen:_ISFULLSCREEN];
    [self setIsBeep:_ISBEEP];
    [self setCursorHeight:_CURSORHEIGHT];
    [self setFontName:_FONTNAME];
    [self setFontStyle:_FONTSTYLE];
    [self setFontFgColor:_FONTFGCOLOR];
    [self setFontBgColor:_FONTBGCOLOR];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self setFontSize:_FONTSIZE_PAD];
        [self setFontSizeLand:_FONTSIZE_PAD_LAND];
    } else {
        [self setFontSize:_FONTSIZE];
        [self setFontSizeLand:_FONTSIZE_LAND];
    }
    
    [self setScreenOrientation:_SCREEN_ORI];
    
    [self setIsShowCaret:_SHOW_CARET];
    NSString *uid = [self uuid];
    [self setDeviceID:uid];
    uid = nil;
    [self setReConnectTime:_RECONNECT_TIME];
    [self setCursorHeight:_CARET_HEIGHT];
    [self setSoundUsed:_SOUNDUSED];
    [self setPictureQuality:_PICTURE_QUALITY];
    [self setPictureTimeSize:_PICTURE_TIME_SIZE];
    [self setPictureType:_PICTURE_TYPE];
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
        [self setRowSpan:[aDecoder decodeIntForKey:STRING_ROWSPAN]];
        [self setTopMargin:[aDecoder decodeIntForKey:STRING_TOPMARGIN]];
        [self setLeftMargin:[aDecoder decodeIntForKey:STRING_LEFTMARGIN]];
        [self setIsFullScreen:[aDecoder decodeBoolForKey:STRING_ISFULLSCREEN]];
        [self setIsBeep:[aDecoder decodeBoolForKey:STRING_ISBEEP]];
        [self setCursorHeight:[aDecoder decodeIntForKey:STRING_CURSORHEIGHT]];
        [self setFontName:[aDecoder decodeObjectForKey:STRING_FONTNAME]];
        [self setFontStyle:[aDecoder decodeObjectForKey:STRING_FONTSTYLE]];
        [self setFontSize:[aDecoder decodeIntForKey:STRING_FONTSIZE]];
        [self setFontSizeLand:[aDecoder decodeIntForKey:STRING_FONTSIZE_LAND]];
        [self setIsShowCaret:[aDecoder decodeBoolForKey:STRING_SHOWCARET]];
        [self setReConnectTime:[aDecoder decodeIntForKey:STRING_RECONNECTTIME]];
        [self setFontBgColor:[aDecoder decodeIntForKey:STRING_FONTBGCOLOR]];
        [self setFontFgColor:[aDecoder decodeIntForKey:STRING_FONTFGCOLOR]];
        [self setCursorHeight:[aDecoder decodeIntForKey:STRING_CURSORHEIGHT]];
        [self setSoundUsed:[aDecoder decodeIntForKey:STRING_SOUNDUSED]];
        [self setPictureType:[aDecoder decodeIntForKey:STRING_PICTURE_T]];
        [self setPictureQuality:[aDecoder decodeIntForKey:STRING_PICTURE_Q]];
        [self setPictureTimeSize:[aDecoder decodeIntForKey:STRING_PICTURE_S]];
        [self setScreenOrientation:[aDecoder decodeIntForKey:STRING_SCREEN_ORI]];
    }
    
//    NSLog(@"initWithCoder, hostIp = %@", hostIp);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:hostIp forKey:STRING_HOSTIP];
    [aCoder encodeInt:hostPort forKey:STRING_HOSTPORT];
    [aCoder encodeObject:deviceID forKey:STRING_DEVICEID];
    [aCoder encodeInt:(int)enc forKey:STRING_ENC];
    [aCoder encodeInt:columnSpan forKey:STRING_COLUMNSPAN];
    [aCoder encodeInt:rowSpan forKey:STRING_ROWSPAN];
    [aCoder encodeInt:topMargin forKey:STRING_TOPMARGIN];
    [aCoder encodeInt:leftMargin forKey:STRING_LEFTMARGIN];
    [aCoder encodeBool:isFullScreen forKey:STRING_ISFULLSCREEN];
    [aCoder encodeBool:isBeep forKey:STRING_ISBEEP];
    [aCoder encodeInt:cursorHeight forKey:STRING_CURSORHEIGHT];
    [aCoder encodeObject:fontName forKey:STRING_FONTNAME];
    [aCoder encodeObject:fontStyle forKey:STRING_FONTSTYLE];
    [aCoder encodeInt:fontSize forKey:STRING_FONTSIZE];
    [aCoder encodeInt:fontSizeLand forKey:STRING_FONTSIZE_LAND];
    [aCoder encodeBool:isShowCaret forKey:STRING_SHOWCARET];
    [aCoder encodeInt:reConnectTime forKey:STRING_RECONNECTTIME];
    [aCoder encodeInt:fontBgColor forKey:STRING_FONTBGCOLOR];
    [aCoder encodeInt:fontFgColor forKey:STRING_FONTFGCOLOR];
    [aCoder encodeInt:soundUsed forKey:STRING_SOUNDUSED];
    [aCoder encodeInt:pictureType forKey:STRING_PICTURE_T];
    [aCoder encodeInt:pictureQuality forKey:STRING_PICTURE_Q];
    [aCoder encodeInt:pictureTimeSize forKey:STRING_PICTURE_S];
    [aCoder encodeInt:screenOrientation forKey:STRING_SCREEN_ORI];
//    NSLog(@"encodeWithCoder, hostIp = %@", hostIp);
}



@end
