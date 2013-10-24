//
//  ShowListEventArgs.m
//  SmartClient
//
//  Created by sun on 13-10-23.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "ShowListEventArgs.h"
#import "SettingStore.h"
#import "Functions.h"

@implementation ShowListEventArgs

@synthesize curCaretPos, curCharAttribute, curChars, curPoint, curString;


- (void) setCurrentBytes:(NSString *)cstr
{
    if (cstr.length > 0)
    {
        int len = cstr.length;
        int offset = 0;
        for (int i=0; i<len; i++)
        {
            unsigned short int c = 0;
            NSString *item = [cstr substringWithRange:NSMakeRange(i, 1)];
            NSData *n = [item dataUsingEncoding:[[[SettingStore shareStore] getSettings] enc]];
            [n getBytes:&c];
            [self.curChars setObject:item forKey:[NSString stringWithFormat:@"%d",((int)curPoint.x+offset)]];
            if (c >= 0x1000)
            {
                offset += 2;
                [self.curChars setObject:@"" forKey:[NSString stringWithFormat:@"%d",((int)curPoint.x+offset - 1)]];
            }
            else
            {
                offset += 1;
            }
        }
    }
}

- (void) setCurStatus:(CharAttribs *)ca
{
    self.curCharAttribute = [[CharAttribs alloc] initWithCharAttribs:ca.IsBold IsDim:ca.IsDim IsUnderscored:ca.IsUnderscored IsBlinking:ca.IsBlinking IsInverse:ca.IsInverse IsPrimaryFont:ca.IsPrimaryFont IsAlternateFont:ca.IsAlternateFont UseAltColor:ca.UseAltColor AltColor:ca.AltColor UseAltBGColor:ca.UseAltBGColor AltBGColor:ca.AltBGColor GL:ca.GL GR:ca.GR GS:ca.GS ISDECSG:ca.IsDECSG];

    NSString *itemStr = @"";
    
    for (NSString * key in [curChars allKeys])
    {
        NSString *tmp = [curChars objectForKey:key];
        if (![tmp isEqualToString:@""]) {
            itemStr = [itemStr stringByAppendingString:tmp];
        }
    }
    curString = itemStr;
}

//- (CGSize)curPointSize
//{
//    int xx=curPoint.x * (Settings.getCharSizeEN().width) + Settings.getLeftMargin(); //当前字体的宽度X位置+左边距
//    int yy=curPoint.y * (Settings.getCharSizeEN().height + Settings.getRowSpan())+ Settings.getTopMargin(); //（当前高度+行距）X位置+上边距
//    return new Size(xx,yy);
//}

//public Size curStringSize(){
//    if (curString.length() <= 0)
//        return new Size(0, 0);
//    else
//        //return Settings.MeasureGraphics.MeasureString(this.curString, Settings.getVTFont()).ToSize();
//        return new Size(0,0);
//}

//public Size curStringSizeByCharSize(){
//    if (curString.length() <= 0)
//        return new Size(0, 0);
//    else
//        return new Size((this.curCaretPos.x - this.curPoint.x) * (Settings.getCharSizeEN().width), Settings.getCharSizeEN().height);
//}

- (id) initShowListEventArgs:(CGPoint) _curPoint  String:(NSString *) _curString CharAttribs: (CharAttribs *) ca Point:(CGPoint) _curCaretPos
{
    self = [super init];
    if (self) {
        self.curPoint = CGPointMake(_curPoint.x, _curPoint.y);
        self.curString = _curString;
        self.curCharAttribute = [[CharAttribs alloc] initWithCharAttribs:ca.IsBold IsDim:ca.IsDim IsUnderscored:ca.IsUnderscored IsBlinking:ca.IsBlinking IsInverse:ca.IsInverse IsPrimaryFont:ca.IsPrimaryFont IsAlternateFont:ca.IsAlternateFont UseAltColor:ca.UseAltColor AltColor:ca.AltColor UseAltBGColor:ca.UseAltBGColor AltBGColor:ca.AltBGColor GL:ca.GL GR:ca.GR GS:ca.GS ISDECSG:ca.IsDECSG];
        self.curCaretPos = CGPointMake(_curCaretPos.x, _curCaretPos.y);
        self.curChars = [[NSMutableDictionary alloc] init];
        [self setCurrentBytes:_curString];
    }
    return self;

}

- (ShowListEventArgs*) AddShowList
{
    StringShowList *stringShowList = [StringShowList shareStore];
    if ([stringShowList.stringShowDics objectForKey:_TOSTRIING(curPoint.y)]){
        BOOL isadd=NO;
        NSMutableArray * tmp = [stringShowList.stringShowDics objectForKey:_TOSTRIING(curPoint.y)];
        for(id key in tmp)
        {
            ShowListEventArgs *item = key;
            NSString *key1 = _TOSTRIING(curPoint.x);
            NSString *key2 = _TOSTRIING(curCaretPos.x - 1);
            if ([item.curChars objectForKey:key1] && ([item.curChars objectForKey:key2] || curPoint.x == curCaretPos.x))
            {
                for (NSString * key in [curChars allKeys])
                {
                    NSString *tmp = [curChars objectForKey:key];
                    [item.curChars setObject:tmp forKey:key];
                }
    				
                isadd=YES;
                [item setCurStatus:curCharAttribute];
            }
        }
        if (!isadd)
        {
            NSMutableArray *showList = [stringShowList.stringShowDics objectForKey:_TOSTRIING(curPoint.y)];
            [showList addObject:self];
        }
    }
    else{
        NSMutableArray *showList = [[NSMutableArray alloc] init];
        [showList addObject:self];
        [stringShowList.stringShowDics setObject:showList forKey:_TOSTRIING(curPoint.y)];
    }
//
//    if(curString != null && curString.contains("___")){
//        Log.d("SUN-INPUT", "add input : curPoint = "+curPoint+"  length = "+stringShowList.inputStringLists.size());
//        Rect r = new Rect(curPoint.x, curPoint.y, curCaretPos.x, curCaretPos.y);
//        stringShowList.inputStringLists.add(r);
//    }
    return self;
}
@end
