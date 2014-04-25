//
//  LineArgs.m
//  SmartClient
//
//  Created by sun on 14-4-22.
//  Copyright (c) 2014年 searching. All rights reserved.
//

#import "LineArgs.h"

@implementation LineArgs

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.X = 0;
        self.Y = 0;
        self.length = 0;
        self.lineColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
        self.orientation = @"H";
    }
    return self;
}

- (NSString *)getKey
{
    return [NSString stringWithFormat:@"%d%d%@", self.X, self.Y, self.orientation];
}
@end
