//
//  YZMacroDefine.h
//  YZToolKit
//
//  Created by 马远征 on 14-3-28.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#ifndef YZToolKit_YZMacroDefine_h
#define YZToolKit_YZMacroDefine_h

#if __has_feature(objc_arc_weak)
#   define OBJ_WEAK weak
#   define __OBJ_WEAK __weak
#   define OBJ_STRONG strong
#elif __has_feature(objc_arc)
#   define OBJ_WEAK unsafe_unretained
#   define __OBJ_WEAK __unsafe_unretained
#   define OBJ_STRONG strong
#else
#   define OBJ_WEAK assign
#   define __OBJ_WEAK
#   define OBJ_STRONG retain
#endif

#endif
