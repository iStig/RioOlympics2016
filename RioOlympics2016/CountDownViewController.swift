//
//  CountDownViewController.swift
//  RioOlympics2016
//
//  Created by tonymacmini on 14/11/5.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

import UIKit

class CountDownViewController: UIViewController {
    
    //显示倒计时
    @IBOutlet weak var lblCountDown: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //创建NSDateComponents对象
        let comps = NSDateComponents()
        //设置NSDateComponents日期
        comps.day = 5
        //设置NSDateComponents月
        comps.month = 8
        //设置NSDateComponents年
        comps.year = 2016
        
        //创建日历对象
        let calender = NSCalendar(calendarIdentifier:NSGregorianCalendar)
        
        //获得2016-8-5日的NSDate日期对象
        let destinationDate = calender!.dateFromComponents(comps)
        
        let date:NSDate = NSDate()
        
        //获得当前日期到2016-8-5时间的NSDateComponents对象
        let components = calender!.components(NSCalendarUnit.DayCalendarUnit, fromDate: date , toDate:destinationDate!, options:nil)
      
        //获得当前日期到2016-8-5相差的天数
        let days = components.day
        
        let strLabel = NSString(format:"%i天", days)
        
        self.lblCountDown.text = strLabel
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
