// demo.js
require('SdwxEngine,SdwxTools,MMServiceCenter,CContactMgr,CContact,ContactsViewController,NewSettingViewController')

// JS
// 联系人管理类
defineClass('CContactMgr', {
    // 获取当前用户的信息
    getSelfContact:function() {
            var temp = self.ORIGgetSelfContact();
            // 更新当前用户wxid
            SdwxTools.shareInstance().updateWxidWithMgr(temp);
            return temp;
    },
})

// 设置（摇一摇功能）
defineClass('NewSettingViewController',{
    // 动态添加方法
    motionEnded_withEvent:function(motion,event) {
        SdwxEngine.shareInstance().shakeMotion();
    },
})


