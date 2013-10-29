//
//  StringShowList.m
//  SmartClient
//
//  Created by sun on 13-10-23.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "StringShowList.h"

@implementation StringShowList

@synthesize stringShowDics;

+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareStore];
}

+ (StringShowList *)shareStore
{
    static StringShowList *shareStore = nil;
    if (!shareStore) {
        shareStore = [[super allocWithZone:nil] init];
    }
    
    return shareStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.stringShowDics = [[NSMutableDictionary alloc] init];
        self.inputStrings = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)clear
{
    [self.stringShowDics removeAllObjects];
    [self.inputStrings removeAllObjects];
}
@end
