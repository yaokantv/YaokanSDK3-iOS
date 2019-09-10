# 遥看SDK3技术说明

    文件编号：YAOKANSDK3FA-20190723
    版本：v1.2

    深圳遥看科技有限公司
    （版权所有，切勿拷贝）



| 版本 | 说明 | 备注 | 日期 |
| --- | --- | --- | --- |
| v1 | 新建 | Dong | 20190723 |
| v1.1 | 更新SDK地址 | Dong | 20190902 |
| v1.2 | 增加获取被遥控设备类型列表 | Dong | 20190909 |
|   |   |   |   |   |



## 1. 概述
### 1.1 项目名称
遥看SDK3（YaokanSDK3）

### 1.2 项目背景
遥看中心SDK要求对接的客户有较高的原生开发技术能力，没有包含UI，针对不同的端去编写多套代码并适配不同设备，人工成本、时间成本等都非常高。这些问题导致原来的遥看中心SDK无法适应现在正在快速发展的智能家居市场。

### 1.3 方案目标
帮助客户在其已有的APP基础上快速对接我们的小苹果，空调伴侣等产品，并将我们的产品快速推出智能家居市场。

### 1.4 框架
- 交互流程![设备交互流程](images/YaokanSDKDeviceFramework.png)

### 1.5 方案优势
- 快速接入
- 不需要关心码库协议，使用标准简化的指令表进行通迅
- 有完整配套的SDK原生Demo参考，也可以使用标准通用的HTML5技术实现，同时也节省了 iOS 和 Android 平台的 UI 开发工作量
- 统一通用的API

### 1.6 接入流程
- 接入流程![接入流程](images/接入流程.png)

### 1.7 SDK 地址
支持手动集成和 CocoaPod，Demo 需要先通过商务申请 AppID 才能使用。

1. https://github.com/yaokantv/YaokanSDK3-iOS
2. https://github.com/yaokantv/YaokanSDK3-Android


## 2. SDK架构
### 2.1 SDK设计
1. SDK架构
    - 目前提供有 iOS SDK 和 Android SDK，以及相配置的 SDK Demo
    ![SDK架构](images/YaokanSDK技术框架.png)

    - SDK包括设备和遥控器两部分：
    ![SDK层次](images/SDKFramework.png)


1. 设备和遥控器
    ![设备和遥控器](images/DeviceAndRemoteControl.png)
    
    * 设备配置入网之后，可以将遥控器指令发给该设备；
    * 设备和遥控器没有绑定关系；

### 2.2 术语解释
- `appid`, 应用标识，当开发者需要为一款智能产品开发应用（包括iOS、Android等）时，后台会自动生成一个AppID，并与此设备进行关联。应用开发时需要填入此AppID，目前可以通过联系我们商务获得。
- `appsecret`, 应用密钥，在云端生成`appid`的时候，会对应生成一个`appsecret`，该参数在APP端SDK初始化时会用到。
- `did`, 设备ID，当一个小苹果设备接入遥看云时，遥看云自动为设备注册一个唯一的 did，用于与用户的绑定及后续操作。

## 3. 功能描述
### 3.1 设备管理
#### 3.1.1 初始化YKSDK

使用Appid和AppSecret进行初始化SDK，初始化成功后才能使用SDK的功能

- `appid` 请先联系商务申请，商务通过管理后台，输入客户基本信息后自动生成 `appid` 和 `appsecret`
- 通过 `appid` 和 `appsecret` 进行初始化
- 使用 app 客户端的唯一标识作用连接遥看云的身份
- 初始化完成返回结果：成功或失败

#### 3.1.2 SDK 连接遥看云
- SDK初始化成功后会自动与本地的设备分别建立连接
- 同时与遥看云建立连接

#### 3.1.3 配置入网
- 让设备连上Wi-Fi(2.4G), 连上路由器的设备，如果路由器能够访问互联网，设备会自动注册
- 在开始配置前，设备要先进入配置入网模式，然后 APP调用配置接口发送要配置的路由器 SSID 和密码
- 设备配置成功后，SDK给APP返回已配置成功的设备 MAC 地址和产品类型标识，便于APP做下一步的操作
- 配网成功后，设备端自动连接遥看云注册 `did`

#### 3.1.4 设备列表
获取设备列表，本地发现的设备会实时显示到列表中

#### 3.1.5 导入导出设备列表
通过导入导出设备列表，客户可以用来对接自己的用户系统，实现用户的设备同步功能

#### 3.1.6 设备测试
发送测试指令，设备收到后指示灯会快闪一次

#### 3.1.7 设备控制
- 通用的发送指令接口，指令表透传
- 支持各厂商 433 协议码
- 支持发送空调遥控指令

#### 3.1.8 设备学习
支持学习红外和射频学习功能

#### 3.1.9 设备复位
此功能可用于删除设备，重新配网等应用场景。

#### 3.1.10 小夜灯控制
控制设备的指示灯开关

- 小夜灯既是小苹果 LED 灯，可以通过设备控制器打开或关闭小夜灯。
- 开和关两个独立控制，能够获取当前小夜灯状态是开还是关。

#### 3.1.11 获取固件版本信息
获取当前的版本号,显示固件版本号，格式为 x.x.x

#### 3.1.12 检测更新
设备支持OTA更新能力，检测有新的版本可以由用户进行更新，支持显示升级进度

### 3.2 遥控器管理
#### 3.2.1 遥控器列表
本地已经创建的遥控器列表，客户可以用来对接自己的用户系统，实现用户的遥控器同步功能

#### 3.2.2 遥控器界面   
根据每种遥控设备类型的按键定义和指令表实现的控制面板。

#### 3.2.3 遥控器设置   
- 修改名称
- 删除遥控器

#### 3.2.4 创建遥控器，选择遥控器类型   
获取被遥控设备类型列表

| 类型ID | 英文名 | 中文名 | 是否射频 |
| --- | --- | --- | --- |
|1|	Setbox|	机顶盒|	0|
|2|	TV|	电视机|	0|
|3|	DVD|	DVD|	0|
|5|	Projector|	投影仪|	0|
|6|	Fan|	风扇|	0|
|7|	A/C|	空调|	0|
|8|	Light|	灯|	0|
|10|	InternetBox|	电视盒子|	0|
|12|	Sweeper|	扫地机|	0|
|13|	Audio|	音响|	0|
|14|	Camera|	照相机|	0|
|15|	AirCleaner|	空气净化器|	0|
|16|	Footbath|	洗脚盆|	0|
|17|	Car-Audio|	汽车音响|	0|
|21|	Rf-Switch|	开关|	1|
|22|	Rf-Outlet|	插座|	1|
|23|	Rf-Curtain|	窗帘|	1|
|24|	Rf-Airer|	晾衣架|	1|
|25|	Rf-Lamp|	灯|	1|
|40|	WaterHeater|	热水器|	0|
|38|	Rf-FanLight|	风扇灯|	1|
|11|	SatelliteTv|	卫星电视|	0|
|41|	Rf-Liangba|	凉霸|	1|
|42|	Rf-Fan|	风扇|	1|

#### 3.2.5 选择遥控器品牌
获取某遥控器类别下品牌列表

#### 3.2.6 遥控器匹配
- 一级匹配，可以快速地匹配到可用的遥控器
- 然后进入二级匹配，匹配整个遥控器的按键

#### 3.2.7 遥控器创建
匹配成功后，将遥控器基本信息保存在SDK。

#### 3.2.8 导出遥控器列表
支持将本地已经创建的遥控器列表导出为json数据，用于与客户的用户系统对接同步

#### 3.2.9 导入遥控器列表
将用户遥控器的json数据导入sdk，实现客户用户遥控器同步功能

#### 3.2.10 删除遥控器
从SDK本地删除某个遥控器的功能