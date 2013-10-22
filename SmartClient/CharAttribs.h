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
@property (nonatomic, assign) BOOL IsBold;
@property (nonatomic, assign) BOOL IsDim;

//是否有下划线
@property (nonatomic, assign) BOOL IsUnderscored;
@property (nonatomic, assign) BOOL IsBlinking;

// 是否反转颜色
@property (nonatomic, assign) BOOL IsInverse;
@property (nonatomic, assign) BOOL IsPrimaryFont;
@property (nonatomic, assign) BOOL IsAlternateFont;

//是否使用前景色
@property (nonatomic, assign) BOOL UseAltColor;

//前景颜色
@property (nonatomic, assign) int AltColor;

//是否用背景颜色
@property (nonatomic, assign) BOOL UseAltBGColor;

//背景颜色
@property (nonatomic, assign) int AltBGColor;

//uc_Chars GL
@property (nonatomic, assign) Chars *GL;

//uc_Chars GR
@property (nonatomic, assign) Chars *GR;

//uc_Chars GS
@property (nonatomic, assign) Chars *GS;

//Decompose Constructive Solid Geometry into minimal regions???
@property (nonatomic, assign) BOOL IsDECSG;

- (id) initWithCharAttribs:(BOOL)p1
                     IsDim:(BOOL)p2
             IsUnderscored:(BOOL)p3
                IsBlinking:(BOOL)p4
                 IsInverse:(BOOL)p5
             IsPrimaryFont:(BOOL)p6
           IsAlternateFont:(BOOL)p7
               UseAltColor:(BOOL)p8
                  AltColor:(int)p9
             UseAltBGColor:(BOOL)p10
                AltBGColor:(int)p11
                        GL:(Chars *)p12
                        GR:(Chars *)p13
                        GS:(Chars *)p14
                   ISDECSG:(BOOL)p15;


@end
