//
//  UILabel+ContentSize.m
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 16/8/3.
//  Copyright © 2016年 57380422@qq.com. All rights reserved.
//

#import "UILabel+ContentSize.h"

@implementation UILabel (ContentSize)
-(CGSize)caculatedSize{
    CGSize size = CGSizeMake(self.frame.size.width, MAXFLOAT);

    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:self.font.pointSize] forKey:NSFontAttributeName];

    CGRect rect = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];

    return rect.size;
}

//+(CGFloat)getLabelHeightWithSizeOfFont:(CGFloat)fontSize width:(CGFloat)width content:(NSString*)content{
//    CGSize size = CGSizeMake(width,MAXFLOAT);
//
//    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
//
//    CGRect rect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
//
//    return rect.size.height;
//}
@end
