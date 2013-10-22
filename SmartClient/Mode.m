//
//  Mode.m
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "Mode.h"

@implementation Mode

@synthesize flags;

- (id)init
{
    self = [super init];
    if (self) {
        self.flags = 0;
    }
    return self;
}
@end
