//
//  LineArgs.h
//  SmartClient
//
//  Created by sun on 14-4-22.
//  Copyright (c) 2014年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineArgs : NSObject

@property (nonatomic) int X;
@property (nonatomic) int Y;
@property (nonatomic, strong) NSString *orientation;
@property (nonatomic) int length;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) NSString *rgb;

- (NSString *)getKey;
@end
