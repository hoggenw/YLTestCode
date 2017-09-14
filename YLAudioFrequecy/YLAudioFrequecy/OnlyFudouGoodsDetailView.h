//
//  MallGoodDetailView.h
//  ftxmall
//
//  Created by wanthings mac on 16/4/8.
//  Copyright © 2016年 wanthings. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChooseBtn)(int type,int tag);

@interface OnlyFudouGoodsDetailView : UIView
@property (copy, nonatomic)ChooseBtn chooseBtn;//typedef void(^ChooseBtn)(int type,int tag);

@property (weak, nonatomic) IBOutlet UILabel *lab_Name;
@property (weak, nonatomic) IBOutlet UILabel *lab_Intro;
@property (weak, nonatomic) IBOutlet UILabel *lab_Price;
@property (weak, nonatomic) IBOutlet UILabel *lab_OldPrice;
@property (weak, nonatomic) IBOutlet UILabel *lab_OldPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *lab_Shipment;
@property (weak, nonatomic) IBOutlet UILabel *lab_ShipmentMoney;

///团购View
@property (weak, nonatomic) IBOutlet UIView *groupBuyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupViewHeight;
//@property (weak, nonatomic) IBOutlet UILabel *lab_GroupName;
@property (weak, nonatomic) IBOutlet UILabel *lab_GroupPrice;
@property (weak, nonatomic) IBOutlet UILabel *lab_GroupNum;
@property (weak, nonatomic) IBOutlet UILabel *lab_Groupday;
@property (weak, nonatomic) IBOutlet UILabel *lab_GroupHour;
@property (weak, nonatomic) IBOutlet UILabel *lab_GroupMinu;

@property (strong, nonatomic)NSTimer *Timer;//计时器
@property (assign, nonatomic)double time;//还剩秒数



///秒杀View
@property (weak, nonatomic) IBOutlet UIView *SecondsKillView;
@property (weak, nonatomic) IBOutlet UILabel *lab_KillPrice;
@property (weak, nonatomic) IBOutlet UILabel *lab_KillOldPrice;
@property (weak, nonatomic) IBOutlet UILabel *lab_KillNum;

///一元抢购View
@property (weak, nonatomic) IBOutlet UIView *PanicBuyingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PaniceViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *lab_PanicAmount;
@property (weak, nonatomic) IBOutlet UILabel *lab_PanicSurplusNum;
@property (weak, nonatomic) IBOutlet UILabel *lab_AmountPeople;
@property (weak, nonatomic) IBOutlet UILabel *lab_HaveNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *haveNumWidth;


@property (weak, nonatomic) IBOutlet UILabel *lab_FuDou;
@property (weak, nonatomic) IBOutlet UILabel *lab_JiFen;


@property (weak, nonatomic) IBOutlet UIView *jiFenView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiFenViewHeight;

//@property (weak, nonatomic) IBOutlet UIView *fudouView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fudouWidth;
//@property (weak, nonatomic) IBOutlet UIView *jifenView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jifenWidth;
@property (weak, nonatomic) IBOutlet UILabel *lab_FreeShipment;
///库存
@property (weak, nonatomic) IBOutlet UILabel *lab_Stock;

///属性
@property (weak, nonatomic) IBOutlet UILabel *lab_Attrs;

///评论数
@property (weak, nonatomic) IBOutlet UILabel *lab_Comment;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIImageView *img_head;
@property (weak, nonatomic) IBOutlet UILabel *lab_CommentCon;


///店铺名称
@property (weak, nonatomic) IBOutlet UILabel *lab_ShopName;
@property (weak, nonatomic) IBOutlet UILabel *lab_GoodsAmount;
@property (weak, nonatomic) IBOutlet UILabel *lab_PayAmount;
@property (weak, nonatomic) IBOutlet UIButton *btn_KeFu;
@property (weak, nonatomic) IBOutlet UIButton *btn_Shop;

///选择属性
@property (weak, nonatomic) IBOutlet UIButton *btn_ChooseAttr;


//分享可得的提示
@property (weak, nonatomic) IBOutlet UIView *shareHintView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choiceViewTop;
@property (weak, nonatomic) IBOutlet UILabel *shareHintViewLabel;

///相关商品view
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *aboutGoodsView;
///相关商品图片
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *img_Goods;
///相关商品价格
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lab_GoodsPrice;
///相关商品名称
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lab_GoodsName;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lab_Lines;

///福元公告
- (IBAction)JiFenAd:(UIButton *)sender;

///选择属性
- (IBAction)AddCart:(UIButton *)sender;
///跳转到评论列表
- (IBAction)GoComment:(UIButton *)sender;
///联系客服和进入店铺
- (IBAction)KeFuAndGoShop:(UIButton *)sender;

///跳转商品详情
- (IBAction)GoGoods:(UIButton *)sender;



///显示商品详情
-(void)ShowGoodDetail:(NSMutableDictionary *)dic;
///显示评论信息
-(void)ShowComment:(NSMutableDictionary *)dic;
///显示相关商品
-(void)ShowAboutGoods:(NSMutableArray *)arry;

@end
