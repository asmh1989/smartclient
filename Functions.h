//
//  Functions.h
//  SmartClient
//
//  Created by sun on 13-10-24.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _TOSTRIING(N) [NSString stringWithFormat:@"%d", (int)(N)]
@interface Functions : NSObject

+ (NSString *)makeFloatTOString:(float)p;

@end
