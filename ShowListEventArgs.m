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

@synthesize curCaretPos, curCharAttribute, curPoint, curString;


//- (void) setCurrentBytes:(NSString *)cstr
//{
//    if (cstr.length > 0)
//    {
//        int len = cstr.length;
//        int offset = 0;
//        for (int i=0; i<len; i++)
//        {
//            unsigned short int c = 0;
//            NSString *item = [cstr substringWithRange:NSMakeRange(i, 1)];
//            NSData *n = [item dataUsingEncoding:[[[SettingStore shareStore] getSettings] enc]];
//            [n getBytes:&c];
//            [self.curChars setObject:item forKey:[NSString stringWithFormat:@"%d",((int)curPoint.x+offset)]];
//            if (c >= 0x1000)
//            {
//                offset += 2;
//                [self.curChars setObject:@"" forKey:[NSString stringWithFormat:@"%d",((int)curPoint.x+offset - 1)]];
//            }
//            else
//            {
//                offset += 1;
//            }
//        }
//    }
//}


//- (void) setCurStatus:(CharAttribs *)ca
//{
////    self.curCharAttribute = [[CharAttribs alloc] initWithCharAttribs:ca.IsBold IsDim:ca.IsDim IsUnderscored:ca.IsUnderscored IsBlinking:ca.IsBlinking IsInverse:ca.IsInverse IsPrimaryFont:ca.IsPrimaryFont IsAlternateFont:ca.IsAlternateFont UseAltColor:ca.UseAltColor AltColor:ca.AltColor UseAltBGColor:ca.UseAltBGColor AltBGColor:ca.AltBGColor GL:ca.GL GR:ca.GR GS:ca.GS ISDECSG:ca.IsDECSG];
//
//    NSString *itemStr = @"";
//    
//    NSArray *sortKey = [[curChars allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
//    {
//        int v1 = [obj1 intValue];
//        int v2 = [obj2 intValue];
//        if (v1 < v2)
//            return NSOrderedAscending;
//        else if (v1 > v2)
//            return NSOrderedDescending;
//        else
//            return NSOrderedSame;
//    }];
//    
//    for (NSString * key in sortKey)
//    {
//        NSString *tmp = [curChars objectForKey:key];
//        if (![tmp isEqualToString:@""]) {
//            itemStr = [itemStr stringByAppendingString:tmp];
//        }
//    }
//    curString = itemStr;
//}

- (id) initShowListEventArgs:(CGPoint) _curPoint  String:(NSString *) _curString CharAttribs: (CharAttribs *) ca Point:(CGPoint) _curCaretPos
{
    self = [super init];
    if (self) {
        self.curPoint = CGPointMake(_curPoint.x, _curPoint.y);
        self.curString = _curString;
        self.curCharAttribute = [[CharAttribs alloc] initWithCharAttribs:ca.IsBold IsDim:ca.IsDim IsUnderscored:ca.IsUnderscored IsBlinking:ca.IsBlinking IsInverse:ca.IsInverse IsPrimaryFont:ca.IsPrimaryFont IsAlternateFont:ca.IsAlternateFont UseAltColor:ca.UseAltColor AltColor:ca.AltColor UseAltBGColor:ca.UseAltBGColor AltBGColor:ca.AltBGColor GL:ca.GL GR:ca.GR GS:ca.GS ISDECSG:ca.IsDECSG];
        self.curCaretPos = CGPointMake(_curCaretPos.x, _curCaretPos.y);
//        self.curChars = [[NSMutableDictionary alloc] init];
//        [self setCurrentBytes:_curString];
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
            int start = curPoint.x;
            int end = curCaretPos.x - 1;
            if ((start >= item.curPoint.x && end <= item.curCaretPos.x && start <=item.curCaretPos.x)) {
                isadd = YES;
                if ([item.curString length] > [curString length]) {
                    NSString *str1 = [item.curString substringToIndex:(curPoint.x - item.curPoint.x)];
                    NSString *str2 = [item.curString substringFromIndex:(curPoint.x - item.curPoint.x)+curString.length];
//                    int len1 = str2.length;
//                    int len2 = item.curString.length;
                    item.curString =[NSString stringWithFormat:@"%@%@%@", str1, curString, str2];
//                    int len3 = item.curString.length;
                } else {
                    item.curString = curString;
                }
                item.curCharAttribute = curCharAttribute;
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

    if ([self.curString rangeOfString:@"___"].location != NSNotFound) {
        CGRect r = CGRectMake(curPoint.x, curPoint.y, curCaretPos.x, curCaretPos.y);
        NSValue *value = [NSValue valueWithCGRect:r];
        [stringShowList.inputStrings addObject:value];
    }

    return self;
}
@end
