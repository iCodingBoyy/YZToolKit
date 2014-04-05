//
//  UIImage+RoundedCorner.m
//  YZToolKit
//
//  Created by 马远征 on 14-3-28.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "UIImage+RoundedCorner.h"

/// UIKit 坐标系统原点在左上角,y 方向向下的(坐标系 A),但在 Quartz 中坐标系原点在左下角, y 方向向上的(坐标系 B)。图片绘制也是颠倒的。
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float radius, UIImageRoundedCorner cornerMask)
{
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    /// 如果左上角需要画圆角,画出一个弧线出来。
    if (cornerMask & UIImageRoundedCornerTopLeft)
    {
        /// 已左上的正方形的右下脚为圆心,半径为 radius, 180度到90度画一个弧线,
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius,
                        radius, M_PI, M_PI / 2, 1);
    }
    else
    { /// 如果不需要画左上角的弧度。从线2终点,画到线3的终点,
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
        /// 线3终点,画到线4的起点
        CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y + rect.size.height);
    }
    /// 画线4的起始,到线4的终点
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius,
                            rect.origin.y + rect.size.height);
    /// 画右上角
    if (cornerMask & UIImageRoundedCornerTopRight)
    {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius,
                        rect.origin.y + rect.size.height - radius, radius, M_PI/2, 0.0f, 1);
    }
    else
    {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width,
                                rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width,
                                rect.origin.y + rect.size.height - radius);
    }
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    /// 画右下角弧线
    if (cornerMask & UIImageRoundedCornerBottomRight)
    {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius,
                        radius, 0.0f, -M_PI / 2, 1);
    }
    else
    {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y);
    }
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    /// 画左下角弧线
    if (cornerMask & UIImageRoundedCornerBottomLeft)
    {
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius,
                        -M_PI / 2, M_PI, 1);
    }
    else
    {
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + radius);
    }
    CGContextClosePath(context);
}

@implementation UIImage (RoundedCorner)

- (UIImage*)roundedRectWith:(float)radius cornerMask:(UIImageRoundedCorner)cornerMask
{
    UIImageView *bkImageViewTmp = [[UIImageView alloc] initWithImage:self];
    int w = self.size.width; int h = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4*w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextBeginPath(context);
    
    addRoundedRectToPath(context,bkImageViewTmp.frame, radius, cornerMask);
    CGContextClosePath(context); CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context); CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *newImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    return newImage;
}

@end
