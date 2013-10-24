//
//  CharAttribs.m
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "CharAttribs.h"

@implementation CharAttribs
@synthesize IsAlternateFont, IsBlinking, IsBold, IsDECSG, IsDim, IsInverse,
        IsPrimaryFont, IsUnderscored, UseAltBGColor, UseAltColor, AltBGColor,
        AltColor, GL, GR, GS;
- (id)initWithCharAttribs:(BOOL)p1 IsDim:(BOOL)p2 IsUnderscored:(BOOL)p3 IsBlinking:(BOOL)p4 IsInverse:(BOOL)p5 IsPrimaryFont:(BOOL)p6 IsAlternateFont:(BOOL)p7 UseAltColor:(BOOL)p8 AltColor:(UIColor *)p9 UseAltBGColor:(BOOL)p10 AltBGColor:(UIColor *)p11 GL:(Chars *)p12 GR:(Chars *)p13 GS:(Chars *)p14 ISDECSG:(BOOL)p15
{
    self = [super init];
    if (self) {
        self.IsBold = p1;
        self.IsDim = p2;
        self.IsUnderscored = p3;
        self.IsBlinking = p4;
        self.IsInverse = p5;
        self.IsPrimaryFont = p6;
        self.IsAlternateFont = p7;
        self.UseAltColor = p8;
        self.AltColor = p9;
        self.UseAltBGColor = p10;
        self.AltBGColor = p11;
        self.GL = p12;
        self.GR = p13;
        self.GS = p14;
        self.IsDECSG = p15;
    }
    return self;
}
@end
