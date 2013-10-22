//
//  Caret.h
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Caret : NSObject

@property (nonatomic) CGPoint pos;
/// <summary>
/// 颜色
/// </summary>
@property (nonatomic) UIColor *color;
/// <summary>
/// 图像
/// </summary>
//@property (nonatomic) CGBitmapInfo Bitmap;
/// <summary>
/// 画笔
/// </summary>
//public Canvas Buffer = null;
/// <summary>
/// 是否关闭
/// </summary>
@property (nonatomic) BOOL IsOff;
/// <summary>
/// End Of Line
/// </summary>
@property (nonatomic) BOOL EOL;
@end
