//
//  ToolbarArgs.m
//  SmartClient
//
//  Created by sun on 14-4-22.
//  Copyright (c) 2014年 searching. All rights reserved.
//

#import "ToolbarArgs.h"

@implementation ToolbarArgs

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.text = NSLocalizedString(@"Back", nil);
        self.icon = @"back";
        self.action = @"";
        self.ID = @"back";
    }
    return self;
}
@end
