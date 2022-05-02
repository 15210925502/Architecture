# SDTheme

## 使用方法非常简单：
### 初始化：
```
[[SDThemeManager sharedInstance] setupThemeNameArray:@[@"White", @"Black"]];
```
### 切换主题：
```
[[SDThemeManager sharedInstance] changeTheme:@"Black"];
```
### 具体设置皮肤：

具体调用非常简单，比如需要换肤的视图控件原本是调用`backgroundColor`设置颜色，只需要换成调用扩展方法`theme_backgroundColor`即可，例如：
```
self.view.theme_backgroundColor = @"block_bg";
self.textField.theme_textColor = @"text_h1";
self.image.theme_image = @"icon_face";
```
富文本需要用`SDThemeForegroundColorAttributeName`替换`NSForegroundColorAttributeName`，例如：
```
navBar.theme_titleTextAttributes = @{SDThemeForegroundColorAttributeName:@"text_h1"};
```

另外有些常用的属性在XIB等可视化视图也可以直接设置，例如：
![](https://upload-images.jianshu.io/upload_images/1457495-babdc4785500a901.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


如果直接设置属性的方式不满足需求，还可以自己监听通知`SDThemeChangedNotification`，收到通知之后自行做颜色图标等切换。

## 资源管理
新建`ColorsMap_XX.plist`
* 颜色字符串：颜色字符串可以参考一下Demo中的文件，首先要有一个大分类，例如Demo中的`block、text、line`(跟随自己需要分类就好，这里的分类我是扒竞品`富途牛牛`的🤠)，如果你有一个分类叫`SomeThing`，那分类下内容命名要带上相应的前缀`SomeThing_`，不然会报找不到，`color string`是HEX 或者AHEX格式。 

## 主要实现原理：
其实实现原理也是非常简单的，我这里拿`UIView`举例子：

```
@interface UIView (SDTheme)

@property (nonatomic, copy) NSString *theme_backgroundColor;
@property (nonatomic, copy) IBInspectable NSString *sd_background;
@property (nonatomic, copy) NSString *theme_tintColor;

@end
```

这是针对UIView提供的扩展，大家可以看到其中有换肤属性`theme_backgroundColor `，如下图，我们在属性`theme_backgroundColor `的`Setter`方法中有根据主题配置调用系统的相应方法，然后对控件注册监听，等切换主题之后就会收到通知，然后执行`theme_didChanged`方法，为控件设置正确的主题UI，That’s all~ 
![](https://upload-images.jianshu.io/upload_images/1457495-be5e9bcef42b2b14.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
