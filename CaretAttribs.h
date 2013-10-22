//
//  CaretAttribs.h
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chars.h"
#import "CharAttribs.h"
@interface CaretAttribs : NSObject

@property (nonatomic) CGPoint pos;
@property (nonatomic) enum CharsSets G0Set;
@property (nonatomic) enum CharsSets G1Set;
@property (nonatomic) enum CharsSets G2Set;
@property (nonatomic) enum CharsSets G3Set;
@property (nonatomic) CharAttribs *attribs;

-(id) initWithPos:(CGPoint)p  G0Set:(enum CharsSets)g0 G1Set:(enum CharsSets)g1
                    G2Set:(enum CharsSets)g2 G3Set:(enum CharsSets)g3
                    CharAttribs:(CharAttribs *)attr;
@end
