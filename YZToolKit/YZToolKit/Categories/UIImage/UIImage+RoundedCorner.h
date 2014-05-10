//
//  UIImage+RoundedCorner.h
//  YZToolKit
//
//  Created by 马远征 on 14-3-28.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    UIImageRoundedCornerTopLeft = 1,
    UIImageRoundedCornerTopRight = 1 << 1,
    UIImageRoundedCornerBottomRight = 1 << 2,
    UIImageRoundedCornerBottomLeft = 1 << 3
    
} UIImageRoundedCorner;

@interface UIImage (RoundedCorner)
- (UIImage *)roundedRectWith:(float)radius
                  cornerMask:(UIImageRoundedCorner)cornerMask;
@end
