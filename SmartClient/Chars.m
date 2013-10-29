//
//  Chars.m
//  SmartClient
//
//  Created by sun on 13-10-22.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "Chars.h"

@interface CharSet : NSObject
@property (nonatomic) int Location;
@property (nonatomic) int UnicodeNo;

- (id) initWithCharSet:(int) p1 UnicodeNo:(int)p2;
@end

@implementation CharSet

- (id)initWithCharSet:(int)p1 UnicodeNo:(int)p2
{
    self = [super init];
    if(self){
        self.Location = p1;
        self.UnicodeNo = p2;
    }
    return self;
}

@end

@interface CharsData : NSObject
@property (nonatomic) NSArray *DECSG;
@property (nonatomic) NSArray *DECS;
@property (nonatomic) NSArray *ASCII;
@property (nonatomic) NSArray *NRCUK;
@property (nonatomic) NSArray *NRCFinnish;
@property (nonatomic) NSArray *NRCFrench;
@property (nonatomic) NSArray *NRCFrenchCanadian;
@property (nonatomic) NSArray *NRCGerman;
@property (nonatomic) NSArray *NRCItalian;
@property (nonatomic) NSArray *NRCNorDanish;
@property (nonatomic) NSArray *NRCPortuguese;
@property (nonatomic) NSArray *NRCSpanish;
@property (nonatomic) NSArray *NRCSwedish;
@property (nonatomic) NSArray *NRCSwiss;
@property (nonatomic) NSArray *ISOLAtin1S;

+ (CharsData *)shareStore;
@end

@implementation CharsData

@synthesize ASCII, DECS, DECSG, NRCFinnish, NRCFrench, NRCFrenchCanadian, NRCGerman, NRCItalian, NRCNorDanish
, NRCPortuguese, NRCSpanish, NRCSwedish, NRCSwiss, NRCUK, ISOLAtin1S;

+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareStore];
}

+ (CharsData *)shareStore
{
    static CharsData *shareStore = nil;
    if (!shareStore) {
        shareStore = [[super allocWithZone:nil] init];
    }
    
    return shareStore;
}

- (void)initArrys
{
    DECSG =[[NSArray alloc] initWithObjects:
            [[CharSet alloc] initWithCharSet:0x5F UnicodeNo:0x0020],
            [[CharSet alloc] initWithCharSet:0x61 UnicodeNo:0x0000],
            [[CharSet alloc] initWithCharSet:0x62 UnicodeNo:0x2409],
            [[CharSet alloc] initWithCharSet:0x63 UnicodeNo:0x240C],
            [[CharSet alloc] initWithCharSet:0x64 UnicodeNo:0x240D],
            [[CharSet alloc] initWithCharSet:0x65 UnicodeNo:0x240A],
            [[CharSet alloc] initWithCharSet:0x66 UnicodeNo:0x00B0],
            [[CharSet alloc] initWithCharSet:0x67 UnicodeNo:0x00B1],
            [[CharSet alloc] initWithCharSet:0x5F UnicodeNo:0x0020],
            [[CharSet alloc] initWithCharSet:0x69 UnicodeNo:0x240B],
            [[CharSet alloc] initWithCharSet:0x6F UnicodeNo:0x23BA],
            [[CharSet alloc] initWithCharSet:0x70 UnicodeNo:0x25BB],
            [[CharSet alloc] initWithCharSet:0x72 UnicodeNo:0x23BC],
            [[CharSet alloc] initWithCharSet:0x73 UnicodeNo:0x23BD],
            [[CharSet alloc] initWithCharSet:0x79 UnicodeNo:0x2264],
            [[CharSet alloc] initWithCharSet:0x7A UnicodeNo:0x2265],
            [[CharSet alloc] initWithCharSet:0x7B UnicodeNo:0x03A0],
            [[CharSet alloc] initWithCharSet:0x7C UnicodeNo:0x2260],
            [[CharSet alloc] initWithCharSet:0x7D UnicodeNo:0x00A3],
            [[CharSet alloc] initWithCharSet:0x7E UnicodeNo:0x00B7], nil];
    
    DECS = [[NSArray alloc] initWithObjects:
            [[CharSet alloc] initWithCharSet:0xA8 UnicodeNo:0x0020],
            [[CharSet alloc] initWithCharSet:0xD7 UnicodeNo:0x0152],
            [[CharSet alloc] initWithCharSet:0xDD UnicodeNo:0x0178],
            [[CharSet alloc] initWithCharSet:0xF7 UnicodeNo:0x0153],
            [[CharSet alloc] initWithCharSet:0xFD UnicodeNo:0x00FF], nil];
    
    ASCII = [[NSArray alloc] initWithObjects:
             [[CharSet alloc] initWithCharSet:0x00 UnicodeNo:0x0000], nil];
    
    NRCUK = [[NSArray alloc] initWithObjects:
             [[CharSet alloc] initWithCharSet:0x23 UnicodeNo:0x00A3], nil];
    
    NRCFinnish = [[NSArray alloc] initWithObjects:
          [[CharSet alloc] initWithCharSet:0x5B UnicodeNo:0x00C4],
          [[CharSet alloc] initWithCharSet:0x5C UnicodeNo:0x00D6],
          [[CharSet alloc] initWithCharSet:0x5D UnicodeNo:0x00C5],
          [[CharSet alloc] initWithCharSet:0x5E UnicodeNo:0x00DC],
          [[CharSet alloc] initWithCharSet:0x60 UnicodeNo:0x00E9],
          [[CharSet alloc] initWithCharSet:0x7B UnicodeNo:0x00E4],
          [[CharSet alloc] initWithCharSet:0x7C UnicodeNo:0x00F6],
          [[CharSet alloc] initWithCharSet:0x7D UnicodeNo:0x00E5],
          [[CharSet alloc] initWithCharSet:0x7E UnicodeNo:0x00FC], nil];
    
    NRCFrench = [[NSArray alloc] initWithObjects:
         [[CharSet alloc] initWithCharSet:0x23 UnicodeNo:0x00A3],
         [[CharSet alloc] initWithCharSet:0x40 UnicodeNo:0x00E0],
         [[CharSet alloc] initWithCharSet:0x5B UnicodeNo:0x00B0],
         [[CharSet alloc] initWithCharSet:0x5C UnicodeNo:0x00E7],
         [[CharSet alloc] initWithCharSet:0x5D UnicodeNo:0x00A7],
         [[CharSet alloc] initWithCharSet:0x7B UnicodeNo:0x00E9],
         [[CharSet alloc] initWithCharSet:0x7C UnicodeNo:0x00F9],
         [[CharSet alloc] initWithCharSet:0x7D UnicodeNo:0x00E8],
         [[CharSet alloc] initWithCharSet:0x7E UnicodeNo:0x00A8], nil];

    NRCFrenchCanadian= [[NSArray alloc] initWithObjects:
        [[CharSet alloc] initWithCharSet:0x40 UnicodeNo:0x00E0], // a with  accent
        [[CharSet alloc] initWithCharSet:0x5B UnicodeNo:0x00E2], // a with circumflex
        [[CharSet alloc] initWithCharSet:0x5C UnicodeNo:0x00E7], // little
        [[CharSet alloc] initWithCharSet:0x5D UnicodeNo:0x00EA], // e with circumflex
        [[CharSet alloc] initWithCharSet:0x5E UnicodeNo:0x00CE], // i with circumflex
        [[CharSet alloc] initWithCharSet:0x60 UnicodeNo:0x00F4], // o with circumflex
        [[CharSet alloc] initWithCharSet:0x7B UnicodeNo:0x00E9], // e with  accent
        [[CharSet alloc] initWithCharSet:0x7C UnicodeNo:0x00F9], // u with  accent
        [[CharSet alloc] initWithCharSet:0x7D UnicodeNo:0x00E8], // e with  accent
        [[CharSet alloc] initWithCharSet:0x7E UnicodeNo:0x00FB], // u with circumflex
        nil];
    
    NRCGerman = [[NSArray alloc] initWithObjects:
         [[CharSet alloc] initWithCharSet:0x40 UnicodeNo:0x00A7], // funny s
         [[CharSet alloc] initWithCharSet:0x5B UnicodeNo:0x00C4], // A with
         [[CharSet alloc] initWithCharSet:0x5C UnicodeNo:0x00D6], // O with
         [[CharSet alloc] initWithCharSet:0x5D UnicodeNo:0x00DC], // U with
         [[CharSet alloc] initWithCharSet:0x7B UnicodeNo:0x00E4], // a with
         [[CharSet alloc] initWithCharSet:0x7C UnicodeNo:0x00F6], // o with
         [[CharSet alloc] initWithCharSet:0x7D UnicodeNo:0x00FC], // u with
         [[CharSet alloc] initWithCharSet:0x7E UnicodeNo:0x00DF], // funny B
         nil];
    
    NRCItalian = [[NSArray alloc] initWithObjects:
          [[CharSet alloc] initWithCharSet:0x23 UnicodeNo:0x00A3], // pound sign
          [[CharSet alloc] initWithCharSet:0x40 UnicodeNo:0x00A7], // funny s
          [[CharSet alloc] initWithCharSet:0x5B UnicodeNo:0x00B0], // Degree Symbol
          [[CharSet alloc] initWithCharSet:0x5C UnicodeNo:0x00E7], // little
          [[CharSet alloc] initWithCharSet:0x5D UnicodeNo:0x00E9], // e with  accent
          [[CharSet alloc] initWithCharSet:0x60 UnicodeNo:0x00F9], // u with  accent
          [[CharSet alloc] initWithCharSet:0x7B UnicodeNo:0x00E0], // a with  accent
          [[CharSet alloc] initWithCharSet:0x7C UnicodeNo:0x00F2], // o with  accent
          [[CharSet alloc] initWithCharSet:0x7D UnicodeNo:0x00E8], // e with  accent
          [[CharSet alloc] initWithCharSet:0x7E UnicodeNo:0x00CC], // I with  accent
          nil];
    
    NRCNorDanish = [[NSArray alloc] initWithObjects:
            [[CharSet alloc] initWithCharSet:0x5B UnicodeNo:0x00C6], // AE
            [[CharSet alloc] initWithCharSet:0x5C UnicodeNo:0x00D8], // O with
            [[CharSet alloc] initWithCharSet:0x5D UnicodeNo:0x00D8], // O with
            [[CharSet alloc] initWithCharSet:0x5D UnicodeNo:0x00C5], // A with hollow dot above
            [[CharSet alloc] initWithCharSet:0x7B UnicodeNo:0x00E6], //
            [[CharSet alloc] initWithCharSet:0x7C UnicodeNo:0x00F8], // o with
            [[CharSet alloc] initWithCharSet:0x7D UnicodeNo:0x00F8], // o with
            [[CharSet alloc] initWithCharSet:0x7D UnicodeNo:0x00E5], // a with hollow dot above
            nil];
    
    NRCPortuguese = [[NSArray alloc] initWithObjects:
             [[CharSet alloc] initWithCharSet:0x5B UnicodeNo:0x00C3], // A with tilde
             [[CharSet alloc] initWithCharSet:0x5C UnicodeNo:0x00C7], // big
             [[CharSet alloc] initWithCharSet:0x5D UnicodeNo:0x00D5], // O with tilde
             [[CharSet alloc] initWithCharSet:0x7B UnicodeNo:0x00E3], // a with tilde
             [[CharSet alloc] initWithCharSet:0x7C UnicodeNo:0x00E7], // little
             [[CharSet alloc] initWithCharSet:0x7D UnicodeNo:0x00F6], // o with tilde
             nil];
    
    NRCSpanish = [[NSArray alloc] initWithObjects:
              [[CharSet alloc] initWithCharSet:0x23 UnicodeNo:0x00A3], // pound sign
              [[CharSet alloc] initWithCharSet:0x40 UnicodeNo:0x00A7], // funny s
              [[CharSet alloc] initWithCharSet:0x5B UnicodeNo:0x00A1], // I with dot
              [[CharSet alloc] initWithCharSet:0x5C UnicodeNo:0x00D1], // N with tilde
              [[CharSet alloc] initWithCharSet:0x5D UnicodeNo:0x00BF], // Upside down question mark
              [[CharSet alloc] initWithCharSet:0x7B UnicodeNo:0x0060], // back single quote
              [[CharSet alloc] initWithCharSet:0x7C UnicodeNo:0x00B0], // Degree Symbol
              [[CharSet alloc] initWithCharSet:0x7D UnicodeNo:0x00F1], // n with tilde
              [[CharSet alloc] initWithCharSet:0x7E UnicodeNo:0x00E7], // small
              nil];
    
    NRCSwedish = [[NSArray alloc] initWithObjects:
              [[CharSet alloc] initWithCharSet:0x40 UnicodeNo:0x00C9], // E with acute
              [[CharSet alloc] initWithCharSet:0x5B UnicodeNo:0x00C4], // A with
              [[CharSet alloc] initWithCharSet:0x5C UnicodeNo:0x00D6], // O with
              [[CharSet alloc] initWithCharSet:0x5D UnicodeNo:0x00C5], // A with hollow dot above
              [[CharSet alloc] initWithCharSet:0x5E UnicodeNo:0x00DC], // U with
              [[CharSet alloc] initWithCharSet:0x60 UnicodeNo:0x00E9], // e with  accent
              [[CharSet alloc] initWithCharSet:0x7B UnicodeNo:0x00E4], // a with
              [[CharSet alloc] initWithCharSet:0x7C UnicodeNo:0x00F6], // o with
              [[CharSet alloc] initWithCharSet:0x7D UnicodeNo:0x00E5], // a with hollow dot above
              [[CharSet alloc] initWithCharSet:0x7E UnicodeNo:0x00FC], // u with
              nil];
    
    NRCSwiss = [[NSArray alloc] initWithObjects:
            [[CharSet alloc] initWithCharSet:0x23 UnicodeNo:0x00F9], // u with  accent
            [[CharSet alloc] initWithCharSet:0x40 UnicodeNo:0x00E0], // a with  accent
            [[CharSet alloc] initWithCharSet:0x5B UnicodeNo:0x00E9], // e with  accent
            [[CharSet alloc] initWithCharSet:0x5C UnicodeNo:0x00E7], // small
            [[CharSet alloc] initWithCharSet:0x5D UnicodeNo:0x00EA], // e with circumflex
            [[CharSet alloc] initWithCharSet:0x5E UnicodeNo:0x00CE], // i with circumflex
            [[CharSet alloc] initWithCharSet:0x5F UnicodeNo:0x00E8], // e with  accent
            [[CharSet alloc] initWithCharSet:0x60 UnicodeNo:0x00F4], // o with
            [[CharSet alloc] initWithCharSet:0x7B UnicodeNo:0x00E4], // a with
            [[CharSet alloc] initWithCharSet:0x7C UnicodeNo:0x00F6], // o with
            [[CharSet alloc] initWithCharSet:0x7D UnicodeNo:0x00FC], // u with
            [[CharSet alloc] initWithCharSet:0x7E UnicodeNo:0x00FB], // u with circumflex
            nil];
    
    ISOLAtin1S = [[NSArray alloc] initWithObjects:
              [[CharSet alloc] initWithCharSet:0x00 UnicodeNo:0x0000],
              nil];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initArrys];
    }
    return self;
}

@end

@interface Chars ()

@property (nonatomic) CharsData *charsData;
@end

@implementation Chars

@synthesize set, charsData;

- (id)init
{
    self = [super init];
    if (self) {
        charsData = [CharsData shareStore];
    }
    return self;
}

- (id)initWithChars:(enum CharsSets)p
{
    self.set = p;
    return [self init];
}


- (unsigned short)Get:(unsigned short)curChar GL:(enum CharsSets)GL GR:(enum CharsSets)GR
{
    NSMutableArray *curSet = [[NSMutableArray alloc] init];
    
    // I'm assuming the left hand in use table will always have a 00-7F char set in it
    //假定当前处理的是0到128之间的字符
    if (curChar < 128)
    {
        switch (GL)
        {
            case CharsSet_ASCII:
                [curSet addObjectsFromArray:[charsData ASCII]];
                break;
                
            case CharsSet_DECSG:
                [curSet addObjectsFromArray:[charsData DECSG]];
                break;
                
            case CharsSet_NRCUK:
                [curSet addObjectsFromArray:[charsData NRCUK]];
                break;
                
            case CharsSet_NRCFinnish:
                [curSet addObjectsFromArray:[charsData NRCFinnish]];
                break;
                
            case CharsSet_NRCFrench:
                [curSet addObjectsFromArray:[charsData NRCFrench]];
                break;
                
            case CharsSet_NRCFrenchCanadian:
                [curSet addObjectsFromArray:[charsData NRCFrenchCanadian]];
                break;
                
            case CharsSet_NRCGerman:
                [curSet addObjectsFromArray:[charsData NRCGerman]];
                break;
                
            case CharsSet_NRCItalian:
                [curSet addObjectsFromArray:[charsData NRCItalian]];
                break;
                
            case CharsSet_NRCNorDanish:
                [curSet addObjectsFromArray:[charsData NRCNorDanish]];
                break;
                
            case CharsSet_NRCPortuguese:
                [curSet addObjectsFromArray:[charsData NRCPortuguese]];
                break;
                
            case CharsSet_NRCSpanish:
                [curSet addObjectsFromArray:[charsData NRCSpanish]];
                break;
                
            case CharsSet_NRCSwedish:
                [curSet addObjectsFromArray:[charsData NRCSwedish]];
                break;
                
            case CharsSet_NRCSwiss:
                [curSet addObjectsFromArray:[charsData NRCSwiss]];
                break;
                
            default:
                [curSet addObjectsFromArray:[charsData ASCII]];
                break;
        }
    }
    // I'm assuming the right hand in use table will always have a 80-FF char set in it
    //假定此处用于处理128到255之间的字符
    else
    {
        switch (GR)
        {
            case CharsSet_ISOLatin1S:
                [curSet addObjectsFromArray:[charsData ISOLAtin1S]];
                break;
                
            case CharsSet_DECS:
                [curSet addObjectsFromArray:[charsData DECS]];
                break;
                
            default:
                [curSet addObjectsFromArray:[charsData DECS]];
                break;
        }
    }
    
    int len = (int)[curSet count];
    for (int i = 0; i < len; i++)
    {
        id tmp = [curSet objectAtIndex:i];
        CharSet *charSet = tmp;
        if (charSet.Location == curChar)
        {
//            NSData *data = [NSData dataWithBytes: &i length: sizeof(charSet.UnicodeNo)];

            
            return charSet.UnicodeNo;
        }
        
    }
    
    return curChar;
}


@end
