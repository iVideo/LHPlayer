//
//  GYJAssetManager.h
//  GYJMusicPlayer
//
//  Created by 郭亚娟 on 14-3-21.
//  Copyright (c) 2014年 郭亚娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^AssetGroupEnumerator)(ALAssetsGroup *group, BOOL *stop);
typedef void (^ItemsCompletionBlock)( BOOL success, NSArray *items );
typedef void (^LastItemCompletionBlock)( BOOL success, UIImage *image );
@interface GYJAssetManager : NSObject{
    ItemsCompletionBlock _itemsCompletionBlock;
    LastItemCompletionBlock _lastItemCompletionBlock;
}

@property (nonatomic,assign,readonly)BOOL getAllAssets;
@property (nonatomic,copy) AssetGroupEnumerator assetGroupEnumerator;


+ (GYJAssetManager *) sharedInstance;

- (ALAssetsLibrary *) defaultAssetsLibrary;
- (void) loadLastItemWithBlock:(LastItemCompletionBlock)blockhandler;
- (void) loadAssetsWithBlock:(ItemsCompletionBlock)blockhandler;
- (AssetGroupEnumerator) assetGroupEnumerator;
@end
