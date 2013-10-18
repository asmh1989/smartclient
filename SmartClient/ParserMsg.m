//
//  ParserMsg.m
//  SmartClient
//
//  Created by sun on 13-10-18.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "ParserMsg.h"
#import "SettingStore.h"

enum States
{
    None,Ground,EscapeIntrmdt,Escape,CsiEntry,CsiIgnore,CsiParam,CsiIntrmdt,OscString,SosPmApcString,
	DcsEntry,DcsParam,DcsIntrmdt,DcsIgnore,DcsPassthrough,Anywhere,Message,SpecialDefine
};

enum Actions
{
    ActionNone,Dispatch,Execute,Ignore,Collect,NewCollect,
	Param,OscStart,OscPut,OscEnd,Hook,Unhook,Put,
	Print,ActionMessage,DefineSequence,SpecialExecute
};

enum Transitions
{
    TransitionNone, Entry, Exit
};

@class CharEvnets;
@class StateChangeEvent;
@class Params;

@interface ParserMsg ()
{
    CharEvnets *charEvents;
    StateChangeEvent *stateChangeEvents;
    Params * params;
    unsigned short int curChar;
}

@property (nonatomic) enum States state;
@property (nonatomic, copy) NSString *curSequence;
@property (nonatomic, copy) NSString *curDefinesequence;
@property (nonatomic, copy) NSString *curMessage;


@end

@implementation ParserMsg

@synthesize state, curDefinesequence, curMessage, curSequence;
- (void)parserString:(NSString *)msg
{
    enum States nextState = None;
    enum Actions nextActions = ActionNone;
    enum Actions stateExitAction = ActionNone;
    enum Actions stateEntryAction = ActionNone;
    
    NSArray *states;
    
    unsigned int len = [msg length];
    for (int i=0; i<len; i++) {
        NSString *s=[msg substringWithRange:NSMakeRange(i, 1)];
        NSData *n = [s dataUsingEncoding:[[[SettingStore shareStore] getSettings] enc]];
        [n getBytes:&curChar];
        NSLog(@"s=%@, len=%d, %@  un= %x", s,[n length], n, curChar);
        
    }
    
    
}

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface Params : NSObject

- (int) Count;
- (void) Clear;
- (void) add:(unsigned short int) curChar;

@end

@interface Params ()

@property (nonatomic) NSMutableArray * elements;
@end

@implementation Params
@synthesize  elements;

- (id)init
{
    self = [super init];
    if (self) {
        self.elements = [[NSMutableArray alloc] init];
    }
    return self;
}

- (int)Count
{
    return self.elements.count;
}

- (void)Clear
{
    [self.elements removeAllObjects];
}

- (void)add:(unsigned short int)curChar
{
    if (self.elements.count < 1) {
        [self.elements addObject:@"0"];
    }
    
    if (curChar == ';') {
        [self.elements addObject:@"0"];
    } else {
        int i = self.elements.count -1;
        NSString *s = [self.elements objectAtIndex:i];
        
        [self.elements setObject:[ NSString stringWithFormat:@"%@%c", s, curChar] atIndexedSubscript:i];
    }
    
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface StateChangeInfo : NSObject

@property (nonatomic) enum States state;
@property (nonatomic) enum Transitions transition;
@property (nonatomic) enum Actions action;

- (id)initWithData:(enum States)p1 Transition:(enum Transitions)p2 Action:(enum Actions)p3;
@end

@implementation StateChangeInfo

- (id)initWithData:(enum States)p1 Transition:(enum Transitions)p2 Action:(enum Actions)p3
{
    self = [super init];
    if (self) {
        [self setState:p1];
        [self setTransition:p2];
        [self setAction:p3];
    }
    
    return self;
}

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface StateChangeEvent : NSObject
{
    NSArray *elments;
}

- (enum Actions) GetStateChangeAction:(enum States)state Transitions:(enum Transitions)trans Actions:(enum Actions) act;
@end

@implementation StateChangeEvent

-  (enum Actions)GetStateChangeAction:(enum States)state Transitions:(enum Transitions)trans Actions:(enum Actions)act
{
    int len = [elments count];
    for (int i = 0; i < len; i++) {
        StateChangeInfo *info =[elments objectAtIndex:i];
        if (state == [info state] && trans == [info transition]) {
            return [info action];
        }
    }
    return act;
}

- (id)init
{
    self = [super init];
    if (self) {
        elments = [[NSArray alloc] initWithObjects:
                [[StateChangeInfo alloc] initWithData:OscString Transition:Entry Action:OscStart],
                [[StateChangeInfo alloc] initWithData:OscString Transition:Exit Action:OscEnd],
                [[StateChangeInfo alloc] initWithData:DcsPassthrough Transition:Entry Action:Hook],
                [[StateChangeInfo alloc] initWithData:DcsPassthrough Transition:Exit Action:Unhook], nil];
    }
    return self;
}

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CharEventInfo : NSObject
@property (nonatomic) enum States curState;
@property (nonatomic) unsigned short int charFrom;
@property (nonatomic) unsigned short int charTo;
@property (nonatomic) enum Actions nextAction;
@property (nonatomic) enum States nextState;


- (id) initWithData:(enum States)p1 CharFrom:(unsigned short int)p2 CharTo:(unsigned short int)p3 NextActions:(enum Actions)p4 NextState:(enum States)p5;
@end

@implementation CharEventInfo

@synthesize curState, charFrom, charTo, nextAction, nextState;

- (id)initWithData:(enum States)p1 CharFrom:(unsigned short int)p2 CharTo:(unsigned short int)p3 NextActions:(enum Actions)p4 NextState:(enum States)p5
{
    self = [super init];
    if (self) {
        curState = p1;
        charFrom = p2;
        charTo = p3;
        nextAction = p4;
        nextState = p5;
    }
    return self;
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface CharEvnets : NSObject
{
    NSMutableDictionary *elmentsDict;
    int currentIndex;
}
- (NSArray *) getStateEventAction:(enum States)curState curChar:(unsigned short int) curChar;
- (void) setElemrntsDicts;
@end

@implementation CharEvnets

- (NSMutableArray *)getStateEventAction:(enum States)curState curChar:(unsigned short int)curChar
{
    NSMutableArray * stateAndAction = [[NSMutableArray alloc] init];
    if ([[[SettingStore shareStore] getSettings] enc] == CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)) {
        if ((int)curChar >= 0x1000) {
            currentIndex += 2;
        } else {
            currentIndex += 1;
        }
    } else if([[[SettingStore shareStore] getSettings] enc] == NSUnicodeStringEncoding){
        currentIndex += 2;
    }
    if ((int)curChar >= 0xA0 && (int)curChar <= 0xFF) {
        curChar =(unsigned short int)((int) curChar - 0x80);
    }
    
    for (CharEventInfo *cei in [elmentsDict objectForKey:[NSString stringWithFormat:@"%d", curState]]) {
        if ((int)curChar >= [cei charFrom] && (int) curChar <= [cei charTo]) {
            [stateAndAction addObject:[NSString stringWithFormat:@"%d", [cei nextState]]];
            [stateAndAction addObject:[NSString stringWithFormat:@"%d", [cei nextAction]]];
            return stateAndAction;
        }
    }
    
    for (CharEventInfo *cei in [elmentsDict objectForKey:[NSString stringWithFormat:@"%d", Anywhere]] ) {
        if ((int)curChar >= [cei charFrom] && (int) curChar <= [cei charTo]) {
            [stateAndAction addObject:[NSString stringWithFormat:@"%d", [cei nextState]]];
            [stateAndAction addObject:[NSString stringWithFormat:@"%d", [cei nextAction]]];
            return stateAndAction;
        }
    }
    
    return stateAndAction;
}

- (void)setElemrntsDicts
{
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            //27 <- ASC符号,代表一个新的命令的开始
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x1B CharTo:(unsigned short int)0x1B NextActions:NewCollect NextState:Escape],
            //向上键头 24
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x18 CharTo:(unsigned short int)0x18 NextActions:Execute NextState:Ground],
            //-> 26
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x1A CharTo:(unsigned short int)0x1A NextActions:Execute NextState:Ground],
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x1A CharTo:(unsigned short int)0x1A NextActions:Execute NextState:Ground],
            //128到143
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x80 CharTo:(unsigned short int)0x8F NextActions:Execute NextState:Ground],
            //145到151
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x91 CharTo:(unsigned short int)0x97 NextActions:Execute NextState:Ground],
            //153
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x99 CharTo:(unsigned short int)0x99 NextActions:Execute NextState:Ground],
            //154
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x9A CharTo:(unsigned short int)0x9A NextActions:Execute NextState:Ground],
            //156
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x9C CharTo:(unsigned short int)0x9C NextActions:Execute NextState:Ground],
            //152
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x98 CharTo:(unsigned short int)0x98 NextActions:ActionNone NextState:SosPmApcString],
            //158-159
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x9E CharTo:(unsigned short int)0x9F NextActions:ActionNone NextState:SosPmApcString],
            //144
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x90 CharTo:(unsigned short int)0x90 NextActions:NewCollect NextState:DcsEntry],
            //157
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x9D CharTo:(unsigned short int)0x9D NextActions:ActionNone NextState:OscString],
            //155
            [[CharEventInfo alloc] initWithData:Anywhere CharFrom:(unsigned short int)0x9B CharTo:(unsigned short int)0x9B NextActions:NewCollect NextState:CsiEntry],
            nil]
            forKey: [NSString stringWithFormat:@"%d",Anywhere]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            //0-23
            [[CharEventInfo alloc] initWithData:Ground CharFrom:(unsigned short int)0x00 CharTo:(unsigned short int)0x17 NextActions:Execute NextState:None],
            //0-23
            [[CharEventInfo alloc] initWithData:Ground CharFrom:(unsigned short int)0x00 CharTo:(unsigned short int)0x17 NextActions:Execute NextState:None],
            //25
            [[CharEventInfo alloc] initWithData:Ground CharFrom:(unsigned short int)0x19 CharTo:(unsigned short int)0x19 NextActions:Execute NextState:None],
            //28到31
            [[CharEventInfo alloc] initWithData:Ground CharFrom:(unsigned short int)0x0C CharTo:(unsigned short int)0x1F NextActions:Execute NextState:None],
            //32(空格)到127
            [[CharEventInfo alloc] initWithData:Ground CharFrom:(unsigned short int)0x32 CharTo:(unsigned short int)0x127 NextActions:Print NextState:None],
            //汉字范围(具体的汉字范围)
            [[CharEventInfo alloc] initWithData:Ground CharFrom:(unsigned short int)0x1000 CharTo:(unsigned short int)0xFFFF NextActions:Print NextState:None],
            //128到143
            [[CharEventInfo alloc] initWithData:Ground CharFrom:(unsigned short int)0x80 CharTo:(unsigned short int)0x8F NextActions:Execute NextState:None],
            //145到154
            [[CharEventInfo alloc] initWithData:Ground CharFrom:(unsigned short int)0x91 CharTo:(unsigned short int)0x9A NextActions:Execute NextState:None],
            //156
            [[CharEventInfo alloc] initWithData:Ground CharFrom:(unsigned short int)0x9C CharTo:(unsigned short int)0x9C NextActions:Execute NextState:None],
            nil]
            forKey: [NSString stringWithFormat:@"%d",Ground]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            //0到23
            [[CharEventInfo alloc] initWithData:EscapeIntrmdt CharFrom:(unsigned short int)0x00 CharTo:(unsigned short int)0x17 NextActions:Execute NextState:None],
            //25
            [[CharEventInfo alloc] initWithData:EscapeIntrmdt CharFrom:(unsigned short int)0x19 CharTo:(unsigned short int)0x19 NextActions:Execute NextState:None],
            //28到31
            [[CharEventInfo alloc] initWithData:EscapeIntrmdt CharFrom:(unsigned short int)0x1C CharTo:(unsigned short int)0x1F NextActions:Execute NextState:None],
            //32空格到47/,解盘上的符号
            [[CharEventInfo alloc] initWithData:EscapeIntrmdt CharFrom:(unsigned short int)0x20 CharTo:(unsigned short int)0x47 NextActions:Collect NextState:None],
            //48 0到126 ~
            [[CharEventInfo alloc] initWithData:EscapeIntrmdt CharFrom:(unsigned short int)0x30 CharTo:(unsigned short int)0x7E NextActions:Dispatch NextState:Ground],
            nil]
            forKey: [NSString stringWithFormat:@"%d",EscapeIntrmdt]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            //0到23
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x00 CharTo:(unsigned short int)0x17 NextActions:Execute NextState:None],
            //25
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x19 CharTo:(unsigned short int)0x19 NextActions:Execute NextState:None],
            //28到31
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x0C CharTo:(unsigned short int)0x1F NextActions:Execute NextState:None],
            //58 X
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x58 CharTo:(unsigned short int)0x58 NextActions:ActionNone NextState:SosPmApcString],
            //94^ 到 95_
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x5E CharTo:(unsigned short int)0x5F NextActions:ActionNone NextState:SosPmApcString],
            //80 P
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x50 CharTo:(unsigned short int)0x50 NextActions:Collect NextState:DcsEntry],
            //93 ]
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x5D CharTo:(unsigned short int)0x5D NextActions:ActionNone NextState:OscString],
            //91 [
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x5B CharTo:(unsigned short int)0x5B NextActions:Collect NextState:CsiEntry],
            //48 0 到 59 O
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x30 CharTo:(unsigned short int)0x3B NextActions:Dispatch NextState:Ground],
            //60 < 处理我们当前自定义的命令
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x3C CharTo:(unsigned short int)0x3C NextActions:DefineSequence NextState:SpecialDefine],
            //61 = 到 79 O
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x3D CharTo:(unsigned short int)0x4F NextActions:Dispatch NextState:Ground],
            //81 Q 到 87 W
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x51 CharTo:(unsigned short int)0x57 NextActions:Dispatch NextState:Ground],
            //89 Y 到 90 Z
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x59 CharTo:(unsigned short int)0x5A NextActions:Dispatch NextState:Ground],
            //92 '\'
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x5C CharTo:(unsigned short int)0x5C NextActions:Dispatch NextState:Ground],
            //96 ` 到 126 ~
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x60 CharTo:(unsigned short int)0x7F NextActions:Dispatch NextState:Ground],
            //32空格到47/
            [[CharEventInfo alloc] initWithData:Escape CharFrom:(unsigned short int)0x20 CharTo:(unsigned short int)0x27 NextActions:Collect NextState:EscapeIntrmdt],
            nil]
            forKey: [NSString stringWithFormat:@"%d",Escape]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            //0到23
            [[CharEventInfo alloc] initWithData:CsiEntry CharFrom:(unsigned short int)0x00 CharTo:(unsigned short int)0x17 NextActions:Execute NextState:None],
            //25
            [[CharEventInfo alloc] initWithData:CsiEntry CharFrom:(unsigned short int)0x19 CharTo:(unsigned short int)0x19 NextActions:Execute NextState:None],
            //28到31(没有字符显示)
            [[CharEventInfo alloc] initWithData:CsiEntry CharFrom:(unsigned short int)0x1C CharTo:(unsigned short int)0x1F NextActions:Execute NextState:None],
            //32空格,33! 34" 35# 36$ 37% 38& 39' 40(
            //41) 42* 43+ 44, 45- 46. 47/
            [[CharEventInfo alloc] initWithData:CsiEntry CharFrom:(unsigned short int)0x20 CharTo:(unsigned short int)0x2F NextActions:Collect NextState:CsiIntrmdt],
            //58 : 冒号
            [[CharEventInfo alloc] initWithData:CsiEntry CharFrom:(unsigned short int)0x3A CharTo:(unsigned short int)0x3A NextActions:ActionNone NextState:CsiIgnore],
            //60 < 61= 62>  63 ?
            [[CharEventInfo alloc] initWithData:CsiEntry CharFrom:(unsigned short int)0x3C CharTo:(unsigned short int)0x3F NextActions:Collect NextState:CsiParam],
            //60到63
            [[CharEventInfo alloc] initWithData:CsiEntry CharFrom:(unsigned short int)0x3C CharTo:(unsigned short int)0x3F NextActions:Collect NextState:CsiParam],
            //48 0 到 57 9(数字1到9)
            [[CharEventInfo alloc] initWithData:CsiEntry CharFrom:(unsigned short int)0x30 CharTo:(unsigned short int)0x39 NextActions:Param NextState:CsiParam],
            //59 ; 分号
            [[CharEventInfo alloc] initWithData:CsiEntry CharFrom:(unsigned short int)0x3B CharTo:(unsigned short int)0x3B NextActions:Param NextState:CsiParam],
            [[CharEventInfo alloc] initWithData:CsiEntry CharFrom:(unsigned short int)0x3C CharTo:(unsigned short int)0x3F NextActions:Collect NextState:CsiParam],
            //64@ 到 126 ~
            [[CharEventInfo alloc] initWithData:CsiEntry CharFrom:(unsigned short int)0x40 CharTo:(unsigned short int)0x7E NextActions:Dispatch NextState:Ground],
            nil]
            forKey: [NSString stringWithFormat:@"%d",CsiEntry]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            [[CharEventInfo alloc] initWithData:CsiParam CharFrom:(unsigned short int)0x00 CharTo:(unsigned short int)0x17 NextActions:Execute NextState:None],
            [[CharEventInfo alloc] initWithData:CsiParam CharFrom:(unsigned short int)0x19 CharTo:(unsigned short int)0x19 NextActions:Execute NextState:None],
            [[CharEventInfo alloc] initWithData:CsiParam CharFrom:(unsigned short int)0x1C CharTo:(unsigned short int)0x1F NextActions:Execute NextState:None],
            //数字0到9
            [[CharEventInfo alloc] initWithData:CsiParam CharFrom:(unsigned short int)0x30 CharTo:(unsigned short int)0x39 NextActions:Param NextState:None],
            //59 ; 分号
            [[CharEventInfo alloc] initWithData:CsiParam CharFrom:(unsigned short int)0x3B CharTo:(unsigned short int)0x3B NextActions:Param NextState:None],
            //58 : 冒号
            [[CharEventInfo alloc] initWithData:CsiParam CharFrom:(unsigned short int)0x3A CharTo:(unsigned short int)0x3A NextActions:ActionNone NextState:CsiIgnore],
            //60 < 61= 62>  63 ?
            [[CharEventInfo alloc] initWithData:CsiParam CharFrom:(unsigned short int)0x3C CharTo:(unsigned short int)0x3F NextActions:ActionNone NextState:CsiIgnore],
            //32空格,33! 34" 35# 36$ 37% 38& 39' 40(
            //41) 42* 43+ 44, 45- 46. 47/
            [[CharEventInfo alloc] initWithData:CsiParam CharFrom:(unsigned short int)0x20 CharTo:(unsigned short int)0x2F NextActions:Collect NextState:CsiIntrmdt],
            //64@ 到 126 ~
            [[CharEventInfo alloc] initWithData:CsiParam CharFrom:(unsigned short int)0x40 CharTo:(unsigned short int)0x7E NextActions:Dispatch NextState:Ground],
            nil]
            forKey: [NSString stringWithFormat:@"%d",CsiParam]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            [[CharEventInfo alloc] initWithData:CsiIgnore CharFrom:(unsigned short int)0x00 CharTo:(unsigned short int)0x17 NextActions:Execute NextState:None],
            [[CharEventInfo alloc] initWithData:CsiIgnore CharFrom:(unsigned short int)0x19 CharTo:(unsigned short int)0x19 NextActions:Execute NextState:None],
            [[CharEventInfo alloc] initWithData:CsiIgnore CharFrom:(unsigned short int)0x1C CharTo:(unsigned short int)0x1F NextActions:Execute NextState:None],
            [[CharEventInfo alloc] initWithData:CsiIgnore CharFrom:(unsigned short int)0x40 CharTo:(unsigned short int)0x7E NextActions:ActionNone NextState:Ground],
            nil]
            forKey: [NSString stringWithFormat:@"%d",CsiIgnore]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            [[CharEventInfo alloc] initWithData:CsiIntrmdt CharFrom:(unsigned short int)0x00 CharTo:(unsigned short int)0x17 NextActions:Execute NextState:None],
            [[CharEventInfo alloc] initWithData:CsiIntrmdt CharFrom:(unsigned short int)0x19 CharTo:(unsigned short int)0x19 NextActions:Execute NextState:None],
            [[CharEventInfo alloc] initWithData:CsiIntrmdt CharFrom:(unsigned short int)0x1C CharTo:(unsigned short int)0x1F NextActions:Execute NextState:None],
            [[CharEventInfo alloc] initWithData:CsiIntrmdt CharFrom:(unsigned short int)0x20 CharTo:(unsigned short int)0x2F NextActions:Collect NextState:None],
            [[CharEventInfo alloc] initWithData:CsiIntrmdt CharFrom:(unsigned short int)0x30 CharTo:(unsigned short int)0x3F NextActions:ActionNone NextState:CsiIgnore],
            [[CharEventInfo alloc] initWithData:CsiIntrmdt CharFrom:(unsigned short int)0x40 CharTo:(unsigned short int)0x75 NextActions:Dispatch NextState:Ground],
            nil]
            forKey: [NSString stringWithFormat:@"%d",CsiIntrmdt]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            //156
            [[CharEventInfo alloc] initWithData:SosPmApcString CharFrom:(unsigned short int)0x9C CharTo:(unsigned short int)0x9C NextActions:ActionNone NextState:Ground],
            nil]
    forKey: [NSString stringWithFormat:@"%d",SosPmApcString]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            [[CharEventInfo alloc] initWithData:DcsEntry CharFrom:(unsigned short int)0x20 CharTo:(unsigned short int)0x2F NextActions:Collect NextState:DcsIntrmdt],
            [[CharEventInfo alloc] initWithData:DcsEntry CharFrom:(unsigned short int)0x3A CharTo:(unsigned short int)0x3A NextActions:ActionNone NextState:DcsIgnore],
            [[CharEventInfo alloc] initWithData:DcsEntry CharFrom:(unsigned short int)0x30 CharTo:(unsigned short int)0x39 NextActions:Param NextState:DcsParam],
            [[CharEventInfo alloc] initWithData:DcsEntry CharFrom:(unsigned short int)0x3B CharTo:(unsigned short int)0x3B NextActions:Param NextState:DcsParam],
            [[CharEventInfo alloc] initWithData:DcsEntry CharFrom:(unsigned short int)0x3C CharTo:(unsigned short int)0x3F NextActions:Collect NextState:DcsParam],
            [[CharEventInfo alloc] initWithData:DcsEntry CharFrom:(unsigned short int)0x40 CharTo:(unsigned short int)0x7E NextActions:ActionNone NextState:DcsPassthrough],
            nil]
            forKey: [NSString stringWithFormat:@"%d",DcsEntry]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            [[CharEventInfo alloc] initWithData:DcsIntrmdt CharFrom:(unsigned short int)0x30 CharTo:(unsigned short int)0x3F NextActions:ActionNone NextState:DcsIgnore],
            [[CharEventInfo alloc] initWithData:DcsIntrmdt CharFrom:(unsigned short int)0x40 CharTo:(unsigned short int)0x7E NextActions:ActionNone NextState:DcsPassthrough],
            nil]
            forKey: [NSString stringWithFormat:@"%d",DcsIntrmdt]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            [[CharEventInfo alloc] initWithData:DcsIgnore CharFrom:(unsigned short int)0x9C CharTo:(unsigned short int)0x9C NextActions:ActionNone NextState:Ground],
            nil]
            forKey: [NSString stringWithFormat:@"%d",DcsIgnore]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            [[CharEventInfo alloc] initWithData:DcsParam CharFrom:(unsigned short int)0x30 CharTo:(unsigned short int)0x39 NextActions:Param NextState:None],
            [[CharEventInfo alloc] initWithData:DcsParam CharFrom:(unsigned short int)0x3B CharTo:(unsigned short int)0x3B NextActions:Param NextState:None],
            [[CharEventInfo alloc] initWithData:DcsParam CharFrom:(unsigned short int)0x20 CharTo:(unsigned short int)0x2F NextActions:Collect NextState:DcsIntrmdt],
            [[CharEventInfo alloc] initWithData:DcsParam CharFrom:(unsigned short int)0x3A CharTo:(unsigned short int)0x3A NextActions:ActionNone NextState:DcsIgnore],
            [[CharEventInfo alloc] initWithData:DcsParam CharFrom:(unsigned short int)0x3C CharTo:(unsigned short int)0x3F NextActions:ActionNone NextState:DcsIgnore],
            nil]
            forKey: [NSString stringWithFormat:@"%d",DcsParam]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            [[CharEventInfo alloc] initWithData:SosPmApcString CharFrom:(unsigned short int)0x9C CharTo:(unsigned short int)0x9C NextActions:ActionNone NextState:Ground],
                            nil]
                    forKey: [NSString stringWithFormat:@"%d",SosPmApcString]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            [[CharEventInfo alloc] initWithData:DcsPassthrough CharFrom:(unsigned short int)0x00 CharTo:(unsigned short int)0x17 NextActions:Put NextState:None],
            [[CharEventInfo alloc] initWithData:DcsPassthrough CharFrom:(unsigned short int)0x19 CharTo:(unsigned short int)0x19 NextActions:Put NextState:None],
            [[CharEventInfo alloc] initWithData:DcsPassthrough CharFrom:(unsigned short int)0x1C CharTo:(unsigned short int)0x1F NextActions:Put NextState:None],
            [[CharEventInfo alloc] initWithData:DcsPassthrough CharFrom:(unsigned short int)0x20 CharTo:(unsigned short int)0x7E NextActions:Put NextState:None],
            [[CharEventInfo alloc] initWithData:DcsPassthrough CharFrom:(unsigned short int)0x9C CharTo:(unsigned short int)0x9C NextActions:ActionNone NextState:Ground],
            nil]
            forKey: [NSString stringWithFormat:@"%d",DcsPassthrough]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            [[CharEventInfo alloc] initWithData:OscString CharFrom:(unsigned short int)0x20 CharTo:(unsigned short int)0x7F NextActions:OscPut NextState:None],
            [[CharEventInfo alloc] initWithData:OscString CharFrom:(unsigned short int)0x9C CharTo:(unsigned short int)0x9C NextActions:ActionNone NextState:Ground],
            nil]
            forKey: [NSString stringWithFormat:@"%d",OscString]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            //32 backspace
            [[CharEventInfo alloc] initWithData:SpecialDefine CharFrom:(unsigned short int)0x20 CharTo:(unsigned short int)0x20 NextActions:DefineSequence NextState:Message],
            //33 94
            [[CharEventInfo alloc] initWithData:SpecialDefine CharFrom:(unsigned short int)0x21 CharTo:(unsigned short int)0x5E NextActions:DefineSequence NextState:None],
            //96 127
            [[CharEventInfo alloc] initWithData:SpecialDefine CharFrom:(unsigned short int)0x60 CharTo:(unsigned short int)0x7F NextActions:DefineSequence NextState:None],
            //_95
            [[CharEventInfo alloc] initWithData:SpecialDefine CharFrom:(unsigned short int)0x5F CharTo:(unsigned short int)0x5F NextActions:DefineSequence NextState:Message],
            nil]
            forKey: [NSString stringWithFormat:@"%d",SpecialDefine]
     ];
    
    [elmentsDict setObject:[[ NSArray alloc] initWithObjects:
            [[CharEventInfo alloc] initWithData:Message CharFrom:(unsigned short int)0x20 CharTo:(unsigned short int)0x3D NextActions:ActionMessage NextState:None],
            [[CharEventInfo alloc] initWithData:Message CharFrom:(unsigned short int)0x3F CharTo:(unsigned short int)0xFFFF NextActions:ActionMessage NextState:None],
            //> 62 当自定义的结束时,就转到原来的AnyWhere状态,并执行SpecialExcute
            [[CharEventInfo alloc] initWithData:Message CharFrom:(unsigned short int)0x3E CharTo:(unsigned short int)0x3E NextActions:SpecialExecute NextState:Ground],
            nil]
            forKey: [NSString stringWithFormat:@"%d",Message]
     ];
    
}

- (id)init
{
    self = [super init];
    if (self) {
        elmentsDict = [[ NSMutableDictionary alloc] init];
        [self setElemrntsDicts];
    }
    return self;
}

@end

