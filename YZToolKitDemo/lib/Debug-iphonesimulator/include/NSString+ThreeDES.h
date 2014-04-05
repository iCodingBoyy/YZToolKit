//
//  NSString+ThreeDES.h
//  YZToolKit
//
//  Created by 马远征 on 14-3-29.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ThreeDES)
+ (NSString*)encrypt:(NSString*)plainText withKey:(NSString*)key;
+ (NSString*)decrypt:(NSString*)encryptText withKey:(NSString*)key;
- (NSString*) sha1;
@end
