//
//  MapCarAnnotationView.m
//  YLOCAnimationTest
//
//  Created by 王留根 on 2018/3/13.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "MapCarAnnotationView.h"

@implementation MapCarAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self =  [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = NO;
    }
    
    return self;
}

@end
