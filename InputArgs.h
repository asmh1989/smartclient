//
//  InputArgs.h
//  SmartClient
//
//  Created by sun on 14-4-22.
//  Copyright (c) 2014年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputArgs : NSObject
@property (nonatomic) int X;
@property (nonatomic) int Y;

@property (nonatomic) int maxLength;
@property (nonatomic) int width;
@property (nonatomic) int height;

@property (nonatomic, strong) NSString* maskChar;
@property (nonatomic, strong) NSString* text;

- (NSString *)getKey;

@end
