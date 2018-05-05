##iOS开发中Http Mock方法-swift篇
>
考虑到部分需求开发的过程中，后台数据接口可能未准备好的痛点，题库这边已经验证集成了http stub的功能（OHHTTPStubs），支持后台数据接口未准备好的时候走通整个开发流程，以及UI数据填充（还不影响上线相关的功能），只需要本地构建需要调试接口的json数据即可，进一步提升开发的效率。

OHHTTPStubs主要功能：

1. 根据请求接口的host或者path来mock并返回指定json数据<br>
2. 单元测试时的数据返回模拟


## 5分钟入门教程
### 1.podfile中集成
``` Swift 
pod 'OHHTTPStubs/Swift'
```
### 2.项目中使用
多个人同时开发的时候可以创建一个mock数据统一入口，这样更少的污染源代码，比如创建下面的一个单例之后在appdelegate中调用即可。当需要真正地和后端联调的时候，可以注释掉相关代码。

``` Swift 
class YKStubManager: NSObject {
    // 单例对象
    static let stub:YKStubManager = YKStubManager()
    override init() {
        super.init()
        setupStub()
    }
    // 设置stub入口
    func setupStub()
    {
        _ = YKStub.instance
        _ = FXStub.instance
        _ = ZKStub.instance
    }
}
```
开发人员可以在"项目路径/stub/"下创建自己的文件夹和单独的类处理mock的逻辑。

``` Swift 
import UIKit
import OHHTTPStubs

class YKStub: NSObject {
    // 单例对象
    static let instance:YKStub = YKStub()
    override init() {
        super.init()
        setupStub()
    }
    // 入口
    func setupStub()
    {
        stub(condition: pathMatches("/homework/queryQuizResult")) { _ in
            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
            let stubPath = OHPathForFile("test.json", type(of: self))
            let response = fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
            response.requestTime = 2.0
            return response
        }
        /*
         stub(condition: isHost("mywebservice.com")) { _ in
         // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
         let stubPath = OHPathForFile("test.json", type(of: self))
         return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
         }
         
         
         stub(condition: pathStartsWith("/abc/def/hexo")) { _ in
         // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
         let stubPath = OHPathForFile("test.json", type(of: self))
         return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
         }
         */
    }
}
```
其中test.json文件在“项目路径/stub/ykstub”路径下，是事先准备好的json数据，方式可以是直接向后端开发人员获取，也可以是自己构建（结构简单的话），当前的json内容如下：

``` json
{
    "rs":1,
    "rsdesp":"",
    "resultMessage":{
        "answerTime":89,
        "scoreRate":"98",
        "studentAnswerInfo":[
                             {
                             "questionId":100,
                             "sequence":1,
                             "correct":1
                             },
                             {
                             "questionId":101,
                             "sequence":2,
                             "correct":2
                             }
                             ]
    }
}
```
### 3.源代码分析
Stub最常用的使用方式如下（匹配url路径path的方式），代码很简单，不进行过多的介绍。

``` swift
  stub(condition: pathMatches("/homework/queryQuizResult")) { _ in
            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
            let stubPath = OHPathForFile("test.json", type(of: self))
            let response = fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
            response.requestTime = 2.0
            return response
        }
```
其中【fixture】方法定义如下（可以指定请求结果状态，200，300，或者400等）：

``` swift
 public func fixture(filePath: String, status: Int32 = 200, headers: [AnyHashable: Any]?) -> OHHTTPStubsResponse {
    return OHHTTPStubsResponse(fileAtPath: filePath, statusCode: status, headers: headers)
  }
``` 
或者我们也可以自定义创建【OHHTTPStubsResponse】来返回，并可以在返回response之前设置请求时间，响应时间，返回状态等等。

### 4.优点 & 不足
1. 不必等到后端数据接口提供之后才开始开发网络逻辑。
2. 代码中网络逻辑都正常开发，联调上线不需改动任何代码。
3. 可以指定：请求时间，响应时间，返回状态等。
4. json数据更加直观，修改后重新build即可返回修改后的数据，比如【rs=0】。
5. 需要自己准备json数据，或许会比较麻烦，以及流程逻辑比较复杂的时候json数据修改也会较为复杂。
6. 不阻塞开发流程，提升开发效率【当然，如果后端接口已准备好，还是直接调后端接口的好】。

### 5.参考
[如何在iOS开发中更好的做假数据？ ](https://www.cnblogs.com/sjxjjx/p/6673323.html)

[iOS模拟网络之OHHTTPStubs库的介绍与使用](https://www.jianshu.com/p/3c9638edf26f)

[OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs)


#### 祝在尚德工作愉快！
