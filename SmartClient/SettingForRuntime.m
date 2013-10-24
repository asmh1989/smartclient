//
//  SettingForRuntime.m
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "SettingForRuntime.h"

@implementation SettingForRuntime

@synthesize caret, caretPreXY, mode, G0, G1, G2, G3, preCaret;

- (CGSize)getCharSizeCN:(UIFont *) font
{
    return [@"我" sizeWithFont:font];
}

-(CGSize)getCharSizeEN:(UIFont *) font
{
    return [@"S" sizeWithFont:font];
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
