//
//  CaretAttribs.m
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "CaretAttribs.h"

@implementation CaretAttribs

@synthesize pos, G0Set,G1Set, G2Set, G3Set, attribs;

- (id)initWithPos:(CGPoint)p G0Set:(enum CharsSets)g0 G1Set:(enum CharsSets)g1 G2Set:(enum CharsSets)g2 G3Set:(enum CharsSets)g3 CharAttribs:(CharAttribs *)attr
{
    self = [super init];
    if (self) {
        self.pos = p;
        self.G0Set = g0;
        self.G1Set = g1;
        self.G2Set = g2;
        self.attribs = attr;
    }
    
    return self;
}
@end
