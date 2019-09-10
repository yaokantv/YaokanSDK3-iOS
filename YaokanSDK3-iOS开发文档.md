# Yaokan SDK3 iOS 说明文档


  文件编号：YAOKANSDK3IOS-20190723
  版本：v1.3

  深圳遥看科技有限公司
  （版权所有，切勿拷贝）



| 版本 | 说明 | 备注 | 日期 |
| --- | --- | --- | --- |
| v1 | 新建 | Dong | 20190723 |
| v1.1 | 增加API | Huang | 20190801 |
| v1.2 | 格式化 | Dong | 20190802 |
| v1.3 | 增加空调匹配 | Huang | 20190814 |
|   |   |   |   |   |



## 1. 概述
YaokanSDK3 提供完整的设备配网，设备管理，遥控器管理功能，开箱即用，快速与已有App对接的目的。


## 2. 文档阅读对象
使用 YaokanSDK3 iOS 版的开发者

## 3. 接入

需要先向商务申请 `APP_ID`

### 3.1 使用pod

  1. 在 Podfile 添加 `pod 'YaokanSDK'`，如果没有此文件则新建一个再添加。

  2. 然后执行 ```$ pod install --verbose```。

  3. 如果找不到 `YaokanSDK` 请先更新 Pod 仓库：`pod repo update`

### 3.2 手动集成

  1. 打开 `[your_project].xcodeproj`, 选择 Target `[your_target_name]` 打开 General 标签项。

  2. 在 `Embedded Binaries` 中点击 `+` 号，点击 `Add Other..` 打开 `YaokanSDK` 目录选择 `YaokanSDK.framework` 和 `CocoaAsyncSocket.framework` `MQTTClient.framework` `SocketRocket.framework` 。
    直接将这4个文件拖进 `Embedded Binaries` 一样可以。

## 4. API 列表

### 4.1 初始化接口

  1. 注册SDK
      ```objc  
      [YaokanSDK registApp:YOUR_APP_ID secret:YOUR_APP_SEC completion:^(NSError * _Nonnull error) {

      }];
      ```

### 4.2 设备接口    

1. 配置入网
      在  `[your_project].xcodeproj`, 选择 Target `[your_target_name]` 打开 Capabilities  标签项 打开Acces WiFi Information 。
      iOS 13起获取SSID之前需要定位权限。

      ```objc   
      [YaokanSDK bindYKCWithSSID:@"2.4G-WIFI-SSID" password:@"wifipassword" completion:^(NSError * _Nullable error, YKDevice * _Nullable device) {


      }];
      ```

1. 获取设备列表

    ```objc
    [YaokanSDK fetchBoundYKC:^(NSArray<YKDevice *> * _Nonnull devices, NSError *error) {


    }];
    ```
1. 导入设备列表

    ```objc
    [YaokanSDK importYKDevce:@"[{\"did\":\"A64D184C35EAB091\",\"mac\":\"DC4F22529F13\",\"name\":\"YKK_1.0\"}]"];   
    ```
1. 设备测试

    ```objc
    [YaokanSDK toogleLEDWithYKCId:@"targetMacAddr"];
    ```
1. 发码(不适用于空调类型)

    ```objc
    [YaokanSDK sendRemoteWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId]
          remoteId:remoteId remoteDeviceTypeId:typeId cmdkey:@"按键名"
          completion:^(BOOL result, NSError * _Nonnull error) {


    }];
    ```
1. 空调发码(不适用于上下左右 扫风功能)

    ```objc
    [YaokanSDK sendACWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
          remoteDevice:remote
          withMode:mode
          temp:temp
          speed:speed
          windU:windU
          windL:windL
          completion:^(BOOL result, NSError * _Nonnull error) {

    }];
    ```

1. 空调上下扫风发码

    ```objc
    [YaokanSDK sendAcWindUDWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
          remoteDevice:remote
          withMode:mode
          temp:temp
          speed:speed
          windU:windU
          windL:windL
          completion:^(BOOL result, NSError * _Nonnull error) {

    }];
    ```

1. 空调左右扫风发码

    ```objc
    [YaokanSDK sendAcWindUDWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
          remoteDevice:remote
          withMode:mode
          temp:temp
          speed:speed
          windU:windU
          windL:windL
          completion:^(BOOL result, NSError * _Nonnull error) {

    }];
    ```


1. 学习红外

    ```objc
    [YaokanSDK learnIRWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
      remote:_remote key:key.key originRid:_remote.remoteId
      completion:^(NSString * _Nonnull ridNew, NSError * _Nonnull error) {
    }];
    ```

1. 设备开灯

    ```objc
    [YaokanSDK turnOnLEDWithYKCId:@"targetMacAddr"];
    [YaokanSDK turnOffLEDWithYKCId:@"targetMacAddr"];
    ```

1. 硬件升级OTA

    ```objc
    [YaokanSDK firmwareUpdateWithYKCId:@"targetMacAddr"];
    ```

1. 获取硬件版本

    ```objc
    [YaokanSDK checkDeviceVersion:(NSString *)ykcId
        completion:(void (^__nullable)(NSString *version,NSString *otaVersion,NSError *error)){

    }];
    ```

1. 设备复位

    ```objc  
    [YaokanSDK restoreWithYKCId:@"targetMacAddr"];
    ```

### 4.2 遥控器接口
1. 获取被遥控设备类型列表

    ```objc
    [YaokanSDK fetchRemoteDeviceTypeWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId] completion:^(NSArray<YKRemoteDeviceType *> * _Nonnull types, NSError * _Nonnull error) {

    }];
    ```
    `be_rc_type` 的值请参考文档`《遥看SDK3技术说明》3.2.4 获取被遥控设备类型列表`。
    
1. 获取设备品牌

    ```objc
    [YaokanSDK fetchRemoteDeviceBrandWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
              remoteDeviceTypeId:self.deviceType.tid.integerValue
                 completion:^(NSArray<YKRemoteDeviceBrand *> * _Nonnull brands,
                        NSError * _Nonnull error)
    {
    }];
    ```

1. 进入一级匹配(非空调)

    ```objc
    [YaokanSDK requestFirstMatchRemoteDeviceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
        remoteDeviceTypeId:tid
        remoteDeviceBrandId:self.deviceBrand.bid
        completion:^(NSArray<YKRemoteMatchDevice *> * _Nonnull mathes, NSError * _Nonnull error) {
     }];
    ```

1. 进入二级匹配(非空调)

    ```objc
    [YaokanSDK requestSecondMatchRemoteDeviceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
        remoteDeviceTypeId:_tid
        remoteDeviceBrandId:_bid group:_gid
        completion:^(NSArray<YKRemoteMatchDevice *> * _Nonnull mathes, NSError * _Nonnull error) {
        if (mathes.count > 0) {
        }
    }];
    ```
1. 逐个匹配
    ```objc
    [YaokanSDK fetchMatchRemoteDeviceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]
            remoteDeviceTypeId:_deviceType.tid.integerValue
            remoteDeviceBrandId:_deviceBrand.bid
            completion:^(NSArray<YKRemoteMatchDevice *> * _Nonnull mathes, NSError * _Nonnull error)
            {

    }];
    ```

1. 匹配阶段空调发码
    ```objc
    [YaokanSDK sendMatchACWithYKCId:ykcId
                    remoteDevice:remoteDevice
                        withMode:mode
                            temp:temp
                           speed:speed
                           windU:windU
                           windL:windL
                      completion:(BOOL result, NSError *error))completion{
            {
    }];
    ```
1. 匹配阶段空调上下风
    ```objc
    [YaokanSDK sendMatchAcWindUDWithYKCId:ykcId
            remoteDevice:matchDevice
                withMode:mode
                    temp:temp
                   speed:speed
                   windU:windU
                   windL:windL
              completion:^(BOOL result, NSError * _Nonnull error) {

    }];
    ```
1. 匹配阶段空调左右风
    ```objc
    [YaokanSDK sendMatchAcWindLRWithYKCId:ykcId
            remoteDevice:matchDevice
                withMode:mode
                    temp:temp
                   speed:speed
                   windU:windU
                   windL:windL
              completion:^(BOOL result, NSError * _Nonnull error) {

    }];
    ```
1. 保存遥控器

    ```objc
    [YaokanSDK saveRemoteDeivceWithYKCId:[[YKCenterCommon sharedInstance] currentYKCId]     
    remoteDeviceTypeId:typeId
    remoteDeviceId:matchDevice.rid completion:^(YKRemoteDevice * _Nonnull remote, NSError * _Nonnull error) {

    }];
    ```

1. 删除遥控器

    ```objc
    + (void)removeRemoteDeivceWithYKCId:(NSString *)ykcId
      remote:(YKRemoteDevice *)remote
      completion:(void (^__nullable)(NSError *error))completion;
    ```

1. 获取遥控器详情

    ```objc
    + (void)requestRemoteDeivceWithYKCId:(NSString *)ykcId
             remoteDeviceTypeId:(NSUInteger)typeId
               remoteDeviceId:(NSString *)remoteDeviceId
                completion:(void (^__nullable)(NSArray *matchKeys, NSError *error))completion;
    ```

1. 获取遥控器列表

    ```objc
    [YKRemoteDevice modelsWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId]];
    ```

1. 导出遥控器JSON数据

    ```objc
    [YaokanSDK restoreWithYKCId:@"targetMacAddr"];
    ```

1. 导入遥控器列表

    ```objc
    [YKRemoteDevice exportRemotesWithYkcId:[[YKCenterCommon sharedInstance] currentYKCId]];
    ```

### 4.3	SDK错误码表
主要列出了调用SDK的时候，SDK回调返回的错误码信息

| 值 | 代码 | 说明 |
| --- | --- | --- |
| 0 | YKSDK_SUCC | 操作成功 |
| 1001 | YKSDK_APPID_INVALID | APPID无效 |
| 1002 | YKSDK_SMARTCONFIG_TIMEOUT  | 设备配置超时 |
| 1003 | YKSDK_DEVICE_DID_INVALID | 设备 did 无效 |
| 1004 | YKSDK_DEVICE_DID_INVALID | 设备 did 无效 |
| 1005 | YKSDK_CONNECTION_TIMEOUT | 连接超时 |
| 1006 | YKSDK_CONNECTION_REFUSED | 连接被拒绝 |
| 1007 | YKSDK_CONNECTION_ERROR | 连接错误 |
| 1008 | YKSDK_CONNECTION_CLOSED | 连接被关闭 |
| 1009 | YKSDK_SSL_HANDSHAKE_FAILED | ssl 握手失败 |
| 1010 | YKSDK_INTERNET_NOT_REACHABLE | 当前外网不可达 |
| 1011 | YKSDK_NOT_INITIALIZED| SDK 未初始化 |
| 1012 | YKSDK_PERMISSION_NOT_SET | app 权限不足 |
