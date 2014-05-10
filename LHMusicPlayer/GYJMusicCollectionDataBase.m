//
//  GYJMusicCollectionDataBase.m
//  LHMusicPlayer
//
//  Created by LiHang on 14-5-7.
//  Copyright (c) 2014年 LiHang. All rights reserved.
//

#import "GYJMusicCollectionDataBase.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#define DOC_PATH_CACHE [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

NSString * const DataBasePath = @"music_collection_db";
static NSString * const kTableMusicCollections = @"MusicCollectionsTable";

static FMDatabase *sharedDatabase = nil;
GYJMusicCollectionDataBase *gUserDataBase = nil;

@implementation GYJMusicCollectionDataBase
IMPLEMENT_SINGLETON(GYJMusicCollectionDataBase);

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createDatabase];
    }
    gUserDataBase = self;
    return self;
}

- (NSString *)dbPath{
    return [DOC_PATH_CACHE stringByAppendingPathComponent:DataBasePath];
}

- (FMDatabase *)createDatabase{
    
    sharedDatabase = [FMDatabase databaseWithPath:[self dbPath]];
    [sharedDatabase setShouldCacheStatements:YES];
    [self createTable];
    return sharedDatabase;
}

- (void)createTable{
    if (nil != sharedDatabase && [sharedDatabase open]) {
        
        NSString *sqlCollections = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@\
                                    (title TEXT)",kTableMusicCollections];
        if (![sharedDatabase executeUpdate:sqlCollections]) {
            NSLog(@"%@ create error!",kTableMusicCollections);
        }
    }
    [sharedDatabase close];
}

- (FMDatabaseQueue *)queue{
    if (nil == sharedDatabase) {
        [gUserDataBase createDatabase];
    }
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
    return queue;
}

#pragma mark - Insert
- (void)insertMPMediaItem:(MPMediaItem *)mediaItem{
    NSString *songName =  [mediaItem valueForProperty:MPMediaItemPropertyTitle];
    FMDatabaseQueue *queue = [gUserDataBase queue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *countSql = [NSString stringWithFormat:@"SELECT COUNT (*) FROM %@ WHERE %@ = ?",kTableMusicCollections,@"title"];
        FMResultSet *countRs = [db executeQuery:countSql,songName];
        NSUInteger count = 0;
        if ([countRs next]) {
            count = [countRs intForColumnIndex:0];
        }
        [countRs close];
        
        NSString *sql = nil;
        if (!count) {
            sql = [NSString stringWithFormat:@"insert into %@ (%@) VALUES (?)",kTableMusicCollections,@"title"];
            if (![db executeUpdate:sql,songName]) {
                *rollback = YES;
                return;
            }
        }
    }];
}

#pragma mark - Fetch
- (void)fetchMediaItemDictionatys:(void(^)(NSArray *collectionMusics))block{
    FMDatabaseQueue *queue = [gUserDataBase queue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *fetchedArray = [NSMutableArray arrayWithCapacity:100];
        NSString *sql = [NSString stringWithFormat:@"select * from %@",kTableMusicCollections];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            @autoreleasepool {
                NSString *songName = [rs stringForColumn:@"title"];
                [fetchedArray addObject:songName];
            }
        }
        [rs close];
        if (block) {
            block(fetchedArray);
        }
    }];
}

#pragma mark - Delete
- (void)deleteMediaItemFromDataBase:(MPMediaItem *)mediaItem success:(void(^)(BOOL success,NSError *error))block{
    NSString *songName =  [mediaItem valueForProperty:MPMediaItemPropertyTitle];
    FMDatabaseQueue *queue = [gUserDataBase queue];
    __block BOOL deleteOK = NO;
    __block NSError *error = nil;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where title = '%@'",kTableMusicCollections,songName];
        deleteOK = [db update:sql withErrorAndBindings:&error];
        if (!deleteOK) {
            *rollback = YES;
        }
        if (block) {
            block(deleteOK,error);
        }

    }];
}

@end
