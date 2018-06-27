#!/usr/bin/python
# -*- coding: UTF-8 -*-
import os
import shutil

# 版本号
oldVersion = "1.0.2"
newVerison = "1.0.3"
# 文件夹名称[对应开发者账号名称，chensun对应的是主目录的相关文件] 
# "chensun","yunfeima","hailongchen","houhualin","hucehngwen","baotaiyu","lizhipeng","wanghongdan"
developers = ["chensun","yunfeima","hailongchen","houhualin","hucehngwen","baotaiyu","lizhipeng","wanghongdan"]

# 定义创建文件夹方法
def mkdir(path):
    folder = os.path.exists(path)
    if not folder:
        os.makedirs(path)
    else:
        print "请先删除文件夹：" + path

# 修改原文件内容
def alter(filename,old_str,new_str):
    file_data = ""
    with open(filename, "r") as f:
        for line in f:
            if old_str in line:
                line = line.replace(old_str,new_str)
            file_data += line
    with open(filename,"w") as f:
        f.write(file_data)
    print "修改文件："+ filename + " "+  old_str + " 替换 " + new_str +  " 成功\n"

# 拷贝文件
def mycopyfile(srcfile, dstfile):
    if not os.path.isfile(srcfile):
        print "%s not exist!"%(srcfile)
    else:
        fpath,fname=os.path.split(dstfile)    #分离文件名和路径
        if not os.path.exists(fpath):
            os.makedirs(fpath)                #创建路径
        shutil.copyfile(srcfile,dstfile)      #复制文件
        print "copy %s -> %s"%( srcfile,dstfile)

# 版本号修改
alter("version.json", oldVersion, newVerison)
alter("wechat.html", oldVersion, newVerison)
print("1、version.json和wechat.html文件修改版本号v" + newVerison + "成功.\n")

# 创建文件夹 拷贝文件
for file in developers:
    mkdir(file)
    mycopyfile("wechat.plist",file + "/wechat.plist")
    alter(file + "/wechat.plist", "/wechat.ipa","/" + file + "/wechat.ipa")
    mycopyfile("wechat.html",file + "/wechat.html")
    alter(file + "/wechat.html", "/wechat.plist","/" + file + "/wechat.plist")


print("成功：请打包对应账号的ipa包放到指定的目录后上传FTP，注意XCode构建app的时候修改对应的下载链接。\n")
print("注意：ipa包的名称都是wxchat.ipa。\n")

