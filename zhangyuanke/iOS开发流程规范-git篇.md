##尚德iOS开发流程规范-git篇####一、整体流程图![icon](http://localhost:8080/icon/git_001.jpeg)>说明：本流程适用于组件化项目和主工程，当然，并不是说只添加一行代码也需要这样的流程，完全没必要，少量代码可以不创建新的分支，直接在本地的development上修改之后提交到origin，再合并到upstream即可。
>
其他注意事项：<br>
1、每次修改代码（新需求）前需要先拉取upstream上对应分支的最新代码，合并到本地。<br>
2、无用的分支记得删除。<br>
3、发版后记得创建对应的release分支，可以直接从相应的development上切出。<br>
4、不要怕创建的分支太多，并不会占用很多资源（记得清理就好）。<br>
5、很多操作都是在gitLab上进行的（在ios-team上切出分支，拉取到本地；打tag等）。<br>
6、功能开发测试完成之前不要在mater分支上打tag。<br>####二、主工程使用方式
>
1、基础库（社区、视频直播、课程题库、IM模块外），由于和业务无关，很少更新代码（或者更新代码对主工程无太大影响），可以考虑集成的时候直接pod 'SDJGUIFrameProject'，不指定具体的版本号。<br>
2、业务模块（社区、视频直播、课程题库、IM），在mater分支需要 '= 1.8' 的方式指定具体版本。

    #社区项目 文彬 维克
    pod 'SDJGCommunityProject', '=1.8'
    #用户信息项目 王俊
    pod 'SDJGUserinfoProject', '=1.8'
    #活动运营 王俊
    pod 'SDJGActivityOperationProject', '=1.8'
    
####三、自己如何在主工程中测试自己的模块功能是否正常？
>
方法是，通过指定具体的git路径、分支和commit号的方式即可（在dev分支或者切出新的分支即可测试新模块功能）。

    pod 'SDJGActivityOperationProject'
    #课程项目 引入题库  元科
    pod 'SDJGCourseProject', :git => 'http://172.16.117.224/ios-team/sdjgcourseproject.git', :commit => 'edbfd3e54'
     #社区项目 文彬 维克
    pod 'SDJGCommunityProject',:git => 'http://172.16.117.224/ios-team/sdjgcommunityproject.git',:branch => 'feature/teacher_home', :commit => '298918989'

####四、组件化工程支持独立测试
>
组件化的功能如果足够独立，前期可以考虑在组件化上进行测试验证（提供测试组件化的包），最后在主工程上进行整体验证。

#### 祝在尚德工作愉快！