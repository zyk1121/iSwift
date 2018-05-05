## Swift服务端-初体验>
作为一位对技术有一定追求的移动端研发小伙伴，一直有个全栈的技术梦，尝试过Android和服务端开发，但是考虑到精力以及没有项目支撑，也只能稍微了解，想深入并不是很容易。<br>
好在swift在服务端的表现也越来越成熟，用swift写服务器已经不是什么新鲜事了，比较流行服务端框架有：Perfect、Vapor、Kitura、Zewo、Node.js。<br>
本wiki不会带大家深入服务器端的开发，但是通过本篇内容的介绍，可以让大家对服务端开发的流程和概念进行简单的了解，进而对业务开发的整体有一个全局的感观和认识。

[Perfect官方网站](https://www.perfect.org/indexb.html?utm_expid=111916136-0.cxSPnx0YS5elL-DfbPTXrg.1)

[Perfect官方中文网站](https://www.perfect.org/docs/index_zh_CN.html)

[服务端写Swift体验 (Perfect框架)](https://www.jianshu.com/p/2ce98b556e89)

下面针对Swift服务端框架Perfect来进行服务端开发的初体验：


### 一、Perfect创建HelloWorld项目

##### 1、创建HelloWroldPerfect项目
>
在指定的目录创建HelloWorldPrefect文件夹

可以命令行创建文件夹：mkdir HelloWorldPrefect

##### 2、创建Package.swift
这个文件是SPM（Swift软件包管理器）编译项目时必须要用到的文件，SPM请参考：[用SPM软件包管理器编译项目](https://www.perfect.org/docs/buildingWithSPM_zh_CN.html)
进入终端，并且进入到HelloWorldPrefect目录。
> touch Package.swift

内容如下：

``` Swift 
// 软件包管理
import PackageDescription
let versions = Version(0,0,0)..<Version(10,0,0)
let urls = [
    "https://github.com/PerfectlySoft/Perfect-HTTPServer.git"      //HTTP服务
]

let package = Package(
    name: "HelloWorldPrefect",
    targets: [],
    dependencies: urls.map { .Package(url: $0, versions: versions) }
)
```
##### 3、创建Sources文件夹
Sources文件夹是用来保存源文件程序，需要在这个文件夹下创建一个main.swift文件。
>
mkdir Sources<br>
echo 'print("您好！")' >> Sources/main.swift

##### 4、build项目
执行如下命令：
>
swift build

终端会执行fetching操作，根据网速稍等片刻:

``` Swift
Fetching https://github.com/PerfectlySoft/Perfect-HTTPServer.git
Fetching https://github.com/PerfectlySoft/Perfect-HTTP.git
Fetching https://github.com/PerfectlySoft/Perfect-CZlib-src.git
Fetching https://github.com/PerfectlySoft/Perfect-Net.git
Fetching https://github.com/PerfectlySoft/Perfect-Crypto.git
Fetching https://github.com/PerfectlySoft/Perfect-Thread.git
Fetching https://github.com/PerfectlySoft/PerfectLib.git
Fetching https://github.com/PerfectlySoft/Perfect-COpenSSL.git
...
Compile Swift Module 'PerfectThread' (3 sources)
Compile Swift Module 'PerfectLib' (9 sources)
Compile Swift Module 'PerfectCrypto' (7 sources)
Compile Swift Module 'PerfectNet' (7 sources)
Compile Swift Module 'PerfectHTTP' (10 sources)
Compile Swift Module 'PerfectHTTPServer' (18 sources)
Compile Swift Module 'HelloWorldPrefect' (1 sources)
Linking ./.build/x86_64-apple-macosx10.10/debug/HelloWorldPrefect
```

终端执行下面的指令输出“您好！”代表执行成功。
>
./.build/x86_64-apple-macosx10.10/debug/HelloWorldPrefect

##### 5、生成Xcode项目
同时也可以根据下面的命令生成对应的Xcode项目，方便后期编译调试。
>
swift package generate-xcodeproj

用“ll -a”命令查看当前文件夹下的文件目录情况：

``` Swift
➜  HelloWorldPrefect ll -a
total 16
drwxr-xr-x   7 zhangyuanke  staff   224B  5  5 21:18 .
drwxr-xr-x   9 zhangyuanke  staff   288B  5  5 21:01 ..
drwxr-x---  10 zhangyuanke  staff   320B  5  5 21:14 .build
drwxr-xr-x  13 zhangyuanke  staff   416B  5  5 21:18 HelloWorldPrefect.xcodeproj
-rw-r--r--   1 zhangyuanke  staff   2.3K  5  5 21:14 Package.resolved
-rw-r--r--@  1 zhangyuanke  staff   331B  5  5 21:07 Package.swift
drwxr-xr-x   3 zhangyuanke  staff    96B  5  5 21:10 Sources
``` 

打开HelloWorldPrefect.xcodeproj项目，选择可执行的“HelloWorldPrefect”Scheme编译，可以看到“Build Successed”的提示。

### 二、GET、POST请求
ok，经过上面的一系列简单的指令我们很轻松的就可以把Swift服务端的框架搭好，下面我们继续我们的旅行吧~
##### 1、创建HelloWorldServerManager.swift
构建基于Swift服务端的GET和POST请求代码：

``` Swift
import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

open class HelloWorldServerManager {
    fileprivate var server: HTTPServer
    // http://localhost:8888/helloapi/
    internal init(root: String, port: UInt16) {
        server = HTTPServer.init()                          //创建HTTPServer服务器
        var routes = Routes.init(baseUri: "/helloapi")           //创建路由器
        configure(routes: &routes)                          //注册路由
        server.addRoutes(routes)                            //路由添加进服务
        server.serverPort = port                            //端口
        server.documentRoot = root                          //根目录
        server.setResponseFilters([(Filter404(), .high)])   //404过滤
    }
    
    //MARK: 开启服务
    open func startServer() {
        do {
            print("启动HTTP服务器")
            try server.start()
        } catch PerfectError.networkError(let err, let msg) {
            print("网络出现错误：\(err) \(msg)")
        } catch {
            print("网络未知错误")
        }
        
    }
    
    //MARK: 注册路由
    fileprivate func configure(routes: inout Routes) {
        // 添加GET接口,请求方式,路径
        routes.add(method: .get, uri: "/testget") { (request, response) in
            response.setHeader( .contentType, value: "application/json")
            
            let jsonDic = ["hello": "world get"]
            let jsonString = self.baseResponseBodyJSONData(status: 200, message: "成功", data: jsonDic)
            response.setBody(string: jsonString)                           //响应体
            response.status = .ok
            response.completed()                                           //响应
        }
        
        // 添加POST接口,请求方式,路径
        routes.add(method: .post, uri: "/testpost") { (request, response) in
            response.setHeader( .contentType, value: "application/json")
            let jsonDic = ["hello": "world post" + request.queryParams.description]
            let jsonString = self.baseResponseBodyJSONData(status: 200, message: "成功", data: jsonDic)
            response.setBody(string: jsonString)                           //响应体
            response.status = .ok
            response.completed()                                           //响应
        }
    }
    
    //MARK: 通用响应格式
    func baseResponseBodyJSONData(status: Int, message: String, data: Any!) -> String {
        var result = Dictionary<String, Any>()
        result.updateValue(status, forKey: "status")
        result.updateValue(message, forKey: "message")
        if (data != nil) {
            result.updateValue(data, forKey: "data")
        }else{
            result.updateValue("", forKey: "data")
        }
        guard let jsonString = try? result.jsonEncodedString() else {
            return ""
        }
        return jsonString
    }
    
    //MARK: 404过滤
    struct Filter404: HTTPResponseFilter {
        
        func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            callback(.continue)
        }
        
        func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
            if case .notFound = response.status {
                response.setHeader( .contentType, value: "application/json")
                response.setBody(string: "404 文件\(response.request.path)不存在。")
                response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
                callback(.done)
                
            } else {
                callback(.continue)
            }
        }
    }
}
```

##### 2、编辑main.swift
修改main.swift内容如下：

```swift
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let networkServer = HelloWorldServerManager(root: "./webroot", port: 8888)
networkServer.startServer()
```

build即可成功，控制台打印信息如下：
>
启动HTTP服务器<br>
[INFO] Starting HTTP server  on 0.0.0.0:8888

##### 3、访问跑起来的服务器
1、GET访问：http://localhost:8888/helloapi/testget
>{
    "status": 200,
    "data": {
        "hello": "world get"
    },
    "message": "成功"
}

2、POST访问：http://localhost:8888/helloapi/testpost?key1=12&key2=23
>{
    "status": 200,
    "data": {
        "hello": "world post[(\"key1\", \"12\"), (\"key2\", \"23\")]"
    },
    "message": "成功"
}

到此，有没有很开心~

### 三、静态文件服务器
Swift服务端同样也支持静态文件服务器，可以把文件直接放到指定的目录下，即可访问，主要包括如下3种方式，默认的webroot目录不一样。
##### 1、直接Debug运行
直接Debug运行的静态文件夹目录在生成的可执行文件HelloWorldPrefect的同级目录下的webroot下，可以在项目的Products下的可执行文件HelloWorldPrefect右键Show in Finder即可看到，把文件或者图片拷贝到目录下即可访问。
>
http://localhost:8888/123.txt

##### 2、双击可执行文件
但是，如果双击执行可执行文件HelloWorldPrefect，而不是Debug运行，默认的静态文件服务器路径为：
>
~/webroot/*<br>
~/webroot/test.jpg

执行：http://localhost:8888/test.jpg 即可访问图片。

##### 3、可以指定文件服务器目录
通过修改main.swift即可指定静态文件目录。

```swift
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

//let networkServer = HelloWorldServerManager(root: "./webroot", port: 8888)
//networkServer.startServer()

let networkServer = HelloWorldServerManager(root: "/Users/zhangyuanke/webroot", port: 8888)
networkServer.startServer()
```

### 四、展望
本篇主要对swift服务端入门进行简单的介绍，后期可以针对：SPM、文件及文件夹操作、数据库访问、MQ等等进行更深入的研究。


#### 祝在尚德工作愉快！
