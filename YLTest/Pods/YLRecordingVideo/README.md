# YLRecordingVideo

[![CI Status](http://img.shields.io/travis/hoggenw/YLRecordingVideo.svg?style=flat)](https://travis-ci.org/hoggenw/YLRecordingVideo)
[![Version](https://img.shields.io/cocoapods/v/YLRecordingVideo.svg?style=flat)](http://cocoapods.org/pods/YLRecordingVideo)
[![License](https://img.shields.io/cocoapods/l/YLRecordingVideo.svg?style=flat)](http://cocoapods.org/pods/YLRecordingVideo)
[![Platform](https://img.shields.io/cocoapods/p/YLRecordingVideo.svg?style=flat)](http://cocoapods.org/pods/YLRecordingVideo)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

YLRecordingVideo is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "YLRecordingVideo"
```

## Author

hoggenw

## 使用方法
```
        //管理初始化
        let manager = YLRecordVideoManager.shareManager()
        //结果代理
        manager.delegate = self
        //选择质量模式（可不选）
        manager.videoQuality = .normalQuality
        //设置录制时间（默认10秒，可不选）
        manager.recordTotalTime = 10
        //展示录制页面
        manager.showRecordView(viewController: self)
```
结果返回代理

```
extension ViewController: YLRecordVideoChoiceDelegate {
    func choiceVideoWith(path: String) {
        print("选择视频路径为：\(path)")
    }
}
```


## License

YLRecordingVideo is available under the MIT license. See the LICENSE file for more info.
