//
//  Functions.m
//  SmartClient
//
//  Created by sun on 13-10-24.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#import "Functions.h"
#import "GDataXMLNode.h"


@implementation Functions
/**
 解析webservice返回的XML成一个NSDictionary
 参数：content ,要解析的数据
 参数：path   ,要解析的XML数据一个根节点
 返回：NSDictionary
 */
+ (NSDictionary *)getXMLAttrs:(NSString *) content xpath:(NSString *)path
{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSError *docError = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:content options:0 error:&docError];
    GDataXMLElement* rootElement = [document rootElement];
    if(!docError)
    {
        NSArray *children = [rootElement elementsForName:path];
        if(!docError)
        {
            if(children && [children count]>0)
            {
                GDataXMLElement *rootElement = (GDataXMLElement *)[children objectAtIndex:0];
                NSArray * attrs = [rootElement attributes];
                for (int i = 0; i < attrs.count; i++) {
                    GDataXMLNode *att =  attrs[i];
                    [resultDict setObject:att.stringValue forKey:att.name];
//                    NSLog(@"name=%@, stringValue=%@", [att name], [att stringValue]);
                }
            }
        }
    }
    return resultDict;
}

+ (NSArray *)getXMLAttrsFromList:(NSString *)content
{
    NSMutableArray *resultDict = [[NSMutableArray alloc] init];
    NSError *docError = nil;
    NSString *xml = [NSString stringWithFormat:@"%@%@%@",@"<param>", content, @"</param>"];
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&docError];
    GDataXMLElement* rootElement = [document rootElement];
    if(!docError)
    {
        NSArray *children = [rootElement elementsForName:@"GroupItem"];
        if(children && [children count]>0)
        {
            NSMutableArray *text = [[NSMutableArray alloc] init];
            NSMutableDictionary *list = [[NSMutableDictionary alloc] init];

            for (int j = 0; j < [children count]; j++) {
                GDataXMLElement *element = (GDataXMLElement *)[children objectAtIndex:j];
                NSString *sections = [[element attributeForName:@"Text"] stringValue];
                [text addObject:sections];
                NSArray *two = [element elementsForName:@"Item"];
                if(two && [two count] > 0){
                    NSMutableArray *line = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [two count]; i++) {
                        GDataXMLElement *el = (GDataXMLElement *)[two objectAtIndex:i];
                        NSString *value = [[el attributeForName:@"Value"] stringValue];
                        NSString *text = [[el attributeForName:@"Text"] stringValue];
                        [line addObject:value];
                        [line addObject:text];
                    }
                    
                    [list setObject:line forKey:[NSNumber numberWithInt:j]];
                }
            }
            
            [resultDict addObject:text];
            [resultDict addObject:list];
        }
    }
    return resultDict;
}

+ (UIColor *) getColorFromRGB:(NSString *)str
{
    if(str.length != 9){
        return [UIColor blackColor];
    }
    int red = [[str substringWithRange:NSMakeRange(0, 3)] intValue];
    int green = [[str substringWithRange:NSMakeRange(3, 3)] intValue];
    int blue = [[str substringWithRange:NSMakeRange(6, 3)] intValue];
    
    CGFloat colorRed =  red /255.0F;
    CGFloat colorGreen = green /255.0F;
    CGFloat colorBlue = blue /255.0F;
    
    return [[UIColor alloc] initWithRed:colorRed green:colorGreen blue:colorBlue alpha:1];
}

+ (NSString *)getRightValueFromDict:(NSDictionary *)dict key:(NSString *)key defValue:(NSString *)value
{
    @try {
        return [dict objectForKey:key];
    }
    @catch (NSException *exception) {
        NSLog(@"err to parse xml from vt2014, key = %@", key);
        return value;
    }
}

+ (UIImage *)scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    if (width <= maxWidth && height <= maxHeight)
    {
        return image;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > maxWidth || height > maxHeight)
    {
        CGFloat ratio = width/height;
        if (ratio > 1)
        {
            bounds.size.width = maxWidth;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
        {
            bounds.size.height = maxHeight;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    CGFloat scaleRatio = bounds.size.width / width;
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
@end
