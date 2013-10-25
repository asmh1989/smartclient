//
//  Caret.m
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "Caret.h"

@implementation Caret

@synthesize color, pos, IsOff, EOL;
- (id)init
{
    self = [super init];
    if (self) {
        self.color = [UIColor colorWithRed:255/255.0F green:181/255.0F blue:106/255.0F alpha:1.0f];
        self.IsOff = NO;
        self.EOL = NO;
        self.pos = CGPointMake(0, 0);
        
    }
    return self;
}
@end
