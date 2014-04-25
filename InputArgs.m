//
//  InputArgs.m
//  SmartClient
//
//  Created by sun on 14-4-22.
//  Copyright (c) 2014年 searching. All rights reserved.
//

#import "InputArgs.h"

@implementation InputArgs

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.X = 0;
        self.Y = 0;
        self.maskChar = @"";
        self.text = @"";
        self.maxLength = 0;
        self.width = 0;
        self.height = 0;
    }
    return self;
}

- (NSString *)getKey
{
    return [NSString stringWithFormat:@"%d%d%d%d", self.X, self.Y, self.width, self.height];
}
@end
