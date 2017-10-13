在简书上看到[daixunry](http://www.jianshu.com/u/caec77cf4560)一篇关于动画的文章，看到这个动画的时候我也很喜欢，就想着用Swift将它实现，后面集成到加载里面去一定很有意思，下面是自己做出来的成品，主要使用的是CABasicAnimation与CAKeyframeAnimation

![hoggen有意思的.gif](http://upload-images.jianshu.io/upload_images/1400066-bcf313c398d231f1.gif?imageMogr2/auto-orient/strip)

下面就自己主要的想法做一下梳理：
1.考虑到视图由两个半圆箭头组成并旋转且有一个动画略微先动，那么我将红色和绿色分成两个主要部分，分别进行，将承载两个部分动画的layer添加CABasicAnimation(keyPath: "transform.rotation.z");即绕z轴旋转；具体设置如下

```
        baseAnimation.fromValue = Double.pi * 2;
        baseAnimation.toValue = 0;
      //动画持续时间
        baseAnimation.duration = 2.5;
        baseAnimation.repeatCount = HUGE;
        //kCAMediaTimingFunctionEaseInEaseOut 中间时间段内速度较快。可以模拟追逐的感觉
        baseAnimation.timingFunction =  CAMediaTimingFunction(name:  kCAMediaTimingFunctionEaseOut);
```
此外；将绿色部分演示启动0.1秒，追逐的感觉就出来了
```
baseAnimation1.beginTime = CACurrentMediaTime() + 0.1;
```
2.两个动画的实现基本是一致的，我们用CAShapeLayer与UIBezierPath来构建图形

```
 let startAngle: Double = 0;
        let endAngle = startAngle + Double.pi * 0.85;
        
        let width = self.frame.size.width;
        let borderWidth = self.circleLayer1.borderWidth;
        
        let path = UIBezierPath(arcCenter: CGPoint(x: width/2, y: width/2), radius: width/2 - borderWidth, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise:  true);
        
        path.lineWidth     = borderWidth
        path.lineJoinStyle = .round //终点处理
        let pointX = 0 + self.frame.size.width;
        let pointY = 0 + self.frame.size.height/2;
        let originPoint = CGPoint(x: pointX - 0.5, y: pointY - 0.5 );
        let leftPonit = CGPoint(x: pointX - 12, y: pointY + 8);
        let rightPoint = CGPoint(x: pointX + 8, y: pointY + 10)
        
        arrow2StartPath = UIBezierPath();
        arrow2StartPath.move(to: leftPonit);
        arrow2StartPath.addLine(to: originPoint);
        arrow2StartPath.addLine(to: rightPoint);
        arrow2StartPath.lineJoinStyle = .round //终点处理
        
        let leftUpPonit = CGPoint(x: pointX - 14, y: pointY - 14 );
        let rightUPPoint = CGPoint(x: pointX + 6.5, y: pointY - 16)
        
        arrow2EndPath = UIBezierPath();
        arrow2EndPath.move(to: leftUpPonit);
        arrow2EndPath.addLine(to: originPoint);
        arrow2EndPath.addLine(to: rightUPPoint);
        arrow2EndPath.lineJoinStyle = .round //终点处理

        arrows2Layer.path = arrow2StartPath.cgPath;
        
```
其中箭头有两种path ，对应箭头的动画

3.箭头动画；使用CAKeyframeAnimation(keyPath: "path"); 需要提供一些关键点（即我们上面构造的StartPath和EndPath），然后iOS在显示的过程中会根据这些信息自动补齐过渡性的内容。
```
        keyAnimation.values = values;
        keyAnimation.keyTimes = [0.1,0.2,0.3,0.4,0.5];
        keyAnimation.autoreverses = false;
        keyAnimation.repeatCount = HUGE;
        keyAnimation.duration = 2.5;
```
values是传入的关键帧,这里我传入五个关键帧
```
let values2 = [arrow2StartPath.cgPath,arrow2EndPath.cgPath,arrow2StartPath.cgPath,arrow2EndPath.cgPath,arrow2StartPath.cgPath];
```
keyTimes对应每个关键帧的时间，不设置则会均匀实现；keyAnimation.keyTimes = [0.1,0.2,0.3,0.4,0.5];一半时间里执行完我需要的动画动作，剩下的一半时间就会保持在初始状态，这里 keyAnimation.autoreverses = false;这样不会再动画结束后执行逆动画。动画时间与旋转的动画时间保持一致；

这样就完成了这个简单的实现。