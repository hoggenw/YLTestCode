//
//  MallGoodDetailView.m
//  ftxmall
//
//  Created by wanthings mac on 16/4/8.
//  Copyright © 2016年 wanthings. All rights reserved.
//

#import "SimpleMallGoodsDetailView.h"
#import "WXFX.h"
#import "DetailPayTypeModel.h"

@interface SimpleMallGoodsDetailView ()
@property (weak, nonatomic) IBOutlet UILabel *needLayerLabel;
@property (weak, nonatomic) IBOutlet UIButton *payTypeFuAndCash;
@property (weak, nonatomic) IBOutlet UIButton *payTypeCash;
@property (weak, nonatomic) IBOutlet UIButton *payTypeFuyuan;
@property (weak, nonatomic) IBOutlet UIButton *payTypeFuyuanAndFudou;

@property (nonatomic, strong) NSDictionary * detailDictionary;
@property (nonatomic, strong) NSDictionary * payTypeDic;
@property (nonatomic, assign) NSInteger stocks;


@end

@implementation SimpleMallGoodsDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib
{
    
    [super awakeFromNib];
    
    
    for (UILabel *lab in self.lab_Lines)
    {
        lab.layer.borderColor = [WXFX HexStringToColor:@"d9d9d9"].CGColor;
        lab.layer.borderWidth = 0.5;
    }
    
    self.needLayerLabel.layer.borderColor =[WXFX HexStringToColor:@"d9d9d9"].CGColor;
     self.needLayerLabel.layer.borderWidth = 0.5;
    
    self.btn_KeFu.layer.borderColor = [WXFX HexStringToColor:@"d9d9d9"].CGColor;
    self.btn_KeFu.layer.cornerRadius = 5;
    self.btn_Shop.layer.borderColor = [WXFX HexStringToColor:@"d9d9d9"].CGColor;
    self.btn_Shop.layer.cornerRadius = 5;
    
    //self.lab_HaveNum.layer.borderColor = [UIColor clearColor].CGColor;
    self.lab_AmountPeople.layer.borderColor = [WXFX HexStringToColor:@"ffb300"].CGColor;
    
    self.payTypeFuAndCash.layer.borderWidth = 1;
    self.payTypeCash.layer.borderWidth = 1;
    self.payTypeFuyuan.layer.borderWidth = 1;
    self.payTypeFuyuanAndFudou.layer.borderWidth = 1;
    
    self.payTypeFuAndCash.layer.cornerRadius = 2;
    self.payTypeCash.layer.cornerRadius = 2;
    self.payTypeFuyuan.layer.cornerRadius = 2;
    self.payTypeFuyuanAndFudou.layer.cornerRadius = 2;
    
    self.payTypeFuAndCash.clipsToBounds = true;
    self.payTypeCash.clipsToBounds = true;
    self.payTypeFuyuan.clipsToBounds = true;
    self.payTypeFuyuanAndFudou.clipsToBounds = true;
    
    [self.payTypeFuAndCash setBackgroundImage: [WXFX imageWithColor:  [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]] forState: UIControlStateDisabled];
    [self.payTypeCash setBackgroundImage: [WXFX imageWithColor:  [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]] forState: UIControlStateDisabled];
    [self.payTypeFuyuan setBackgroundImage: [WXFX imageWithColor: [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]] forState: UIControlStateDisabled];
     [self.payTypeFuyuanAndFudou setBackgroundImage: [WXFX imageWithColor: [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]] forState: UIControlStateDisabled];

    
    self.img_head.layer.cornerRadius = self.img_head.frame.size.height/2;
    self.img_head.layer.masksToBounds = YES;
    [self.img_head setContentMode:UIViewContentModeScaleAspectFill];
    [self.img_head setClipsToBounds:YES];
    self.img_head.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.img_head.layer.shadowOffset = CGSizeMake(4.0, 4.0);
    self.img_head.layer.shadowOpacity = 0.5;
    self.img_head.layer.shadowRadius = 2.0;
    self.img_head.layer.borderColor = [UIColor whiteColor].CGColor;
    self.img_head.layer.borderWidth = 1.0f;
    self.img_head.userInteractionEnabled = YES;
    [self.lab_KillPrice setAdjustsFontSizeToFitWidth: true];

    
}


-(void)setPayType:(NSInteger)payType {
    [self payTypeChioceNone];
    _payType = payType;
    if(payType == 1){//现金加积分
        
        self.payTypeFuyuan.layer.borderColor = [UIColor redColor].CGColor;
        
        DetailPayTypeModel *cashModel = [DetailPayTypeModel yy_modelWithDictionary: [self.payTypeDic objectForKey:@"cash_point_price"][@"cash"] ];
        DetailPayTypeModel *sccModel = [DetailPayTypeModel yy_modelWithDictionary: [self.payTypeDic objectForKey:@"cash_point_price"][@"point"] ];
        self.lab_Price.text = [NSString stringWithFormat:@"%@%.2f+%@%.2f",cashModel.symbol,[cashModel.amount doubleValue],sccModel.symbol,[sccModel.amount doubleValue]];
        
      
        
    }else if (payType == 2){//现金加SCC
        self.payTypeFuAndCash.layer.borderColor = [UIColor redColor].CGColor;
        DetailPayTypeModel *cashModel = [DetailPayTypeModel yy_modelWithDictionary: [self.payTypeDic objectForKey:@"cash_dc_price"][@"cash"] ];
        DetailPayTypeModel *sccModel = [DetailPayTypeModel yy_modelWithDictionary: [self.payTypeDic objectForKey:@"cash_dc_price"][@"dc"] ];
        self.lab_Price.text = [NSString stringWithFormat:@"%@%.2f+%@%.2f",cashModel.symbol,[cashModel.amount doubleValue],sccModel.symbol,[sccModel.amount doubleValue]];
        
    }else if (payType == 3) {//全现金
         self.payTypeCash.layer.borderColor = [UIColor redColor].CGColor;
        
        DetailPayTypeModel *cashModel = [DetailPayTypeModel yy_modelWithDictionary: [self.payTypeDic objectForKey:@"cash_price"][@"cash"] ];
        self.lab_Price.text = [NSString stringWithFormat:@"%@%.2f",cashModel.symbol,[cashModel.amount doubleValue]];
    }else if (payType == 4) {//SCC加积分
        self.payTypeFuyuanAndFudou.layer.borderColor = [UIColor redColor].CGColor;
        DetailPayTypeModel *cashModel = [DetailPayTypeModel yy_modelWithDictionary: [self.payTypeDic objectForKey:@"dc_point_price"][@"dc"] ];
        DetailPayTypeModel *sccModel = [DetailPayTypeModel yy_modelWithDictionary: [self.payTypeDic objectForKey:@"dc_point_price"][@"point"] ];
        self.lab_Price.text = [NSString stringWithFormat:@"%@%.2f+%@%.2f",cashModel.symbol,[cashModel.amount doubleValue],sccModel.symbol,[sccModel.amount doubleValue]];
    }
    self.lab_KillPrice.text = self.lab_Price.text;
    self.lab_GroupPrice.text =  self.lab_Price.text;
    if ([[_detailDictionary objectForKey:@"goods_type"] intValue] == 3) {
        self.lab_Price.text = @"";
    }
    if ([self.delegate respondsToSelector:@selector(chiocePriceTypeChanged:)]) {
        [self.delegate chiocePriceTypeChanged: self.lab_Price.text];
    }
}

- (void)payTypeChioceNone {
    
    self.payTypeFuAndCash.layer.borderColor = [UIColor blackColor].CGColor;
    self.payTypeCash.layer.borderColor = [UIColor blackColor].CGColor;
    self.payTypeFuyuan.layer.borderColor = [UIColor blackColor].CGColor;
    self.payTypeFuyuanAndFudou.layer.borderColor = [UIColor blackColor].CGColor;
}


////View被单击事件
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //DLog(@"----------++++++++++++++++---");
//}


- (IBAction)AddCart:(UIButton *)sender
{
    self.chooseBtn(0,(int)sender.tag);
}

- (IBAction)GoComment:(UIButton *)sender
{
    self.chooseBtn(1,(int)sender.tag);
}

- (IBAction)KeFuAndGoShop:(UIButton *)sender
{
    self.chooseBtn(2,(int)sender.tag);
}

- (IBAction)GoGoods:(UIButton *)sender
{
    self.chooseBtn(3,(int)sender.tag);
}



///显示商品详情const
//PAY_ASSEMBLE_CASH_POINT = 1;  //法币+积分
//const PAY_ASSEMBLE_CASH_DC    = 2;  //法币+数字货币
//const PAY_ASSEMBLE_CASH_ONLY  = 3;  //法币
//const PAY_ASSEMBLE_DC_POINT   = 4;  //数字货币+积分
//const PAY_ASSEMBLE_COURSE_COUPON = 5;  //培训课程优惠券
-(void)ShowGoodDetail:(NSMutableDictionary *)dic
{
    self.detailDictionary = dic;
    NSLog(@"显示商品信息 %@ ===",dic[@"price_arr"]);
    self.payTypeDic = dic[@"price_arr"];
    self.lab_Name.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    self.lab_Intro.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"intro"]];
   
//   NSDictionary *cash_dc_price = self.
    
    if ([[self.payTypeDic objectForKey:@"cash_dc_price"][@"cash"][@"amount"] doubleValue] > 0 || [[self.payTypeDic objectForKey:@"cash_dc_price"][@"dc"][@"amount"] doubleValue] > 0) {//现金加SCC
        //NSLog(@"显示商品信息 可用");
        [self.payTypeFuAndCash setEnabled: true];
        
    }else{
        [self.payTypeFuAndCash setHidden: true];
        self.payTypeFuAndCash.frame = CGRectMake(-15, 0, 0, 0);
        [self.payTypeFuAndCash setEnabled: false];
    }
    
    if ([[self.payTypeDic objectForKey:@"cash_point_price"][@"cash"][@"amount"] doubleValue] > 0 || [[self.payTypeDic objectForKey:@"cash_point_price"][@"dc"][@"amount"] doubleValue] > 0) {//现金加积分
        [self.payTypeFuyuan setEnabled: true];
        
    }else{
        [self.payTypeFuyuan setHidden: true];
        self.payTypeFuyuan.frame = CGRectMake(-15, 0, 0, 0);
        [self.payTypeFuyuan setEnabled: false];
    }
    
    if ([[self.payTypeDic objectForKey:@"cash_price"][@"cash"][@"amount"] doubleValue] > 0 ) {//全现金
        [self.payTypeCash setEnabled: true];
        
    }else{
        [self.payTypeCash setHidden: true];
        self.payTypeCash.frame = CGRectMake(-15, 0, 0, 0);
        [self.payTypeCash setEnabled: false];
    }
    
    if ([[self.payTypeDic objectForKey:@"dc_point_price"][@"cash"][@"amount"] doubleValue] > 0 || [[self.payTypeDic objectForKey:@"dc_point_price"][@"dc"][@"amount"] doubleValue] > 0) {//SCC加积分
        [self.payTypeFuyuanAndFudou setEnabled: true];
    }else{
        [self.payTypeFuyuanAndFudou setHidden: true];
        self.payTypeFuyuanAndFudou.frame = CGRectMake(-15, 0, 0, 0);
        [self.payTypeFuyuanAndFudou setEnabled: false];
    }
    
    //PAY_ASSEMBLE_CASH_POINT = 1;  //法币+积分
    //const PAY_ASSEMBLE_CASH_DC    = 2;  //法币+数字货币
    //const PAY_ASSEMBLE_CASH_ONLY  = 3;  //法币
    //const PAY_ASSEMBLE_DC_POINT   = 4;  //数字货币+积分
    //const PAY_ASSEMBLE_COURSE_COUPON = 5;  //培训课程优惠券

    if (self.payTypeFuAndCash.isEnabled) {//现金加SCC 500
        self.payType = 2;
    }else if(self.payTypeFuyuan.isEnabled) {//现金加积分 502
        self.payType = 1;
    }else if(self.payTypeCash.isEnabled) {//全现金 501
        self.payType = 3;
    }else if (self.payTypeFuyuanAndFudou.isEnabled){//SCC加积分 503
        self.payType = 4;
    }
    
    self.lab_OldPrice.text = [NSString stringWithFormat:@"￥%.2f",[[dic objectForKey:@"old_price"] doubleValue]];
    [self.lab_OldPriceLab setHidden:NO];
    
    
    
    NSString *ship_fee = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ship_fee"]];
    if ([ship_fee intValue] == 0)//包邮
    {
        [self.lab_FreeShipment setHidden:NO];
        [self.lab_Shipment setHidden:YES];
        [self.lab_ShipmentMoney setHidden:YES];
    }
    else
    {
        self.lab_ShipmentMoney.text = ship_fee;
    }
    
    if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"sales_str"]].length > 0)
    {
        [self.lab_FreeShipment setHidden:NO];
        [self.lab_FreeShipment setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"sales_str"]]];
        [self.lab_Shipment setHidden: NO];
        [self.lab_ShipmentMoney setHidden: NO];
         self.lab_ShipmentMoney.text = ship_fee;
    }
    
    self.lab_Stock.text = [NSString stringWithFormat:@"库存:%@件",[dic objectForKey:@"stocks"]];

    
    
    if ([[dic objectForKey:@"attr"] count] == 1)
    {
        self.lab_Attrs.text = [NSString stringWithFormat:@"选择  %@",[[[dic objectForKey:@"attr"] objectAtIndex:0]objectForKey:@"key"]];
    }
    else if ([[dic objectForKey:@"attr"] count] == 2)
    {
        self.lab_Attrs.text = [NSString stringWithFormat:@"选择  %@  %@",[[[dic objectForKey:@"attr"] objectAtIndex:0]objectForKey:@"key"],[[[dic objectForKey:@"attr"] objectAtIndex:1]objectForKey:@"key"]];
    }

    
    self.lab_Comment.text = [NSString stringWithFormat:@"评论(%@)",[dic objectForKey:@"comment_count"]];
    
    self.lab_ShopName.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_name"]];
    //self.lab_GoodsAmount.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_goods_count"]];
    self.lab_PayAmount.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sales"]];
    
    
    //是抢购还是秒杀
    if ([[dic objectForKey:@"goods_type"] intValue] == 1)//抢购
    {
//        [self.jiFenView setHidden:YES];
//        self.jiFenViewHeight.constant = 0;
        
        self.lab_Price.text = @"￥1.00";
        [self.PanicBuyingView setHidden:NO];
        self.PaniceViewHeight.constant = 50;//90
        
        self.lab_PanicAmount.text = [NSString stringWithFormat:@"总需%@人次参与",[dic objectForKey:@"max_quantity"]];
        self.lab_AmountPeople.text = [NSString stringWithFormat:@"   %@人次参与",[dic objectForKey:@"sale_quantity"]];
        self.lab_PanicSurplusNum.text = [NSString stringWithFormat:@"余%@人次",[dic objectForKey:@"surplus_quantity"]];
        
        float width = 0;
        if ([[dic objectForKey:@"max_quantity"] floatValue] > 0)
        {
            width = [[dic objectForKey:@"sale_quantity"] floatValue] / [[dic objectForKey:@"max_quantity"] floatValue];
        }
        if (width > 1)
        {
            width = 1;
        }
        self.haveNumWidth.constant = width * 200;
    }
    else if ([[dic objectForKey:@"goods_type"] intValue] == 2)//秒杀
    {
//        [self.jiFenView setHidden:YES];
//        self.jiFenViewHeight.constant = 0;
        
        [self.SecondsKillView setHidden:NO];
        self.lab_KillPrice.text = self.lab_Price.text;//[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"seckill_price"]];
        self.lab_KillOldPrice.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"old_price"]];
        self.lab_KillNum.text = [NSString stringWithFormat:@"仅剩%@件",[dic objectForKey:@"surplus_quantity"]];
    }
    else if ([[dic objectForKey:@"goods_type"] intValue] == 3)//团购
    {
        [self.groupBuyView setHidden:NO];
        self.groupViewHeight.constant = 40;
        self.lab_GroupPrice.adjustsFontSizeToFitWidth = true;
        self.lab_GroupNum.adjustsFontSizeToFitWidth = true;
        //self.lab_GroupName.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        //self.lab_GroupPrice.text =  self.lab_Price.text;//[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
        self.lab_GroupNum.text = [NSString stringWithFormat:@"已售:%@件",[dic objectForKey:@"sales"]];
        
//        self.lab_Price.text = [NSString stringWithFormat:@"￥%.2f",[[dic objectForKey:@"old_price"] doubleValue]];
          self.lab_Price.text = @"";
        [self.lab_Price setHidden:YES];
        
        
        self.time = [[dic objectForKey:@"countdown"] doubleValue];
        NSDictionary *dic_Time = [WXFX CountdownTime:self.time];
        int day = [[dic_Time objectForKey:@"hour"] intValue] / 24;
        int hour = [[dic_Time objectForKey:@"hour"] intValue] % 24;
        self.lab_Groupday.text = [NSString stringWithFormat:@"%d",day];
        self.lab_GroupHour.text = [NSString stringWithFormat:@"%d",hour];
        self.lab_GroupMinu.text = [NSString stringWithFormat:@"%@",[dic_Time objectForKey:@"minu"]];
        
        //团购倒计时
        self.Timer = [NSTimer timerWithTimeInterval:60.0 target:self selector:@selector(Countdown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.Timer forMode:NSRunLoopCommonModes];
    }
    
    
    
    
    
    
    
    
    
    
}

//倒计时
-(void)Countdown
{
    if (self.time == 0)
    {
        [self.Timer invalidate];
        self.Timer = nil;
    }
    else
    {
        self.time -= 60;
        NSDictionary *dic_Time = [WXFX CountdownTime:self.time];
        int day = [[dic_Time objectForKey:@"hour"] intValue] / 24;
        int hour = [[dic_Time objectForKey:@"hour"] intValue] % 24;
        self.lab_Groupday.text = [NSString stringWithFormat:@"%d",day];
        self.lab_GroupHour.text = [NSString stringWithFormat:@"%d",hour];
        self.lab_GroupMinu.text = [NSString stringWithFormat:@"%@",[dic_Time objectForKey:@"minu"]];
    }
    
    //DLog(@"---------------%d------------------",time);
    
}













///显示评论信息
-(void)ShowComment:(NSMutableDictionary *)dic
{
    [self.commentView setHidden:NO];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"user_avatar"]]];
    [self.img_head sd_setImageWithURL:url];
    
    self.lab_CommentCon.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
}
///显示相关商品
-(void)ShowAboutGoods:(NSMutableArray *)arry
{
    for (UIView *views in self.aboutGoodsView)
    {
        if (views.tag < arry.count)
        {
            [views setHidden:NO];

        }
    }
    
    for (UIImageView *img in self.img_Goods)
    {
        if (img.tag < arry.count)
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arry objectAtIndex:img.tag] objectForKey:@"cover"]]];
            [img sd_setImageWithURL:url];
            
        }
    }
    
    for (UILabel *lab in self.lab_GoodsName)
    {
        if (lab.tag < arry.count)
        {
            lab.text = [NSString stringWithFormat:@"%@",[[arry objectAtIndex:lab.tag] objectForKey:@"name"]];
            
        }
    }
    
    for (UILabel *lab in self.lab_GoodsPrice)
    {
        if (lab.tag < arry.count)
        {
            NSDictionary *dic = [arry objectAtIndex:lab.tag];
            if ([[dic objectForKey:@"price_without_fu"] floatValue] > 0) {
                 lab.text = [@"￥" stringByAppendingFormat:@"%@",[dic objectForKey:@"price_without_fu"]];
                
            }else{
                 lab.text = [@"￥" stringByAppendingFormat:@"%@",[dic objectForKey:@"price"]];
            }
           // lab.text = [NSString stringWithFormat:@"￥%@",[ objectForKey:@"price"]];
            
        }
    }
       
    
}
- (IBAction)chiocePayType:(UIButton *)sender {
    if (sender.tag == 500) {
        self.payType = 2;
    }else if (sender.tag == 501){ //全现金
        self.payType = 3;
    }else if (sender.tag == 502){ // 全福元
        self.payType = 1;
    }
    else if (sender.tag == 503){ // 全福元
        self.payType = 4;
    }
}



//打开福元公告
- (IBAction)JiFenAd:(UIButton *)sender
{
    self.chooseBtn(4,0);
}
- (IBAction)payTypeFuyuanAndFuDou:(id)sender {
}
@end
