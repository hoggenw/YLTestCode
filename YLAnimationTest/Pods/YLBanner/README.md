# YLBanner

[![CI Status](http://img.shields.io/travis/dev-wangliugen/YLBanner.svg?style=flat)](https://travis-ci.org/dev-wangliugen/YLBanner)
[![Version](https://img.shields.io/cocoapods/v/YLBanner.svg?style=flat)](http://cocoapods.org/pods/YLBanner)
[![License](https://img.shields.io/cocoapods/l/YLBanner.svg?style=flat)](http://cocoapods.org/pods/YLBanner)
[![Platform](https://img.shields.io/cocoapods/p/YLBanner.svg?style=flat)](http://cocoapods.org/pods/YLBanner)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

YLBanner is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "YLBanner"
```
## 调用方法
```

       let bannerScroller = YLBanner(frame: CGRect(x: 0, y: 0, width: MAIN_WIDTH, height:BannerHeight), 3)
        //你的数据源    
        var array  = [UIImageView]()
        
        for model in dataArray[0] {
            array.append(model.bannerImageView)
        }
       // 获取数据源
        bannerScroller?.contentViewAtIndex = {(_ pageIndex: Int) in
            if array.count > 0 {
                return array[pageIndex]
            }
            return UIImageView()
        }

        
        //获取轮播张数，大于1启动轮播
        bannerScroller?.setTotalPagesCount(totalPageCout: { () -> (Int) in
                return array.count

        })

        //点击回调响应
        bannerScroller?.tapActionBlock = {[weak self](index) in
            if (self?.dataArray[0].count)! > 0 {
                let model = self?.dataArray[0][index]
                MobClick.event("Banner")
                print("model?.url=\(model?.url)")
                self?.dealModel(model: model!)
            }

            
        }
```

## Author

hoggenw

## License

YLBanner is available under the MIT license. See the LICENSE file for more info.
