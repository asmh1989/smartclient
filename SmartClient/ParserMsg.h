//
//  ParserMsg.h
//  SmartClient
//
//  Created by sun on 13-10-18.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParserDelegate <NSObject>

- (void) VTProtocolExtend:(NSString *)vtProtocol Message:(NSString *)msg;
- (void) dispatchMessage:(NSString *)output tag:(long)tag;

@end

@interface ParserMsg : NSObject

@property (nonatomic) BOOL XOFF;
@property(assign,nonatomic)id<ParserDelegate> delegate;


- (void)parserString:(NSString *)msg;

- (void) clearDown:(int)param;
- (void) clearRight:(int)param;

@end












