//
//  ParserMsg.m
//  SmartClient
//
//  Created by sun on 13-10-18.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "ParserMsg.h"
#import "SettingStore.h"
#import "SettingForRuntime.h"
#import "CaretAttribs.h"

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface Params : NSObject

- (int) Count;
- (void) Clear;
- (void) add:(unsigned short int) curChar;
@property (nonatomic) NSMutableArray *elements;

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
    return (int)self.elements.count;
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
        int i = self.Count -1;
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
    int len = (int)[elments count];
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

@interface CharEvnet : NSObject
{
    NSMutableDictionary *elmentsDict;
    int currentIndex;
}
- (NSArray *) getStateEventAction:(enum States)curState curChar:(unsigned short int) curChar;
- (void) setElemrntsDicts;
@end

@implementation CharEvnet

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


@interface ParserMsg ()
{
    CharEvnet *charEvents;
    StateChangeEvent *stateChangeEvents;
    Params *params;
    unsigned short int curChar;
    enum States state;
    NSString *curNSString;
    NSString *printParseString;
    SettingForRuntime *settings;
    SettingForConnect *settingStore;
    BOOL isReceiveBytes;
}


@property (nonatomic, copy) NSString *curSequence;
@property (nonatomic, copy) NSString *curDefineSequence;
@property (nonatomic, copy) NSString *curMessage;

- (void) doAction:(enum Actions)nextAction;
- (void) commandRouter:(enum Actions)nextAction;
- (void) defineCommandRouter:(enum Actions)nextAction;
- (void) printChar;
- (void) executeChar;
- (void) caretToAbs:(int)Y CaretX:(int)X;
- (void) CaretToRel:(int)Y CaretX:(int)X;

@end

@implementation ParserMsg

- (id)init
{
    self = [super init];
    if (self)
    {
        charEvents = [[CharEvnet alloc] init];
        stateChangeEvents = [[StateChangeEvent alloc] init];
        params = [[Params alloc] init];
        state = Ground;
        settings = [SettingForRuntime shareStore];
        settingStore = [[SettingStore shareStore] getSettings];
    }
    
    return self;
}

@synthesize curDefineSequence, curMessage, curSequence;
- (void)parserString:(NSString *)msg
{
    enum States nextState = None;
    enum Actions nextAction = ActionNone;
    enum Actions stateExitAction = ActionNone;
    enum Actions stateEntryAction = ActionNone;
    
    NSArray *states;
    
    unsigned long len = [msg length];
    for (int i=0; i<len; i++) {
        if (isReceiveBytes) {
            return;
        }
        
        curNSString = [msg substringWithRange:NSMakeRange(i, 1)];
        NSData *n = [curNSString dataUsingEncoding:[[[SettingStore shareStore] getSettings] enc]];
        [n getBytes:&curChar];
        NSLog(@"s=%@, len=%lu, %@  un= %x", curNSString,(unsigned long)[n length], n, curChar);
        states = [charEvents getStateEventAction:state curChar:curChar];
        
        nextState = (enum States) states[0];
        nextAction = (enum Actions) states[1];
        
        if (nextState != None && nextState != state)
        {
            stateExitAction = [stateChangeEvents GetStateChangeAction:state Transitions:Exit Actions:stateExitAction];
            if (stateExitAction != ActionNone)
            {
                [self doAction:stateExitAction];
            }
        }
        
        if (nextAction != ActionNone)
        {
            [self doAction:nextAction];
        }
        
        if (nextState != None && nextState != state)
        {
            state = nextState;
            stateExitAction = [stateChangeEvents GetStateChangeAction:state Transitions:Entry Actions:stateExitAction];
            if (stateEntryAction != ActionNone)
            {
                [self doAction:stateEntryAction];
            }
        }
    }
    
}

- (void)doAction:(enum Actions)nextAction
{
    switch(nextAction)
    {
        case Dispatch:
        case Collect:
            self.curSequence = [self.curSequence stringByAppendingString:curNSString];
            break;
        case NewCollect:
            self.curDefineSequence = curNSString;
            self.curMessage = @"";
            self.curSequence = curNSString;
            [params Clear];
            break;
        case Param:
            [params add:curChar];
            break;
        case DefineSequence:
            self.curDefineSequence =[self.curDefineSequence stringByAppendingString:curNSString];
            break;
        case Message:
            self.curMessage =[self.curMessage stringByAppendingString:curNSString];
            break;
        default:
            break;
    }
    
    switch (nextAction)
    {
        case Dispatch:
        case Execute:
        case Put:
        case OscStart:
        case OscPut:
        case OscEnd:
        case Hook:
        case Unhook:
        case Print:
            //只有在状态为Print的时候,才会开始进行输出,并且会把当前字符,下一个动作,当前命令序列和当前参数变量发送过去
            //CommandRouter.cs的CommandRouter
            [self commandRouter:nextAction];
            break;
        case SpecialExecute :
            self.curDefineSequence =[self.curDefineSequence stringByAppendingString:curNSString];
            //去处理当前的特殊的定义的操作
            [self defineCommandRouter:nextAction];
            //因为CurSequence在当遇到27时,会有值,直接影响到正常的解析,所以要在显示完自定义的字符后,清空当前的正常TELNET的序列
            self.CurSequence = @"";
            [params Clear];
            break;
        default:
            break;
    }
    //当前为Dispatch时,就清空当前命令序列和参数变量
    switch (nextAction)
    {
        case Dispatch:
            self.CurSequence = @"";
            [params Clear];
            self.CurDefineSequence = @"";
            self.CurMessage = @"";
            break;
        default:
            break;
    }
    
    //对这里的命令进行处理.用于接收字节数据.
    if (nextAction == SpecialExecute){
        if ([self.curDefineSequence isEqualToString: CUSACTIVE_IMG] || [self.curDefineSequence isEqualToString:CUSACTIVE_WAV])
            isReceiveBytes = true;
    }
    
}

- (void)commandRouter:(enum Actions)nextAction
{
    switch(nextAction)
    {
        case Print:
            //将需要打印的字符保存到数组中
//            PrintChar(curChar);
            break;
        case Execute:
//            ExecuteChar(curChar);
            break;
        case Dispatch:
            break;
        default:
            break;
    }
    
    if ([self.curSequence length] > 0 && [printParseString length] > 0)
    {
        //当前更换CurSequence,并且printParseString存在字符并且Y坐标位置改变时.打印字符
//        this.showStringEvent.onShowString(this, new ShowListEventArgs(curPrintParsePoint, printParseString, printCharAttribs, settings.Caret.Pos));
    }
    
    int Param = 0;
    
    int Inc = 1; // increment
    
    if([self.curSequence isEqualToString:@""])
    {
        //当为空的时候应当输出
        if (nextAction == Print)
        {
            printParseString = [printParseString stringByAppendingString:curNSString];
            if([printParseString rangeOfString:@("__")].location != NSNotFound){
//                settings.CurBGColor = settings.charAttribs.AltBGColor;
            }
        }
    }
    else if ([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"7"]])
    {
        //DECSC Save Cursor position and attributes保存当前光标位置和属性
        CaretAttribs *attr = [[CaretAttribs alloc] initWithPos:settings.caret.pos G0Set:settings.G0.set G1Set:settings.G1.set G2Set:settings.G2.set G3Set:settings.G3.set CharAttribs:settings.charAttribs];
        
        [settings.saveCarets addObject:attr];
        
    }
    else if ([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"8"]])
    {
        //DECRC Restore Cursor position and attributes重新载入光标位置和属性
        int len = [ settings.saveCarets count];
        id tmp = [settings.saveCarets objectAtIndex:(len - 1)];
        CaretAttribs *attr = tmp;
        settings.caret.Pos = attr.pos;
        settings.charAttribs = attr.attribs;
        settings.G0.Set = attr.G0Set;
        settings.G1.Set = attr.G1Set;
        settings.G2.Set = attr.G2Set;
        settings.G3.Set = attr.G3Set;
        
        [settings.saveCarets removeObject:tmp];
        
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"~"]])
    {
        //LS1R Locking Shift G1 -> GR
        settings.charAttribs.GR = settings.G1;
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"n"]])
    { //LS2 Locking Shift G2 -> GL
        settings.charAttribs.GL = settings.G2;
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"}"]])
    {//LS2R Locking Shift G2 -> GR
        settings.charAttribs.GR = settings.G2;
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"o"]])
    { //LS3 Locking Shift G3 -> GL
        settings.charAttribs.GL = settings.G3;
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"|"]])
    { //LS3R Locking Shift G3 -> GR
        settings.charAttribs.GR = settings.G3;
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"#8"]]){
        //DECALN
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"="]]){
        //case "(char)0x1b=": // Keypad to Application mode
        settings.mode.flags = settings.mode.flags | KeypadAppln;
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @">"]]){
        //case "(char)0x1b>": // Keypad to Numeric mode
        settings.mode.flags = settings.mode.flags ^ KeypadAppln;
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[B"]]){
        //case "(char)0x1b[B": // CUD
        
        if ([params Count] > 0)
        {
            id tmp = [params.elements objectAtIndex:0];
            Inc = [tmp intValue];
        }
        
        if (Inc == 0) Inc = 1;
        
        [self caretToAbs:(settings.caret.pos.y + Inc) CaretX:settings.caret.pos.x];
        
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[A"]]){
        //case "(char)0x1b[A": // CUU
        
        if ([params Count] > 0)
        {
            id tmp = [params.elements objectAtIndex:0];
            Inc = [tmp intValue];
        }
        
        if (Inc == 0) Inc = 1;
        
        [self caretToAbs:(settings.caret.pos.y - Inc) CaretX:settings.caret.pos.x];
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[C"]]){
        //case "(char)0x1b[C": // CUF
        
        if ([params Count] > 0)
        {
            id tmp = [params.elements objectAtIndex:0];
            Inc = [tmp intValue];
        }
        
        if (Inc == 0) Inc = 1;
        [self caretToAbs:settings.caret.pos.y CaretX:(settings.caret.pos.x + Inc)];
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[D"]]){
        //case "(char)0x1b[D": // CUB
        
        if ([params Count] > 0)
        {
            id tmp = [params.elements objectAtIndex:0];
            Inc = [tmp intValue];
        }
        
        if (Inc == 0) Inc = 1;
        [self caretToAbs:settings.caret.pos.y CaretX:(settings.caret.pos.x - Inc)];
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[H"]] || [self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[f"]]){
        //case "(char)0x1b[H": // CUP?无操作?
        //case "(char)0x1b[f": // HVP
        
        int X = 0;
        int Y = 0;
        
        if ([params Count] > 0)
        {
            id tmp = [params.elements objectAtIndex:0];
            Y = [tmp intValue] -1;
        }
        
        if ([params Count] > 1)
        {
            id tmp = [params.elements objectAtIndex:1];
            Inc = [tmp intValue] - 1;
        }
        
        [self CaretToRel:Y CaretX:X];
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[J"]])
    {   //case "(char)0x1b[J":
        
        if ([params Count] > 0)
        {
            id tmp = [params.elements objectAtIndex:0];
            Param = [tmp intValue];
        }
        ClearDown(Param);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[K"]])
    {    //case "(char)0x1b[K":
        
        if ([params Count] > 0)
        {
            id tmp = [params.elements objectAtIndex:0];
            Param = [tmp intValue];
        }
        ClearRight(Param);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[L"]])
    {    //case "(char)0x1b[L": // INSERT LINE
        //this.InsertLine(e.CurParams);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[M"]])
    {    //case "(char)0x1b[M": // DELETE LINE
        //this.DeleteLine(e.CurParams);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"N"]])
    {    //case "(char)0x1bN": // SS2 Single Shift (G2 -> GL)
        settings.charAttribs.GS = settings.G2;
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"O"]])
    {    //case "(char)0x1bO": // SS3 Single Shift (G3 -> GL)
        settings.charAttribs.GS = settings.G3;
        //System.Console.WriteLine ("SS3: GS = {0}", settings.charAttribs.GS);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[m"]])
    {    //case "(char)0x1b[m"://颜色设置
        SetCharAttribs(params);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[?h"]])
    {    //case "(char)0x1b[?h"://ESC加?加h命令
        SetqmhMode(e.CurParams);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[?l"]])
    {    //case "(char)0x1b[?l"://ESC加?加l命令
        SetqmlMode(e.CurParams);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[c"]])
    {    //case "(char)0x1b[c": // DA Device Attributes
        //                    this.DispatchMessage (this, "(char)0x1b[?64;1;2;6;7;8;9c");
        DispatchMessage(this, (char)0x1b+"[?6c");
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[g"]])
    {    //case "(char)0x1b[g":
        //this.ClearTabs(e.CurParams);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[h"]])
    {    //case "(char)0x1b[h":
        SethMode(e.CurParams);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[l"]])
    {    //case "(char)0x1b[l":
        SetlMode(e.CurParams);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[r"]])
    {    //case "(char)0x1b[r": // DECSTBM Set Top and Bottom Margins
        SetScrollRegion(e.CurParams);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"[t"]])
    {    //case "(char)0x1b[t": // DECSLPP Set Lines Per Page
        
        if ([params Count] > 0)
        {
            id tmp = [params.elements objectAtIndex:0];
            Param = [tmp intValue];
        }
        
        //if (Param > 0) this.SetSizeEvent(Param, CharAndAttribGrid.Columns);
        
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"D"]])
    {    //case "(char)0x1b" + "D": // IND
        
        if ([params Count] > 0)
        {
            id tmp = [params.elements objectAtIndex:0];
            Param = [tmp intValue];
        }
        
        //this.Index(Param);
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"E"]])
    {    //case "(char)0x1b" + "E": // NEL
        //this.LineFeed();
        //this.CarriageReturn();
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"H"]])
    {    //case "(char)0x1bH": // HTS
        //this.TabSet();
    }
    else if([self.curSequence isEqualToString:[NSString stringWithFormat:@"%c%@", (char)0x1b, @"M"]])
    {    //case "(char)0x1bM": // RI
        if ([params Count] > 0)
        {
            id tmp = [params.elements objectAtIndex:0];
            Param = [tmp intValue];
        }
        
        //this.ReverseIndex(Param);
    }
    //default:
    //System.Console.Write ("unsupported VT sequence {0} happened\n", e.CurSequence);
    //break;
    
}

- (void) defineCommandRouter:(enum Actions)nextAction
{
//    String vtProtocol=e.CurDefineSequence.toUpperCase();
//    if (vtProtocol.equals(settings.cusActive_Msg)){
//        if (ShowMessageEvent!=null) ShowMessageEvent.OnShowMessage(e.CurMessage);
//    }
//    else if(vtProtocol.equals(settings.cusActive_Img) || vtProtocol.equals(settings.cusActive_Wav)){
//        streamArgs = new IOStreamEventArgs(e.Action, e.CurDefineSequence, e.CurMessage);
//        Comms.isReceiveBytes = true;
//    }else if(vtProtocol.equals(settings.cusActive_MSGBOX) || vtProtocol.equals(settings.cusActive_CAM) ||
//             vtProtocol.equals(settings.cusActive_GPS) || vtProtocol.equals(settings.cusActive_WEB)||
//             vtProtocol.equals(settings.cusActive_OptionDialog) || vtProtocol.equals(settings.cusActive_VOICE)){
//        if (VTProtocolExtendEvent!=null) VTProtocolExtendEvent.VTProtocolExtend(e);
//    }
}

- (void) printChar
{
    if (settings.caret.EOL == YES) {
        if ((settings.mode.flags & AutoWrap) == AutoWrap) {
            settings.caret.EOL = NO;
        }
    }
    
    // 当前光标位置默认为0
    int X = settings.caret.pos.x;
    int Y = settings.caret.pos.y;
    
    // 在当前printParseString为空的时候,记录当前的位置信息
    // 记录当前的X位置,Y位置,第一个字符的属性.放在Comms的静态变量中.
    if ([printParseString isEqualToString:@""]) {
        Comms.curPrintParsePoint.x = X;
        Comms.curPrintParsePoint.y = Y;
        Comms.printCharAttribs = settings.charAttribs;
    }
    
    // System.Int32 X = 10;
    // System.Int32 Y = 10;
    
    // 当前位置的字符属性
    // CharAndAttribGrid.AttribGrid[Y][X] = settings.charAttribs;
    
    // uc_Chars.Get......对于中文的结果分析:
    if (settings.charAttribs.GS) {
        curChar = [[[Chars alloc] init] Get:curChar GL:settings.charAttribs.GS.set GR:setinngs.charAttribs.GR.set];
        
        if (settings.charAttribs.GS.set == DECSG)
            settings.charAttribs.IsDECSG = YES;
        
        settings.charAttribs.GS = nil;
    } else {
        // 对收到的字符,进行属性解析
        curChar = [[[Chars alloc] init] Get:curChar GL:settings.charAttribs.GL.set GR:setinngs.charAttribs.GR.set];
        if (settings.charAttribs.GL.set == DECSG)
            settings.charAttribs.IsDECSG = YES;
    }
    
    if (curChar >= 0x1000)
    {
        settings.caret.pos.x += 2;
    }
    else
    {
        settings.caret.pos.x += 1;
    }
}

- (void) CaretToRel:(int)Y CaretX:(int)X
{
    
    settings.caret.EOL = NO;
    /* This code is used when we get a cursor position command from
     the host. Even if we're not in relative mode we use this as this will
     sort that out for us. The ToAbs code is used internally by this prog
     but is smart enough to stay within the margins if the originrelative
     flagis set. */
    
    /*
     * 这个代码用于设置当我们从服务器接收到光标的位置
     */
    
    if ((settings.mode.flags & OriginRelative) == 0)
    {
        [self caretToAbs:Y CaretX:X];
        return;
    }
    
    /* the origin mode is relative so add the top and left margin
     to Y and X respectively */
    Y += [settingStore topMargin];
    
    if (X < 0)
    {
        X = 0;
    }
    
    if (Y < [settingStore topMargin])
    {
        Y = [settingStore topMargin];
    }
    
//    if (Y > Settings.getBottomMargin())
//    {
//        Y = Settings.getBottomMargin();
//    }
    
    settings.caret.pos.y = Y;
    settings.caret.pos.x = X;
}

- (void) caretToAbs:(int)Y CaretX:(int)X
{
    settings.caret.EOL = NO;
    
    if (X < 0)
    {
        X = 0;
    }
    
    if (Y < 0 && (settings.mode.flags & OriginRelative) == 0)
    {
        Y = 0;
    }
    
    settings.caret.pos.y = Y;
    settings.caret.pos.x = X;
}

- (void) executeChar
{
    if (curChar==0x05)
    {
        this.DispatchMessage(this, "vt100");
    }
    else if(curChar==0x07)
    {
        if (settings.getisBeep()==true && settings.mediaPlayer != null)
            settings.mediaPlayer.start();
    }
    else if(curChar==0x08)
        this.CaretLeft();
    else if(curChar==0x09){}
    else if(curChar==0x0A||curChar==0x0B||curChar==0x0C||curChar==0x84)
        Comms.printParseString +=String.valueOf(curChar);
    else if(curChar==0x0D){}
    else if(curChar==0x0E)
        settings.charAttribs.GL = settings.G1;
    else if(curChar==0x0F)
        settings.charAttribs.GL = settings.G0;
    else if(curChar==0x11){
        this.XOFF = false;
        this.DispatchMessage(this, "");
    }
    else if(curChar==0x13){
        this.XOFF = true;
        Comms.printParseString += String.valueOf(curChar);
    }
    else if(curChar==0x85)
        this.CaretToAbs(settings.Caret.Pos.y, 0);
    else if(curChar==0x88){}
    else if(curChar==0x8D){}
    else if(curChar==0x8E)
        settings.charAttribs.GS = settings.G2;
    else if(curChar==0x8F)
        settings.charAttribs.GS = settings.G3;
}
@end


