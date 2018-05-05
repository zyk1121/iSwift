## RxSwift进阶之UI绑定
&emsp;&emsp;前两次关于Rx的分享，一次是对Rx的一个入门介绍和常用方法整理：[Swift函数式编程入门-RxSwift&MVVM](http://172.16.117.224/ios-team/ios-team/issues/4)，一次是关于冷信号、热信号、Schedulers、Rx内存管理等相关知识的理解：[RxSwift进阶—打渔晒网](http://172.16.117.224/ios-team/ios-team/issues/10)。<br />
&emsp;&emsp;本期主要是关于UI绑定的使用方法，以及UI绑定使用过程中可能遇到的问题和解决办法，最后附上UI绑定以及结合UITableView预估行高的一个简单应用。
### 一、bind
下面是一些最为简单的绑定ui的栗子，而实际项目中这样简单的示例却很少用到，很不实用，而较多的场景是我网络（异步）加载到一些数据，要把这些数据展示到对应的UI上，或者我们有自己的数据实体（Entity，Model），把实体中的某个属性与UI进行关联后，后续想要只更改实体的数据，UI就能自动刷新。

``` Swift 
// Label（初始化label的值）
_ = Observable<String>.just("测试Lable字符串").bind(to: label1.rx.text)
 // switch
_ = Observable<Bool>.just(true).bind(to: sw.rx.isOn)
// segment
_ = Observable<Int>.just(1).bind(to: segment.rx.value)
// slider
_ = Observable<Float>.just(0.6).bind(to: slider.rx.value)
```

和OC中的实体不同，swift中的KVO机制需要满足两个条件：继承自NSObject和对需要进行观察的变量添加dynamic修饰。如下示例：

``` Swift 
class Person:NSObject {
    dynamic var name:String?
    var age:Int = 0
    var comp:Company?
}

class Student:Person {
    var classNo:Int = 0
}

class TestObject:NSObject {
    dynamic var stu:Student?
    dynamic var testStr:String?
    // dynamic 实现KVO要添加的修饰符
}
```
对TestObject的基类中的name进行观察的rx方式如下，testObj2的name属性在1s后进行改变然后动态修改label1和label2的数据：

``` Swift
    var testObj2 = TestObject()
    func test2()
    {
        let stu = Student()
        testObj2.stu = stu
        
        testObj2.rx.observeWeakly(String.self, "stu.name").asObservable().bind(to: label!.rx.text).addDisposableTo(disposeBag)
        testObj2.rx.observe(String.self, "stu.name").asObservable().map { (str) -> String in
            if str != nil {
                let ss = str! + "123"
                return ss
            }
            return ""
            }.bind(to: label2!.rx.text).addDisposableTo(disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
            self.testObj2.stu?.name = "uuuuuuuuu"
        })
        
    }
```
其中observeWeakly的注释说明如下：

``` Swift
     Observes values on `keyPath` starting from `self` with `options` and doesn't retain `self`.

     It can be used in all cases where `observe` can be used and additionally

     * because it won't retain observed target, it can be used to observe arbitrary object graph whose ownership relation is unknown
     * it can be used to observe `weak` properties
```

observe的注释说明如下：

``` Swift
Observes values on `keyPath` starting from `self` with `options` and retains `self` if `retainSelf` is set.

     `observe` is just a simple and performant wrapper around KVO mechanism.

     * it can be used to observe paths starting from `self` or from ancestors in ownership graph (`retainSelf = false`)
     * it can be used to observe paths starting from descendants in ownership graph (`retainSelf = true`)
     * the paths have to consist only of `strong` properties, otherwise you are risking crashing the system by not unregistering KVO observer before dealloc.

     If support for weak properties is needed or observing arbitrary or unknown relationships in the
     ownership tree, `observeWeakly` is the preferred option.
```
针对observe和observeWeakly的总结如下：当我们监听的对象或变量是weak的时候，建议使用observeWeakly，其他使用observe的情况也可以使用observeWeakly。
 
### 二、bind可能遇到的问题
>
1、ui在子线程更新。<br />
2、发送错误onError事件，引起bindui相关的代码crash。<br />
3、对冷信号进行多次订阅或者bind会导致信号的多次执行，有时候会导致要执行的网络请求发送了多次。<br />
4、同一个UI可以被多个数据源绑定，都能刷新UI，可能导致UI展示问题。

根据下面的代码对其进行说明：

```swift
let requestObservable = { () -> Observable<String> in
    return Observable.create({ (observer) -> Disposable in
        // AnyObserver<Element> -> Disposable (AnyObserver<Element>事件源)
        print("模拟异步任务开始...")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            observer.on(.next("10"))
        })
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            observer.on(.next("20"))
            // error crash
            //                    observer.onError(NSError(domain: "ddd", code: -1, userInfo: nil))
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
            observer.on(.next("30"))
            observer.on(.completed)
        })
        return Disposables.create()
    })
}
let sig = requestObservable()
sig.bind(to: self.label!.rx.text)
```
首先创建了一个requestObservable的信号sig，然后bind到label上，1s的时候label展示“10”，2s的时候会在子线程发送“20”，可能导致ui崩溃，如果发送的是onError事件，会直接crash；如果多次对sig进行订阅或者绑定，会发现"模拟异步任务开始..."打印了多次，也就是说对信号进行了多次订阅（这种情况有可能不符合我们的实际需求），针对“同一个UI可以被多个数据源绑定”的问题的场景很容易想明白。

```swift
sig2.bind(to: self.label!.rx.text)
testObj3.rx.observe(String.self, "stu.name").asObservable().bind(to: self.label!.rx.text)
```
那么，如何解决上述的问题呢？

前3个问题可以通过如下方式解决，在主线程上进行订阅，同时保证信号返回error的时候发出“出错啦”的字符串给UI，而且通过.shareReplayLatestWhileConnected()或者.shareReplay(1)把信号转成热信号，那么就可以解决对应的问题了。

```swift
let temp = requestObservable().observeOn(MainScheduler.instance).catchErrorJustReturn("出错啦").shareReplayLatestWhileConnected()
```
针对4“同一个UI可以被多个数据源绑定”的问题怎么解决呢？可以采取对当前UI进行绑定之前把之前的绑定取消掉即可，怎么取消？调用Disposable的dipose方法！（具体方案后面会有详述）。

### 三、drive
现在重点来了，是不是说我所有的信号bind到ui的时候都需要这么一长串代码呢？当然不需要啦，rx已经帮我们封装好了一个比较实用的方法了：drive()来在可能出现上述问题的时候替代bind(to)。而一般情况下我们还是直接使用bindto即可。

``` Swift
// let temp = requestObservable().observeOn(MainScheduler.instance).catchErrorJustReturn("出错啦").shareReplay(1)
        let temp = requestObservable().asDriver(onErrorJustReturn: "出错").asObservable()
        
        temp.subscribe { (event) in
            print(event,Thread.current)
        }
        temp.bind(to: self.label!.rx.text)
        temp.bind(to: self.label2!.rx.text)
// 或者
requestObservable().asDriver(onErrorJustReturn: "出错").drive(self.label!.rx.text)
```
#### drive的特点：

1、不把错误传递出来<br>
2、在主线程观察<br>
3、共享副作用 (shareReplayLatestWhileConnected，shareReplay(1))

### 四、优化disposeBag
现在我们每次在使用rx的时候都会创建一个disposeBag来管理dispose对象，比较麻烦；另外一点是要区分有些cell重用的时候需要取消之前的绑定，但是网络请求的dispose对象却不能取消（有可能网络还未返回）。那么解决当前问题方案如下，给UIView和UIViewController添加关联属性，disposeBag和disposeBagForBinding（数据源可能发生变化的时候使用，比如Cell重用，一般用在bindUI方法中，下次更新数据源的时候取消之前的绑定 ），其他非绑定UI重用的可以直接使用disposeBag，不需要手动创建。

``` Swift
// UIViewController
public extension UIViewController {

    private func synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
    
    /* UI绑定 */
    public func bindUI()
    {
        // 清空之前的绑定
        disposeBagForBinding = DisposeBag()
    }
    /* 一般的使用方式 */
    public var disposeBag: DisposeBag {
        get {
            return synchronizedBag {
                if let disposeObject = objc_getAssociatedObject(self, &disposeBagContext) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(self, &disposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
        set {
            synchronizedBag {
                objc_setAssociatedObject(self, &disposeBagContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    /* 数据源可能发生变化的时候使用，比如Cell重用，一般用在bindUI方法中，下次更新数据源的时候取消之前的绑定 */
    public var disposeBagForBinding: DisposeBag {
        get {
            return synchronizedBag {
                if let disposeObject = objc_getAssociatedObject(self, &disposeBagForBindingContext) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(self, &disposeBagForBindingContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
        set {
            synchronizedBag {
                objc_setAssociatedObject(self, &disposeBagForBindingContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

// UIView 和UIViewController类似
```

### 五、实战
下面采用Rx以及MVVM实现一个如下图的功能（自动估算行高，一般的列表页面都可以采用）：<br />
 ![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx3/1.jpg)
 
 文件目录结构如下：
 
  ![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/rx3/2.jpg)
 
1、数据实体RxTableViewModel： 
 
``` Swift
class RxTableViewModel: NSObject, Mappable {
    
    var content:String = ""
    dynamic var progress:Float = 0.0
    
    // 行高
    var cellHeight:CGFloat = -1.0
    
    class func createObj()->RxTableViewModel? {
        let obj = Mapper<RxTableViewModel>().map(JSON: [:])
        return obj
    }
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        content <- map["content"]
        progress <- map["progress"]
    }
}
```
2、控制器RxTableViewDemoViewController： 

``` Swift
class RxTableViewDemoViewController: UIViewController {

    let mainView        = RxTableViewMainView()
    let mainViewModel   = RxTableViewViewModel()
    let emptyView       = RxEmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupUI()
        bindUI()
        view.setNeedsUpdateConstraints()
        startLoadData()
    }
    
    func setupUI()
    {
        view.addSubview(mainView)
        view.addSubview(emptyView)
        emptyView.isHidden = true
    }
    
    override func bindUI() {
        // 空页面按钮点击
        emptyView.refreshBtn.rx.controlEvent(UIControlEvents.touchUpInside).asObservable().subscribe {[weak self] (event) in
            self?.hideExamEmptyView()
            self?.startLoadData()
        }.addDisposableTo(disposeBag)
    }
    
    func isNoNetwork()->Bool {
        return false
    }
    
    func startLoadData()
    {
        if isNoNetwork() {
            showExamEmptyView()
            // toast 提示用户
            return
        }
        loadData()
    }
    
    func loadMoreData()
    {
        if isNoNetwork() {
            // toast 提示用户
            return
        }
        
        // page + 1，加载更多数据
        loadData()
    }
    
    func showExamEmptyView() {
        self.mainView.isHidden = true
        self.emptyView.isHidden = false
    }
    
    func hideExamEmptyView() {
        self.mainView.isHidden = false
        self.emptyView.isHidden = true
    }
    
    // MARK:Constraints
    override func updateViewConstraints() {
        super.updateViewConstraints()
        mainView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.view).offset(0)
        }
        emptyView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.view).offset(0)
        }
    }
}
```
3、主视图：RxTableViewMainView，一个列表tableview

``` Swift
class RxTableViewMainView: UIView {

    public var tableViewDatas:[RxTableViewModel] = []
    // 定义属性
    public let mainTableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.extColorWithHex("ffffff", alpha: 1.0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(RxTableViewCell.classForCoder(), forCellReuseIdentifier: "RxTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupUI()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        mainTableView.dataSource = self
        mainTableView.delegate = self
        self.addSubview(self.mainTableView)
    }
    
    func setupContentData(data:[RxTableViewModel]) {
        tableViewDatas = data
        self.mainTableView.reloadData()
        
        // 测试数据更新
        self.testupdateData()
    }
    
    func testupdateData()
    {
        for item in tableViewDatas {
            if item.progress > 100 {
                return
            }
            item.progress += 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) { 
            self.testupdateData()
        }
    }
    
    // 布局
    override func updateConstraints() {
        mainTableView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self)
        }
        super.updateConstraints()
    }
}
extension RxTableViewMainView:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDatas.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RxTableViewCell", for: indexPath)
        if let rxCell = cell as? RxTableViewCell {
            rxCell.parentView = self
            rxCell.setupContentInfo(info: tableViewDatas[indexPath.row])
            rxCell.setNeedsUpdateConstraints()
            rxCell.selectionStyle = .none
        }
        return cell
    }
}
```

4、RxTableViewViewModel

``` Swift
class RxTableViewViewModel: NSObject {
    // 抓取网络数据
    func fetchStudentTakeExam(param: [String: Any]) -> Observable<[RxTableViewModel]> {
        return Observable.create({ (observer) -> Disposable in
            self.requestExamData(module:"/tExam", action:"/studentTakeExam", param: param, completion: { (result, error) in
                if error != nil {
                    observer.onError(error!)
                } else {
                    // 获取数据
                    if let objs = result as? [RxTableViewModel] {
                        observer.onNext(objs)
                        observer.onCompleted()
                    } else {
                        let err = NSError(domain: "ddd", code: -1, userInfo: nil)
                        observer.onError(err)
                    }
                }
            })
            return Disposables.create()
        })
    }
}

```
5、一个比较关键的类：RxTableViewCell

``` Swift
class RxTableViewCell: UITableViewCell {

    public weak var itemData:RxTableViewModel?
    public weak var parentView:RxTableViewMainView?
    public let contentLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = UIColor.extColorWithHex("666666", alpha: 1.0)
        label.text = ""
        return label
    }()
    
    public let progressLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.red
        label.text = "0.0%"
        return label
    }()
    
    // init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.extColorWithHex("eeeeee", alpha: 1.0)
        setupUI()
        bindUI()

        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.contentView.addSubview(self.contentLabel)
        self.contentView.addSubview(self.progressLabel)
    }
    
    override func bindUI() {
        // 清空之前的ui绑定
        super.bindUI()
        // 绑定ui数据
        if let item = itemData {
            // 使用 disposeBagForBinding
//            self.progressLabel.text = "\(item.progress)"
            item.rx.observe(Float.self, "progress").asObservable().map({ (value) -> String in
                if value != nil {
                    return "\(value!)%"
                }
                return "0.0%"
            }).bind(to: self.progressLabel.rx.text).addDisposableTo(disposeBagForBinding)
        }
    }

    func setupContentInfo(info:RxTableViewModel) {
        if itemData != nil && itemData! == info {
            return
        }
        self.itemData = info
        
        self.contentLabel.text = info.content
        self.contentLabel.sizeToFit()
        if let index = self.parentView?.mainTableView.indexPath(for: self) {
            self.parentView?.mainTableView.reloadRows(at: [index], with: UITableViewRowAnimation.automatic)
        }
        // 重新绑定ui
        bindUI()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        self.progressLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(60)
            make.right.equalTo(self.contentView).offset(-20)
        }
        
        self.contentLabel.sizeToFit()
        self.contentLabel.snp.remakeConstraints { (make) in
            make.left.top.equalTo(self.contentView).offset(20)
            make.bottom.equalTo(self.contentView).offset(-20)
            make.right.equalTo(self.progressLabel.snp.left).offset(-20)
        }
        super.updateConstraints()
    }
}
```
关键是RxTableViewCell的setupContentInfo 以及 bindUI方法，解决行高自动计算以及cell重用多次绑定的问题，以及动态刷新cell中数据的常见操作（改变数据源，ui动态变化）。<br>
效果以及细节见demo以及讲解。[张元科技术分享链接](http://172.16.117.224/ios-team/ios-team/tree/master/Wiki/zhangyuanke)

### 六、总结以及展望
>
>本章节是继前两次分享后的一次实践，尽管内容只涉及到bind，但是，其他相关的概念以及用法都可以类推。主要对基于tableview的动态行高以及rx在数据实体与UI动态绑定方面可能遇到的问题进行了介绍并给出了一整套的解决方案；优化disposeBag后不用再在UIView和UIViewController的子类中创建disposeBag对象，直接使用等优化和整理，期望大家能够用的开心~
>
>整理的过程中难免出现理解有误的地方，欢迎随时指出和交流~<br>
>
>后续如果有时间会再对Rx的使用心得进行总结和分享，大家在使用的过程中也希望能够多交流心得和分享所遇到的问题~
>
>期待与组内同学一起成长和进步~祝大家工作愉快~
