//
//  InfobarArgs.m
//  SmartClient
//
//  Created by sun on 14-4-22.
//  Copyright (c) 2014年 searching. All rights reserved.
//

#import "InfobarArgs.h"

@implementation InfobarArgs
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.text = @"";
        self.bgColor = [UIColor grayColor];
        self.fgColor = [UIColor blackColor];
    }
    return self;
}
@end
