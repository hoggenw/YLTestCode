//
//  YLBanner.swift
//  Swift
//
//  Created by WLG on 16/9/21.
//  Copyright © 2016年 ios-mac. All rights reserved.
// v0.1.3

import UIKit

public class YLBanner: UIView {
    
    let MAIN_WIDTH = UIScreen.main.bounds.size.width
    public var scrollView: UIScrollView?
    public var currentPageIndex: Int?
    public var animationTimer: Timer?
    fileprivate var pageControl : UIPageControl?
    
    //block
    public var contentViewAtIndex : ((_ pageIndex: Int)->UIImageView)?
    public var tapActionBlock: ((_ pageIndex: Int)-> Void)?
    //private
    private var contentViews : [UIImageView] = []
    fileprivate var animationInterval : TimeInterval?
    private var totalPages :  Int?
    
    private let imageViewArray = [UIImageView(),UIImageView(),UIImageView()]
    
    deinit {
        scrollView?.delegate = nil
        if self.animationTimer != nil {
            self.animationTimer?.invalidate();
            self.animationTimer = nil;
        }
    }
    
    public  init(frame: CGRect ,_ duration: TimeInterval) {
        super.init(frame: frame)
        if duration > 0 {
            animationTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(animationTimerDidFire(timer:)), userInfo: nil, repeats: true)
        }
        animationInterval = duration
        self.clipsToBounds = true
        scrollView = UIScrollView(frame: self.bounds)
        scrollView?.scrollsToTop = true
        scrollView?.isPagingEnabled = true
        scrollView?.delegate = self
        
        scrollView?.contentOffset = CGPoint(x: MAIN_WIDTH, y: 0)
        scrollView?.contentSize = CGSize(width: 3 * MAIN_WIDTH, height: self.bounds.size.height)
        self.addSubview(scrollView!)
        pageControl = UIPageControl(frame: CGRect(x: 0, y: self.bounds.size.height-20, width: MAIN_WIDTH, height: 10))
        pageControl?.isUserInteractionEnabled = false
        self.addSubview(pageControl!)
        let preImageView = self.imageViewArray[0]
        preImageView.backgroundColor = UIColor.colorWithHex(hexRGBValue: 0xf3f4f5)
        
        let currenImageView = self.imageViewArray[1]
        currenImageView.backgroundColor = UIColor.colorWithHex(hexRGBValue: 0xf3f4f5)
        
        let rearImageView = self.imageViewArray[2]
        rearImageView.backgroundColor = UIColor.colorWithHex(hexRGBValue: 0xf3f4f5)
        
        
    }
    //MARK:设置总页数后，启动动画
    
    public  func setTotalPagesCount(totalPageCout: (()->(Int))) {
        self.totalPages = totalPageCout()
        print("totalPages = \(self.totalPages)")
        
        self.pageControl?.numberOfPages = self.totalPages!
        pageControl?.backgroundColor = UIColor.clear
        pageControl?.isUserInteractionEnabled = true
        
        self.currentPageIndex = 0
        if self.totalPages == 1 {
            scrollView?.contentSize = CGSize(width: MAIN_WIDTH, height: self.bounds.size.height)
            configureContentViews()
            self.pageControl?.isHidden = true
            
        }else{
            self.pageControl?.isHidden = false
        }
        if self.totalPages! > 0 && self.totalPages! != 1 {
            configureContentViews()
            self.animationTimer?.resumeTimerAfterInterval(self.animationInterval!)
        }
        
        
    }
    
    fileprivate func configureContentViews() {
        for subView in (self.scrollView?.subviews)! {
            subView.removeFromSuperview()
        }
        setScrollViewDataSource()
        
        for index in 0..<self.contentViews.count {
            var contentView : UIImageView?
            
            contentView = self.contentViews[index]
            contentView?.contentMode = .redraw
            contentView?.frame = CGRect(x: 0, y: 0, width: MAIN_WIDTH, height: self.bounds.size.height)
            
            contentView?.isUserInteractionEnabled = true
            var contenViewFrame = contentView?.frame
            contenViewFrame?.origin = CGPoint(x: CGFloat(MAIN_WIDTH) * CGFloat(index), y: 0)
            contentView?.frame = contenViewFrame!
            contentView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contentViewTapped(sender:))))
            //print("contentView.image = \(contentView?.image)")
            self.scrollView?.addSubview(contentView!)
            
        }
        
        if self.totalPages != 1 {
            self.scrollView?.contentOffset = CGPoint(x: MAIN_WIDTH, y: 0)
        }else {
            self.scrollView?.contentOffset = CGPoint(x: MAIN_WIDTH * 2, y: 0)
        }
        
    }
    
    //点击事件
    func contentViewTapped(sender: UIGestureRecognizer){
        if self.tapActionBlock != nil {
            self.tapActionBlock!(self.currentPageIndex!)
        }
        
    }
    //获取数据
    fileprivate func setScrollViewDataSource () {
        let previousIndex = validateNextPageIndexWithPageIndex(index: self.currentPageIndex! - 1)
        let rearIndex = validateNextPageIndexWithPageIndex(index: self.currentPageIndex! + 1)
        
        self.contentViews.removeAll()
        if self.contentViewAtIndex != nil {
            let preImageView = self.imageViewArray[0]
            preImageView.image = self.contentViewAtIndex!(previousIndex).image
            
            self.contentViews.append(preImageView)
            let currenImageView = self.imageViewArray[1]
            currenImageView.image = self.contentViewAtIndex!(currentPageIndex!).image
            self.contentViews.append(currenImageView)
            let rearImageView = self.imageViewArray[2]
            rearImageView.image = self.contentViewAtIndex!(rearIndex).image
            self.contentViews.append(rearImageView)
        }
        
        
        
        
    }
    //获取下标
    fileprivate func validateNextPageIndexWithPageIndex(index: Int) -> Int {
        
        if index < 0 {
            return self.totalPages! - 1;
        }else if index >= self.totalPages!{
            return 0
        }
        return index
        
    }
    
    @objc fileprivate func animationTimerDidFire(timer:Timer){
        let index = Int((self.scrollView?.contentOffset.x)!/MAIN_WIDTH)
        self.scrollView?.setContentOffset(CGPoint(x: MAIN_WIDTH * CGFloat(index)+MAIN_WIDTH, y: 0),animated: true)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YLBanner: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.animationTimer?.pauseTimer()
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.animationTimer?.resumeTimerAfterInterval(self.animationInterval!)
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (MAIN_WIDTH * CGFloat(2)) {
            self.currentPageIndex = validateNextPageIndexWithPageIndex(index:  self.currentPageIndex!+1)
            configureContentViews()
        }else if scrollView.contentOffset.x <= 0 {
            self.currentPageIndex = validateNextPageIndexWithPageIndex(index:  self.currentPageIndex!-1)
            configureContentViews()
        }
        
        self.pageControl?.currentPage = self.currentPageIndex!
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: MAIN_WIDTH, y: 0), animated: true)
    }
    
    
}
