## iOS动静态库以及工程联编#### 一、总体介绍
iOS开发中有动态库和静态库的概念，动态库和静态库是相对运行期和编译期的，静态库在程序编译时会被链接到目标代码中，程序运行时将不再需要该静态库；而动态库在程序编译时并不会被链接到目标代码中，只是在程序运行时才被载入，因为在程序运行期间还需要动态库的存在。详细请参考：[iOS 静态库和动态库（库详解）](https://www.cnblogs.com/junhuawang/p/7598236.html)，里面讲了比较详细的库的概念、库的分类、动静态库的特点、存在形式、区别以及库的创建方式等等。
>
1、iOS常见的动态库和静态库有哪些表现形式？《参考上面的链接》。<br>
2、常见的framework是动态库还是静态库？《参考上面的链接》。<br>
3、OC支持编译动态库或者Swift支持编译静态库吗？<br>
4、高德地图等SDK工程搭建方式？<br>
5、工程联编怎么搭建、支持多层级工程联编也OK吗？<br>
6、提供出去的三方SDK如何支持真机以及模拟器？<br>

上面的问题基本可以用实际搭建的项目来验证即可，项目路径：[工程demo路径](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/TestLib.zip)。
#### 二、项目框架介绍

##### 2.1、项目目录结构图
工程由一个demo工程《TestLibDemo》以及6个库组成，详细请参考demo。
![](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/lib/lib_1.jpg)

##### 2.2、项目框架图
![](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/lib/lib_2.jpg)
>
《TestLibVerifyDemo》是用来验证相应的库是静态库还是动态库的，在压缩包对应的目录下，解压后可以看到。

其中，有一个三级联编的项目，TestEngineLib(OC、C++) -> TestStaticFramework（OC） -> TestLibDemo（Swift），也是高德SDK项目构成的基本形式：底层地图引擎库（C++）-> 地图SDK（OC）-> 高德地图App（OC）。

#### 三、工程搭建方式（与联编）
其实，Xcode本身是支持多项目联编的，操作也比较简单，相信有做过SDK开发的同学肯定不陌生，在同一个workspace下可以new多个project，都关联到对应的【.xcworkspace】下，之后设置依赖关系即可。这里不做具体介绍，操作一遍大家也就都会了，本来打算是找个会议室讲一下的，无奈最近没有会议室，所以可以后续再讲，当然如果有同学比较感兴趣同时也真心不清楚如何操作的可以单独 @张元科 进行讲解，毕竟不是很复杂~_~。 

项目运行结果如下：

``` Objective-C 
2018-04-19 22:06:57.165948+0800 TestLibDemo[55069:3055678] TestStaticLib run...
2018-04-19 22:06:57.166139+0800 TestLibDemo[55069:3055678] TestStaticFramework run...
2018-04-19 22:06:57.166265+0800 TestLibDemo[55069:3055678] TestEngineLib run...
2018-04-19 22:06:57.166397+0800 TestLibDemo[55069:3055678] 调用C++引擎库:
TestEngineCpp::testRun() 
2018-04-19 22:06:57.166641+0800 TestLibDemo[55069:3055678] TestDynamicOCLib run...
TestStaticSwiftLib run...
TestDynamicSwiftLib run...
2018-04-19 22:06:57.174862+0800 TestLibDemo[55069:3055678] TestDynamicSwiftLib TestOC run...
```
每一个库项目都修改一下输出后，项目运行结果如下：

``` Objective-C 
2018-04-19 22:09:52.447494+0800 TestLibDemo[55269:3060194] TestStaticLib run...-2
2018-04-19 22:09:52.447652+0800 TestLibDemo[55269:3060194] TestStaticFramework run...-2
2018-04-19 22:09:52.447759+0800 TestLibDemo[55269:3060194] TestEngineLib run...-2
2018-04-19 22:09:52.447874+0800 TestLibDemo[55269:3060194] 调用C++引擎库:-2
TestEngineCpp::testRun() -2
2018-04-19 22:09:52.448030+0800 TestLibDemo[55269:3060194] TestDynamicOCLib run...-2
TestStaticSwiftLib run...-2
TestDynamicSwiftLib run...-2
2018-04-19 22:09:52.448889+0800 TestLibDemo[55269:3060194] TestDynamicSwiftLib TestOC run...-2
```

#### 四、其他注意事项
##### 4.1、动静态库修改方式以及依赖设置
![](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/lib/lib_3.jpg)

##### 4.2、SDK支持架构类型及修改
目前iOS的架构类型：arm64 armv7 armv7s（真机）；x86_64 i386(模拟器）。
分别build模拟器和真机的结果，在Products目录下：Debug-iphoneos和Debug-iphonesimulator分别对应真机和模拟器生成的debug结果。
分别进入到对应目录下的TestStaticFramework.framework内执行：
>
lipo -info TestStaticFramework

得到：
>
Debug-iphoneos:Architectures in the fat file: TestStaticFramework are: armv7 arm64<br>
Debug-iphonesimulator:Architectures in the fat file: TestStaticFramework are: i386 x86_64

##### 4.3、支持多架构SDK
拷贝出其中一个TestStaticFramework.framework的TestStaticFramework，改名为TestStaticFramework1，拷贝出另一个TestStaticFramework.framework的TestStaticFramework，改名为TestStaticFramework2。
>
lipo -create TestStaticFramework1 TestStaticFramework2 -output TestStaticFramework<br>
lipo -info TestStaticFramework

输出：
>
Architectures in the fat file: TestStaticFramework are: i386 armv7 x86_64 arm64

之后删除TestStaticFramework1和TestStaticFramework2，提供TestStaticFramework.framework给第三方使用即可。

还是那句话，如果有同学比较感兴趣同时也真心不清楚如何操作的可以单独 @张元科 进行讲解，毕竟不是很复杂（或者等以后有会议室再一起简单过下）~_~

#### 祝在尚德工作愉快！
