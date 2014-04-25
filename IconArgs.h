//
//  IconArgs.h
//  SmartClient
//
//  Created by sun on 14-4-21.
//  Copyright (c) 2014年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconArgs : NSObject

@property (nonatomic) int X;
@property (nonatomic) int Y;

@property (nonatomic) int width;
@property (nonatomic) int height;

@property (nonatomic) UIColor* color;
@property (nonatomic, strong) NSString* Iconid;
@end
