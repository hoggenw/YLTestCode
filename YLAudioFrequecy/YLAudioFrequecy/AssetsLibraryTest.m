//
//  AssetsLibraryTest.m
//  YLAudioFrequecy
//
//  Created by hoggen on 2017/6/18.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetsLibraryTest.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsFilter.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>


@interface AssetsLibraryTest ()

@property (nonatomic, strong)NSMutableArray *groups;

@end

@implementation AssetsLibraryTest

- (void)test1 {

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    self.groups = [NSMutableArray array];
  
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) { // 遍历相册还未结束
            [group setAssetsFilter: [ALAssetsFilter allPhotos]];
            if (group.numberOfAssets) {
                [self.groups addObject: group];
                 NSLog(@"相册列表%@个", @(self.groups.count));
                [self enumerateAssets];
            }else {
                if (self.groups.count) {
                    NSLog(@"相册列表%@个", @(self.groups.count));
                    // 如果相册个数不为零，则可以在此处开始遍历相册了
                    //[self enumerateAssets];
                } else {
                    NSLog(@"没有相册列表");
                }
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"遍历失败");
    }];

    
}

/*遍历相册（ALAssetsGroup）中的照片（ALAsset）和遍历资源库（ALAssetsLibrary）中的相册过程十分的类似，不过遍历相册中的照片更加的灵活，可以通过enumerateAssetsUsingBlock: 遍历所有的照片，同时可以通过enumerateAssetsAtIndexes:options:usingBlock:方法遍历指定index的照片。这正如上面代码中段注释类是遍历所有的照片，段注释下面遍历指定index一样。*/

- (void)enumerateAssets {
    NSMutableArray * assets = [NSMutableArray new];
    for (ALAssetsGroup * group in self.groups) {
        
        [self showALAssetsGroupInfo: group];
        /*
         // 遍历所有的相片
         [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
         if (result) { // 遍历未结束
         [assets addObject:result];
         } else { // result 为nil，遍历结束
         
         }
         }];
         */
        
        // 遍历指定的相片
        NSInteger fromIndex = 0; // 重指定的index开始遍历
        NSInteger toIndex =5; // 指定最后一张遍历的index
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:toIndex] options:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (index > toIndex) { // 已经遍历到指定的最后一张照片
                *stop = YES; // 停止遍历
            } else {
                if (result) {
                    // 存储相片
                    [assets addObject:result];
                    [self showPhotoWith: result];
                    NSLog(@"存储照片");
                } else { // 遍历结束
                    // 展示图片
                    //[self showPhotoWith:result];
                }
            }
        }];
    }
}
- (void)showPhotoWith:(ALAsset *)asset {
    // 获取ALAsset对应的ALAssetRepresentation
    ALAssetRepresentation * representation = [asset defaultRepresentation];
    
    NSLog(@"%@", representation.url); // 图片URL
    NSLog(@"%@", NSStringFromCGSize(representation.dimensions)); // 图片尺寸
    NSLog(@"%lld", representation.size); // 数据字节
    NSLog(@"%@", representation.UTI); // Uniform Type Identifier : 统一类型标识符（表示图片或视频的类型）
    NSLog(@"%@", representation.filename); // 在相册中的文件名
    NSLog(@"%@", representation.metadata); // 元数据（一些设备相关的信息，比如使用的相机）
    NSLog(@"%lf", representation.scale); // 缩放比例
    NSLog(@"%ld", representation.orientation); // 方向
    /**
     fullScreenImage : 返回当前设备尺寸大小的图片，编辑后的图片
     fullResolutionImage ： 原图，没有编辑的图片
     */
    // 获取原图
    UIImage * image = [UIImage imageWithCGImage:[representation fullScreenImage] scale:1.0 orientation:UIImageOrientationDownMirrored];
    //self.imageView.image = image;
}

- (void)showALAssetsGroupInfo:(ALAssetsGroup *)assetsGroup {
    
    // 是否可编辑,即相册是否可以通过代码添加相片
    BOOL editable = assetsGroup.editable;
    
    // 添加一个ALAsset到当前相册,前提editable = YES，
    [assetsGroup addAsset:nil];
    
    /**
     + (ALAssetsFilter *)allPhotos; // 获取Photo
     + (ALAssetsFilter *)allVideos; // 获取Video
     + (ALAssetsFilter *)allAssets; // 获取Photo还有video
     */
    // 设置过滤器
    [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    // 当前过滤器下的ALAsset数量
    NSInteger number = assetsGroup.numberOfAssets;
    
    /**
     NSString *const ALAssetsGroupPropertyName; // Group的名称
     NSString *const ALAssetsGroupPropertyType; // Group类型（ALAssetsGroupType）
     NSString *const ALAssetsGroupPropertyPersistentID;
     NSString *const ALAssetsGroupPropertyURL; // 唯一表示这个Group的URL，可以通过URL在资源库中获取对应的Group，用于唯一标识这个group
     */
    // 通过Property获取ALAssetsGroup对应的信息
    NSLog(@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]);
    NSLog(@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyType]);
    NSLog(@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID]);
    NSLog(@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyURL]);
    
    // 获取相册封面
    [assetsGroup posterImage];
    
}

- (void)showALAssetInfoWith:(ALAsset *)asset {
    /**
     NSString *const ALAssetPropertyType;
     NSString *const ALAssetPropertyLocation;
     NSString *const ALAssetPropertyDuration;
     NSString *const ALAssetPropertyOrientation;
     NSString *const ALAssetPropertyDate;
     NSString *const ALAssetPropertyRepresentations;
     NSString *const ALAssetPropertyURLs;
     NSString *const ALAssetPropertyAssetURL;
     */
    NSLog(@"%@", [asset valueForProperty:ALAssetPropertyType]); // 这个type表示这个是photo还是video
    NSLog(@"%@", [asset valueForProperty:ALAssetPropertyLocation]); // 拍摄的地点
    NSLog(@"%@", [asset valueForProperty:ALAssetPropertyDuration]); // 视频的时长
    NSLog(@"%@", [asset valueForProperty:ALAssetPropertyOrientation]); // 照片的方向
    NSLog(@"%@", [asset valueForProperty:ALAssetPropertyDate]); // 照片的拍摄时间
    NSLog(@"%@", [asset valueForProperty:ALAssetPropertyRepresentations]);
    NSLog(@"%@", [asset valueForProperty:ALAssetPropertyURLs]); //
    NSLog(@"%@", [asset valueForProperty:ALAssetPropertyAssetURL]);
    
    [asset thumbnail]; // 返回缩略图
    [asset aspectRatioThumbnail]; // 等比例缩略图
    [asset representationForUTI:@"public.jpeg"]; // 通过统一类型标识获取ALAssetRepresentation
    
    // ALAsset 还具有更改ALAsset中的元数据能力
    // ALAsset 的实例方法能保存Photo、video到相册
}

/*4. AssetsLibrary 的坑点
 
 AssetsLibrary 实例需要强引用
 实例一个 AssetsLibrary 后，如上面所示，我们可以通过一系列枚举方法获取到需要的相册和资源，并把其储存到数组中，方便用于展示。但是，当我们把这些获取到的相册和资源储存到数组时，实际上只是在数组中储存了这些相册和资源在 AssetsLibrary 中的引用（指针），因而无论把相册和资源储存数组后如何利用这些数据，都首先需要确保 AssetsLibrary 没有被 ARC 释放，否则把数据从数组中取出来时，会发现对应的引用数据已经丢失（参见下图）。这一点较为容易被忽略，因此建议在使用 AssetsLibrary 的 viewController 中，把 AssetsLibrary 作为一个强持有的 property 或私有变量，避免在枚举出 AssetsLibrary 中所需要的数据后，AssetsLibrary 就被 ARC 释放了。
 AssetsLibrary 遵循写入优先原则
 写入优先也就是說，在利用 AssetsLibrary 读取资源的过程中，有任何其它的进程（不一定是同一个 App）在保存资源时，就会收到 ALAssetsLibraryChangedNotification，让用户自行中断读取操作。最常见的就是读取 fullResolutionImage 时，用进程在写入，由于读取 fullResolutionImage 耗时较长，很容易就会 exception。
 开启 Photo Stream 容易导致 exception
 本质上，这跟上面的 AssetsLibrary 遵循写入优先原则是同一个问题。如果用户开启了共享照片流（Photo Stream），共享照片流会以 mstreamd 的方式“偷偷”执行，当有人把相片写入 Camera Roll 时，它就会自动保存到 Photo Stream Album 中，如果用户刚好在读取，那就跟上面说的一样产生 exception 了。由于共享照片流是用户决定是否要开启的，所以开发者无法改变，但是可以通过下面的接口在需要保护的时刻关闭监听共享照片流产生的频繁通知信息。
 [ALAssetsLibrary disableSharedPhotoStreamsSupport];*/
@end
