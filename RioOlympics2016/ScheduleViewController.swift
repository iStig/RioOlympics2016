//
//  ScheduleViewController.swift
//  RioOlympics2016
//
//  Created by tonymacmini on 14/11/5.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

import UIKit

class ScheduleViewController: UITableViewController {

    //表视图使用的数据
    var data: NSDictionary!
    //比赛日期列表
    var arrayGameDateList: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  self.data == nil || self.data.count == 0 {
            
            let bl = ScheduleBL()
            self.data = bl.readData()
            
            let keys = self.data.allKeys as NSArray
            //对key进行排序
            self.arrayGameDateList = keys.sortedArrayUsingSelector("compare:") as NSArray
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        let keys = self.data.allKeys as NSArray
        return keys.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //比赛日期
        let strGameDate = self.arrayGameDateList.objectAtIndex(section) as NSString
        //比赛日期下的比赛日程表
        let schedules = self.data.objectForKey(strGameDate) as NSArray
        return schedules.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //比赛日期
        let strGameDate = self.arrayGameDateList.objectAtIndex(section) as NSString
        return strGameDate
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        //比赛日期
        let strGameDate = self.arrayGameDateList.objectAtIndex(indexPath.section) as NSString
        //比赛日期下的比赛日程表
        let schedules = self.data.objectForKey(strGameDate) as NSArray
        let schedule = schedules.objectAtIndex(indexPath.row) as Schedule
        
        let subtitle = NSString(format: "%@ | %@", schedule.GameInfo!, schedule.Event!.EventName!)
        
        cell.textLabel.text = schedule.GameTime
        cell.detailTextLabel?.text = subtitle

        return cell
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        
        var listTitles = NSMutableArray()
        // 2016-08-09 -> 08-09
        for item in self.arrayGameDateList {
            let title = (item as NSString).substringFromIndex(5)
            listTitles.addObject(title)
        }
        return listTitles
    }

}
