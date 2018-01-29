//
//  FooView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/5/19.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "FooView.h"
#import <objc/message.h>

@interface FooView ()
@property (nonatomic,copy) NSString * kDTActionHandlerTapGestureKey;
@property (nonatomic,copy) NSString * kDTActionHandlerTapBlockKey;
@property (nonatomic,nonnull) NSString * name;
@end

@implementation FooView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.kDTActionHandlerTapGestureKey = @"kDTActionHandlerTapGestureKey";
        self.kDTActionHandlerTapBlockKey = @"kDTActionHandlerTapBlockKey";
    }
    
    
    return  self;
}

-(void)setTapActionWithBlock:(void (^)(void))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &_kDTActionHandlerTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &_kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &_kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_RETAIN);
    
    
    // 移除关联对象
    void objc_removeAssociatedObjects ( id object );
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^action)(void) = objc_getAssociatedObject(self, &_kDTActionHandlerTapBlockKey);
        
        if (action)
        {
            action();
        }
    }
}

@end





































