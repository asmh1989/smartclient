//
//  ParserMsg.h
//  SmartClient
//
//  Created by sun on 13-10-18.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserMsg : NSObject

@property (nonatomic) BOOL XOFF;

- (void)parserString:(NSString *)msg;

- (void) clearDown:(int)param;
- (void) clearRight:(int)param;
@end
