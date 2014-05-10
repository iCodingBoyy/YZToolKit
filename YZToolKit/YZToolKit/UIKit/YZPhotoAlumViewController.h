//
//  YZPhotoAlumViewController.h
//  YZToolKit
//
//  Created by 马远征 on 14-5-8.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol YZPhotoPickerDelegate <NSObject>

@required
- (void)YZPhotoPickerDidFinishPickingMediaWithInfo:(NSArray*)info;
- (void)YZPhotoPickerDidCancel;

@end

@interface YZPhotoAlumViewController : UIViewController
@property (nonatomic, OBJ_WEAK) id<YZPhotoPickerDelegate> delegate;
- (id)initWithAssetLibrary:(ALAssetsLibrary*)library;
@end
