//
//  YKRemoteDevice+YKDB.h
//  Pods
//
//  Created by Don on 16/4/28.
//
//
#import "YKRemoteDevice+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface YKRemoteDevice (YKDB)

+ (NSFetchedResultsController *)fetchedResultsController;


/**
 保存(请勿直接调用)

 @return 是否保存成功
 */
- (BOOL)save;

/**
 删除遥控器(请勿直接调用)
 
 @return 是否删除成功
 */
- (BOOL)remove;

+ (YKRemoteDevice *)modelsWithLocalDeviceId:(NSString *)localDeviceId;

+ (NSArray <YKRemoteDevice *> *)modelsWithYkcId:(NSString *)ykcId;

+ (nullable YKRemoteDevice *)saveRemoteDeviceWithDictionary:(NSDictionary *)dict;


+ (NSString *)exportRemotesWithYkcId:(NSString *)ykcId;


+ (BOOL)importRemotes:(NSString *)jsonStr toYkcId:(NSString *)ykcId;

/**
 导出遥控器为json格式

 @return 字典类型
 */
- (NSDictionary *)toJsonObject;

- (BOOL)isRF;

@end

NS_ASSUME_NONNULL_END
