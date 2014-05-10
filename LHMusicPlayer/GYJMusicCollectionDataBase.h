//
//  GYJMusicCollectionDataBase.h
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-7.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//
//  音乐收藏数据库
//
#import <Foundation/Foundation.h>

@interface GYJMusicCollectionDataBase : NSObject

DECLARE_SINGLETON(GYJMusicCollectionDataBase);

#pragma mark - Insert
- (void)insertMPMediaItem:(MPMediaItem *)mediaItem;
#pragma mark - Fetch
- (void)fetchMediaItemDictionatys:(void(^)(NSArray *collectionMusics))block;

#pragma mark - Delete
- (void)deleteMediaItemFromDataBase:(MPMediaItem *)mediaItem success:(void(^)(BOOL success,NSError *error))block;
@end
