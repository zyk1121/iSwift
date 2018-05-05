## 查找SDWebImageDownloaderOperation的appendData找不到方法过程的小小收获

#### SDWebImage中的问题描述： 
 ![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/sdimage_bug_1.png)
##### 有一个存储图像下载数据的变量：
>
@property (strong, nonatomic, nullable) NSMutableData *imageData; 

过程应该是：用户执行了下载的操作，又在另一个线程中执行了取消下载的操作，下载到数据会执行appendData方法，而取消下载会执行imageData=nil; 

类似如下扥代码： 
 ![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/sdimage_bug_2.png)
但是当前的代码crash的时机特别少，于是做了如下的修改： 
  ![icon](http://172.16.117.224/ios-team/ios-team/raw/master/Wiki/zhangyuanke/icon/sdimage_bug_3.png)
#### 那么这段代码还可以做很多其他的修改，比如，_imageData重新创建等等。 

#### 此代码执行会遇到的不只是方法找不到，还有一些其他的问题，如下： 
>
//1， malloc: *** error for object 0x170016b40: pointer being realloc'd was not allocated.   
//2， EXC_BAD_ACCESS.    
//3， [__NSMallocBlock__ appendBytes:length:]: unrecognized selector sent to instance 0x17024e8b0.  
//4， overreleased while already deallocating; break on objc_overrelease_during_dealloc_error to debug.    
//5， malloc: *** error for object 0x170014220: Invalid pointer dequeued from free list.    
//6， malloc: *** error for object 0x170014220: pointer being freed was not allocated 

也就是说unrecognized selector 只是其中的一个问题，当然，SDWebImage不会有其他的一些问题，因为对象只创建和释放了一次。 
#### 下面就一一解释其中的原因： 
解释之前我们要先知道一个概念，_imageData = nil到底做了什么？没有这行代码还会crash吗？对象的创建到底做了什么？？？好多问题~ 
不知道，好吧，那我就直接说啦。
> 
A>    _imageData = nil; 其实编译器（iOS系统的）会把代码做如下的分解： 
           [_imageData release]; 
           _imageData = nil;
           很简单是不是，只要知道MRC，应该很容易明白其中的原理。   
B>    _imageData = [[NSMutableData alloc] init]; 又是什么样的呢？ 
            猜测应该是： 
            [_imageData release];// 并没有赋值nil
            _imageData = [[NSMutableData alloc] init]; 

知道了上面两个概念之后2，3，4问题即可迎刃而解，不明白的自己多想想吧。 

#### 那么1和5,6又是什么东东？怎么还会有这样的错误呢？ 
其实1的错误也比较简单，是_imageData.bytes惹的祸，当我们appendBytes的时候系统要为_imageData.bytes重新分配（realloc）内存，但是，此时的_imageData.bytes可能正在被alloc，所以才会出现这样的错误！ 

>
那么5，6呢，是不是很难，O__O “…，确实是不简单，想了好久：（下面只是猜想，没有实际的依据，供参考） 
内存其实是被一个链表维护着的（list），可以去网上查看内存管理相关的概念。 
一个对象（一个内存块）在内存中有多种状态（未被分配，已被分配（引用计数count >= 1），正在被释放（being free），已经释放可以使用（存入可分配链表中），等等）
 
#### 那么当我们对一个变量执行release操作的时候到底做了什么，下面是伪代码： 
``` Objective-C 
void releseObj(void * mem) 
{ 
    If (!mem) return; 
    // 内存是否完好，释放的是否是申请的内存 
    If(!mem->isOK) { 
        // 报错，返回 
        return; 
    } 
    //引用计数 
    If(mem->retainCount > 1) { 
        mem->retainCount -= 1 
        return; 
    } 
    mem->retainCount = 0； 
    Mem->flag = isFreeing;// 正在释放
    addToFreeList(mem);// （可能和runloop中的autorelasepool有关系，否则直接释放不就ok了） 
    // 之后从free链表中dequeue该mem
    // 执行释放操作free(mem)，把当前的内存块又放入到可被分配的内存链表中，没有对当前的内存进行清空操作 
    // 如果此时访问该内存，有可能还是正确的，（包括执行方法等）
   // 一些其他操作 
    mem->flag=allocAble;// 可以释放
} 
```
#### 申请一块内存伪代码 
``` Objective-C 
Void *allocObj() 
{ 
    // 先去可用内存链表上找一块可以用的内存（其实，是有缓存的，此处先不考虑了） 
    void *ptr = ..
    // 做一下判断
    If (ptr->flag != allocAble) { 
        // 出错，比如正在被释放 
        // 错误6应该是这种情况，有两个线程都进行释放操作，而且都走到了 mem->retainCount = 0； 
        // 其中一个执行完了释放操作，而且把内存块放入了可以申请的链表中， mem->flag=allocAble;这个时候有一个要申请内存的操作，当然，这个内存块是可以被申请的，但是，当真正进行申请的时候，另一个线程又对该内存进行了释放后续操作，。。。 
        // 错误5 和6 是类似的，也是这个地方进行了判断发现该内存正在被freelist释放，所以申请失败 
        // 触发断点
        Return NULL
    } 
    Ptr->retainCount = 1; 
    Return ptr;
} 
```
#### 有疑问？为什么不加锁呢 
呵呵，CPU消耗大（效率低） 

#### 简单整理，理解不正确的话欢迎指正 - by zyk  
