//
//  YLImageMagnification.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/7/9.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLImageMagnification.h"
//图片放大 缩小 移动与浏览
@implementation YLImageMagnification

//原始尺寸
static CGRect oldframe;

/**
 *  浏览大图
 *
 *  @param currentImageview 当前图片
 *  @param alpha            背景透明度
 */
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview alpha:(CGFloat)alpha {
    
    //  当前imageview的图片
    UIImage *image = currentImageview.image;
    if (image == nil) {
        return;
    }
    //  当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //  背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //  当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:alpha]];
    
    //  此时视图不会显示
    [backgroundView setAlpha:0];
    //  将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setImage:image];
    imageView.contentMode =UIViewContentModeScaleAspectFit;
    [imageView setTag:1024];
    [backgroundView addSubview:imageView];
    //  将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    
    //  添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    [YLImageMagnification addGestureRecognizerToView: backgroundView];
    
    //  动画放大所展示的ImageView
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    
    UIView *backgroundView = tap.view;
    //  原始imageview
    UIImageView *imageView = [tap.view viewWithTag:1024];
    //  恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}


// 添加所有的手势
+ (void)addGestureRecognizerToView:(UIView *)view
{
    //    // 旋转手势
    //    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    //    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}

// 处理旋转手势
+ (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
+ (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        if (view.frame.size.width <= [UIScreen mainScreen].bounds.size.width ) {
            [UIView beginAnimations:nil context:nil]; // 开始动画
            [UIView setAnimationDuration:0.5f]; // 动画时长
            /**
             *  固定一倍
             */
            view.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
            [UIView commitAnimations]; // 提交动画
        }
        if (view.frame.size.width > 2 * [UIScreen mainScreen].bounds.size.width) {
            [UIView beginAnimations:nil context:nil]; // 开始动画
            [UIView setAnimationDuration:0.5f]; // 动画时长
            /**
             *  固定2倍
             */
            view.transform = CGAffineTransformMake(2, 0, 0, 2, 0, 0);
            [UIView commitAnimations]; // 提交动画
        }
        
        
        CGFloat originX = view.frame.origin.x;
        CGFloat originY = view.frame.origin.y;
        CGFloat width = view.frame.size.width;
        CGFloat height = view.frame.size.height;
        if (originX > 0) {
            originX = 0;
        }else if (originX + width < [UIScreen mainScreen].bounds.size.width) {
            originX =  [UIScreen mainScreen].bounds.size.width - width;
        }
        if (originY > 0) {
            originY = 0;
        }else if (originY + height < [UIScreen mainScreen].bounds.size.height) {
            
            originY = height - [UIScreen mainScreen].bounds.size.height;
        }
        view.frame = CGRectMake(originX, originY, width, height);
        
        pinchGestureRecognizer.scale = 1;
    }
    
    
    
    //    UIView *view = pinchGestureRecognizer.view;
    //    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
    //        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    //        if (view.frame.size.width < [UIScreen mainScreen].bounds.size.width) {
    //            view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //            //让图片无法缩得比原图小
    //        }
    //
    //        if (view.frame.size.width > 3 * [UIScreen mainScreen].bounds.size.width) {
    //            CGRect nowFrame = view.frame;
    //            view.frame = CGRectMake(nowFrame.origin.x, nowFrame.origin.y,  3 * [UIScreen mainScreen].bounds.size.width,  3 * [UIScreen mainScreen].bounds.size.height);
    //        }
    //
    //        pinchGestureRecognizer.scale = 1;
    //    }
}

// 处理拖拉手势
+ (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    //    UIGestureRecognizerState state = [panGestureRecognizer state];
    //
    //    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    //    {
    //        CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    //        [panGestureRecognizer.view setTransform:CGAffineTransformTranslate(panGestureRecognizer.view.transform, translation.x, translation.y)];
    //        [panGestureRecognizer setTranslation:CGPointZero inView:panGestureRecognizer.view];
    //    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        //NSLog(@"view.center.x : %@   view.center.y: %@  view.bounds.size.width: %@   view.bounds.size.height: %@",@(view.center.x),@(view.center.y),
        // @(view.frame.size.width/2),@(view.frame.size.height/2));
        CGFloat width = view.frame.size.width/2;
        CGFloat height = view.frame.size.height/2;
        CGFloat centerX = view.center.x +  translation.x;
        CGFloat centerY = view.center.y + translation.y;
        if (width <= centerX) {
            centerX = width;
        }else if ([UIScreen mainScreen].bounds.size.width >= width + centerX ){
            centerX = [UIScreen mainScreen].bounds.size.width - width;
        }
        
        if (  centerY >= height) {
            centerY = height;
        }else if ([UIScreen mainScreen].bounds.size.height >= height + centerY ){
            centerY = [UIScreen mainScreen].bounds.size.height - height;
        }
        [view setCenter:(CGPoint){centerX, centerY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

@end
