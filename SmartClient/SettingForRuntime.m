//
//  SettingForRuntime.m
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "SettingForRuntime.h"
#import "Functions.h"

@implementation SettingForRuntime

@synthesize caret, caretPreXY, mode, G0, G1, G2, G3, preCaret;

- (CGSize)getCharSizeCN:(UIFont *) font
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
    return [@"我" sizeWithFont:font];
#else
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
    [attrs setObject:font forKey:NSFontAttributeName];
    return [@"我" sizeWithAttributes:attrs];
#endif
}

-(CGSize)getCharSizeEN:(UIFont *) font
{
    int version = [[[UIDevice currentDevice] systemVersion] intValue];
    if (version < 7) {
        return [@"S" sizeWithFont:font];
    } else {
        NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
        [attrs setObject:font forKey:NSFontAttributeName];
        return [@"S" sizeWithAttributes:attrs];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        self.caretPreXY = CGPointMake(0, 0);
        self.G0 = [[Chars alloc] initWithChars:CharsSet_ASCII];
        self.G1 = [[Chars alloc] initWithChars:CharsSet_ASCII];
        self.G2 = [[Chars alloc] initWithChars:CharsSet_DECSG];
        self.G3 = [[Chars alloc] initWithChars:CharsSet_DECSG];
        self.saveCarets = [[NSMutableArray alloc] init];
        self.charAttribs = [[CharAttribs alloc] init];
        self.charAttribs.GL = self.G0;
        self.charAttribs.GR = self.G2;
        self.charAttribs.GS = nil;
        self.caret = [[Caret alloc] init];
        self.mode = [[Mode alloc] init];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareStore];
}

+ (SettingForRuntime *)shareStore
{
    static SettingForRuntime *shareStore = nil;
    if (!shareStore) {
        shareStore = [[super allocWithZone:nil] init];
    }
    
    return shareStore;
}
@end
