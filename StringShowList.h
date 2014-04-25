//
//  StringShowList.h
//  SmartClient
//
//  Created by sun on 13-10-23.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringShowList : NSObject
@property (nonatomic, strong) NSMutableDictionary *stringShowDics;
@property (nonatomic, strong) NSMutableArray *inputStrings;
@property (nonatomic, strong) NSMutableDictionary *lineDict;
@property (nonatomic, strong) NSMutableDictionary *iconDict;
@property (nonatomic, strong) NSMutableDictionary *inputDict;

+ (StringShowList *)shareStore;
- (void)clear;

@end
