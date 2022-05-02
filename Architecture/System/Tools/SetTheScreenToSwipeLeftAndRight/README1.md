# 禁止和开启当前控制器的（滑动返回、全屏滑动返回、自定义区域滑动返回和右滑push方法）
1.⚠️不用关心HLDDelegateHandler类中所有方法和属性
  ⚠️不用关心HLDDelegateHandler类中所有方法和属性
  ⚠️不用关心HLDDelegateHandler类中所有方法和属性
2.设置和获取侧滑返回手势属性：hld_interactivePopDisabled （是否禁止当前控制器的滑动返回(包括全屏返回和边缘返回)，默认为NO）
3.设置和获取侧全屏返回手势属性：hld_fullScreenPopDisabled （是否禁止当前控制器的全屏滑动返回，默认为NO）
4.自定义屏幕返回手势区域属性：hld_popMaxAllowedDistanceToLeftEdge （全屏滑动时，滑动区域距离屏幕左边的最大位置，默认是0：表示全屏都可滑动）
5.使用右滑手势说明
 1）、首先UINavigationController类设置hld_rightSlidePushEnable为YES(⚠️此属性不开启，右滑push手势也不可用)
 2）、在左滑类中遵循HLDVCRightSlidePushDelegate代理
 3）、让self.hld_RightSlidePushDelegate = self;
 4）、重写- (void)RightSlidePushToNextViewController方法
 5）、使用完毕后，不能自动释放，要在页面关闭的时候至为nil
    - (void)viewDidDisappear:(BOOL)animated{
        self.hld_rightSlidePushDelegate = nil;
    }
