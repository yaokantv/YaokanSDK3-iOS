//
//  YKRemoteDeviceType.h
//  Pods
//
//  Created by Don on 2017/1/17.
//
//

#import <Foundation/Foundation.h>

@interface YKRemoteDeviceType : NSObject

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *tid;
@property (nonatomic, assign) NSInteger rf;

- (NSInteger)order;
+ (BOOL)isRF:(NSInteger)typeId;

@end
