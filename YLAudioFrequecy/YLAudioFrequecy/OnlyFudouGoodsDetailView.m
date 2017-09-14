//
//  MallGoodDetailView.m
//  ftxmall
//
//  Created by wanthings mac on 16/4/8.
//  Copyright © 2016年 wanthings. All rights reserved.
//

#import "OnlyFudouGoodsDetailView.h"

@interface OnlyFudouGoodsDetailView ()
@property (weak, nonatomic) IBOutlet UILabel *needLayerLabel;

@end

@implementation MallGoodDetailView

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

///显示商品详情
-(void)ShowGoodDetail:(NSMutableDictionary *)dic
{
    self.lab_Name.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    self.lab_Intro.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"intro"]];
    self.lab_Price.text = [NSString stringWithFormat:@"￥%.2f",[[dic objectForKey:@"price"] doubleValue]];
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
    }
    
    
    //是否支持福豆支付
    if ([[dic objectForKey:@"max_fu"] intValue] == 0)
    {
        self.lab_FuDou.text = @"不支持使用福豆";
    }
    else
    {
        self.lab_FuDou.text = [NSString stringWithFormat:@"最多能使用%.2f福豆",[[dic objectForKey:@"max_fu"] doubleValue]];
    }
    
    //是否支持福元支付
    if ([[dic objectForKey:@"max_point"] intValue] == 0)
    {
        self.lab_JiFen.text = @"不支持使用福元";
    }
    else
    {
        self.lab_JiFen.text = [NSString stringWithFormat:@"最多能使用%.2f福元",[[dic objectForKey:@"max_point"] doubleValue]];
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
        [self.jiFenView setHidden:YES];
        self.jiFenViewHeight.constant = 0;
        
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
        [self.jiFenView setHidden:YES];
        self.jiFenViewHeight.constant = 0;
        
        [self.SecondsKillView setHidden:NO];
        self.lab_KillPrice.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"seckill_price"]];
        self.lab_KillOldPrice.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
        self.lab_KillNum.text = [NSString stringWithFormat:@"仅剩%@件",[dic objectForKey:@"surplus_quantity"]];
    }
    else if ([[dic objectForKey:@"goods_type"] intValue] == 3)//团购
    {
        [self.groupBuyView setHidden:NO];
        self.groupViewHeight.constant = 40;
        
        //self.lab_GroupName.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        self.lab_GroupPrice.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
        self.lab_GroupNum.text = [NSString stringWithFormat:@"已售:%@件",[dic objectForKey:@"sales"]];
        
//        self.lab_Price.text = [NSString stringWithFormat:@"￥%.2f",[[dic objectForKey:@"old_price"] doubleValue]];
        self.lab_Price  .text = @"";
//        [self.lab_Price setHidden:YES];
        
        
        self.time = [[dic objectForKey:@"countdown"] doubleValue];
        NSDictionary *dic_Time = [WXFX CountdownTime:self.time];
        int day = [[dic_Time objectForKey:@"hour"] intValue] / 24;
        int hour = [[dic_Time objectForKey:@"hour"] intValue] % 24;
        self.lab_Groupday.text = [NSString stringWithFormat:@"%d",day];
        self.lab_GroupHour.text = [NSString stringWithFormat:@"%d",hour];
        self.lab_GroupMinu.text = [NSString stringWithFormat:@"%@",[dic_Time objectForKey:@"minu"]];
        
        //谈过倒计时
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
            lab.text = [NSString stringWithFormat:@"￥%@",[[arry objectAtIndex:lab.tag] objectForKey:@"price"]];
            
        }
    }
       
    
}


//打开福元公告
- (IBAction)JiFenAd:(UIButton *)sender
{
    self.chooseBtn(4,0);
}
@end
