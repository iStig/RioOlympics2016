//
//  EventsDetailViewController.swift
//  RioOlympics2016
//
//  Created by tonymacmini on 14/11/5.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

import UIKit

class EventsDetailViewController: UIViewController {
    
    var event: Events!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgEventIcon: UIImageView!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var txtViewKeyInfo: UITextView!
    @IBOutlet weak var txtViewBasicsInfo: UITextView!
    @IBOutlet weak var txtViewOlympicInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgEventIcon.image = UIImage(named:self.event.EventIcon!)
        
        self.lblEventName.text = self.event.EventName!
        self.txtViewBasicsInfo.text = self.event.BasicsInfo!
        self.txtViewKeyInfo.text = self.event.KeyInfo!
        self.txtViewOlympicInfo.text = self.event.OlympicInfo!
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
