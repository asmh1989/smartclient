//
//  CharAttribs.h
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chars.h"
@interface CharAttribs : NSObject

//是否是粗体
@property (nonatomic) BOOL IsBold;
@property (nonatomic) BOOL IsDim;

//是否有下划线
@property (nonatomic) BOOL IsUnderscored;
@property (nonatomic) BOOL IsBlinking;

// 是否反转颜色
@property (nonatomic) BOOL IsInverse;
@property (nonatomic) BOOL IsPrimaryFont;
@property (nonatomic) BOOL IsAlternateFont;

//是否使用前景色
@property (nonatomic) BOOL UseAltColor;

//前景颜色
@property (nonatomic, strong) UIColor *AltColor;

//是否用背景颜色
@property (nonatomic) BOOL UseAltBGColor;

//背景颜色
@property (nonatomic, strong) UIColor *AltBGColor;

//uc_Chars GL
@property (nonatomic, strong) Chars *GL;

//uc_Chars GR
@property (nonatomic, strong) Chars *GR;

//uc_Chars GS
@property (nonatomic, strong) Chars *GS;

//Decompose Constructive Solid Geometry into minimal regions???
@property (nonatomic) BOOL IsDECSG;

- (id) initWithCharAttribs:(BOOL)p1
                     IsDim:(BOOL)p2
             IsUnderscored:(BOOL)p3
                IsBlinking:(BOOL)p4
                 IsInverse:(BOOL)p5
             IsPrimaryFont:(BOOL)p6
           IsAlternateFont:(BOOL)p7
               UseAltColor:(BOOL)p8
                  AltColor:(UIColor *)p9
             UseAltBGColor:(BOOL)p10
                AltBGColor:(UIColor *)p11
                        GL:(Chars *)p12
                        GR:(Chars *)p13
                        GS:(Chars *)p14
                   ISDECSG:(BOOL)p15;


@end
