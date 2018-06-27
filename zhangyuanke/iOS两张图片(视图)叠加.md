## iOS两张图片(视图)叠加>
做在线签到的过程中，发现签到背景图的生成比较有意思，而且在做的过程中确实有过一些思考，记录下来，方便后人。

### 一、实现效果
签到页面的效果图如下：
![](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/image/image1.jpg)
点击下载按钮后保存到系统相册的效果如下：
![](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/image/image2.jpg)
观察后发现，保存的图片背景部分多了一个虚线分割线、一个“我在尚德机构连续学习了多少天”、和一个二维码。

### 二、实现方案
其实很容易想到，多出来的部分一定要整体是一个View会比较简单，直接添加到后面的背景图上去，然后截屏背景图即可，于是实现代码如下（删除了很多无用代码，可以直接到项目中看）：

``` Swift
// 签到默认背景图
class YKSignBgView : UIImageView {
    public let monthsEn = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec"]
    public let monthLabel:UILabel = {
    }()
    
    public let monthSepLabel:UILabel = {
    }()
    
    public let dayLabel:UILabel = {
    }()
    
    public let oneDayLabel:UILabel = {
    }()
    
    public let bottomView = YKSignBgBottomView()
    
    var contentOffset:CGFloat = -20
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupUI()
    }
    func setupUI() {
        // 其他元素
        oneDayLabel.sizeToFit()
        monthSepLabel.sizeToFit()
        monthLabel.sizeToFit()
        dayLabel.sizeToFit()
        self.addSubview(oneDayLabel)
        self.addSubview(monthLabel)
        self.addSubview(monthSepLabel)
        self.addSubview(dayLabel)
        self.addSubview(bottomView)
        bottomView.setSerialDays(day: 40)
        bottomView.isHidden = true
        needsUpdateConstraints()
    }
    
    // 生成带有二维码视图的图片
    func makeImage()->UIImage {
        bottomView.isHidden = false
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        bottomView.isHidden = true
        return viewImage
    }
}
// 有二维码的底部图片视图
class YKSignBgBottomView:UIView {
    
    private let iconView:UIImageView = {
    }()
    
    private let descLabel1:UILabel = {
    }()
    
    //创建虚线
    private let sepLine:UIView = {
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupUI()
    }
    func setupUI() {
        self.addSubview(iconView)
        self.addSubview(descLabel1)
        self.addSubview(sepLine)
        needsUpdateConstraints()
    }
    
    func setSerialDays(day:Int) {
        let attrText = NSMutableAttributedString(string: "我在尚德连续学习", attributes: [NSAttributedStringKey.foregroundColor:UIColor.extColorWithHex("ffffff", alpha: 1.0),NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)])
        _ = attrText.add(string: "\(day)", attrDic: [NSAttributedStringKey.foregroundColor:UIColor.extColorWithHex("ffffff", alpha: 1.0),NSAttributedStringKey.font:UIFont.systemFont(ofSize: 44)])
        _ = attrText.add(string: "天", attrDic: [NSAttributedStringKey.foregroundColor:UIColor.extColorWithHex("ffffff", alpha: 1.0),NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)])
        descLabel1.attributedText = attrText
    }
}
``` 
>
其实上面的代码不用看，YKSignBgView上addSubview了bottomView:YKSignBgBottomView，之后看生成图片的代码makeImage即可，方法是先bottomView.isHidden = false，然后生成图片，再bottomView.isHidden = true的步骤。（bottomView在底部正常约束布局，透明）。

### 三、上述方案的问题 & 优化
上述方案有什么问题呢？
>
生成图片的过程中，底部视图bottomView可能会闪现！

那如何解决和优化呢？当时就想到了，如果视图不在视图栈上了是不是就看不到了，于是把bottomView从父视图移除，并在上下文中绘制（self.bottomView.layer.render）【代码在下面】，绘制完后会发现一个新的问题，bottomView绘制在了所生成图片的顶部？可想而知，bottomView已经从从父视图移除了，重新render的时候，是从上下文的起始位置(0,0)点开始的，所以绘制在了顶部，那好办哪，立马把bottom的布局修改成了和YKSignBgView的大小一致，重新生成图片，成功！（bottomView约束和父view相同，透明）。

``` Swift
    // 生成带有二维码视图的图片
    func makeImage()->UIImage {
        if (bottomView.superview != nil) {
            bottomView.removeFromSuperview()
        }
        bottomView.isHidden = false
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        self.bottomView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        bottomView.isHidden = true
        return viewImage
    }
``` 

### 四、其他方案
其实我们还可以bottomView的布局不变，绘制的时候在指定的位置绘制（但相对比较麻烦）；另外一种方案是，两个View各自生成图片后合成，网上都有现成的方法，未尝试(据说Android是用的这个方案，而且做的过程尝试了多种方法)。
参考：[ios合并两张图片(叠加两张图片 重合两张图片)](https://blog.csdn.net/littlesun_zheng/article/details/51480261)


#### 祝在尚德工作愉快！
