//
//  AboutViewController.swift
//  RioOlympics2016
//
//  Created by tonymacmini on 14/11/5.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController,GADBannerViewDelegate {

    var adBannerView: GADBannerView!
    
    let AdUnitID = "ca-app-pub-1990684556219793/1962464393"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createBannerView(kGADAdSizeSmartBannerPortrait)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createBannerView(size: GADAdSize) {
        if self.adBannerView != nil {
            self.adBannerView.delegate = nil
            self.adBannerView.removeFromSuperview()
        }
        self.adBannerView = GADBannerView(adSize: size)
        self.adBannerView.adUnitID = AdUnitID
        self.adBannerView.delegate = self
        self.adBannerView.rootViewController = self
        self.view.addSubview(self.adBannerView)
        self.adBannerView.loadRequest(self.request())
    }
    
    //MARK: --屏幕旋转
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        println("height =\(size.height), width =\(size.width)")
        
        if size.height < size.width { //横屏
            self.createBannerView(kGADAdSizeSmartBannerLandscape)
        } else {
            self.createBannerView(kGADAdSizeSmartBannerPortrait)
        }
        
    }
    
    //MARK: --GADRequest方法
    func request()-> GADRequest {
        
        var request: GADRequest = GADRequest()
        
        request.testDevices = NSArray(array: ["7740674c81cf31a50d2f92bcdb729f10", GAD_SIMULATOR_ID])
        
        return request
    }
    
    //MARK: --GADBannerViewDelegate方法
    func adViewDidReceiveAd(view: GADBannerView!) {
        NSLog("广告加载成功")
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        NSLog("广告加载失败")
    }

}
