//
//  Chars.h
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import <Foundation/Foundation.h>

enum CharsSets
{
    CharsSet_None,
    CharsSet_DECSG,
    CharsSet_DECTECH,
    CharsSet_DECS,
    CharsSet_ASCII,
    CharsSet_ISOLatin1S,
    CharsSet_NRCUK,
    CharsSet_NRCFinnish,
    CharsSet_NRCFrench,
    CharsSet_NRCFrenchCanadian,
    CharsSet_NRCGerman,
    CharsSet_NRCItalian,
    CharsSet_NRCNorDanish,
    CharsSet_NRCPortuguese,
    CharsSet_NRCSpanish,
    CharsSet_NRCSwedish,
    CharsSet_NRCSwiss
};

@interface Chars : NSObject
@property (nonatomic) enum CharsSets set;
- (id) initWithChars:(enum CharsSets)p;
- (unsigned short int) Get:(unsigned short int)curChar GL:(enum CharsSets)GL GR:(enum CharsSets)GR;

@end
