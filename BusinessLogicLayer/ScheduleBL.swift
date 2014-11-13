//
//  ScheduleBL.swift
//  RioOlympics2016
//
//  Created by 关东升 on 2014-5-18.
//  本书网站：http://www.cocoagame.net
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  QQ：1575716557 邮箱：jylong06@163.com
//  QQ交流群：389037167/327403678
//


import Foundation

class ScheduleBL: NSObject {
    
    //查询所用数据方法
    func readData() -> NSMutableDictionary {
        
        var scheduleDAO = ScheduleDAO.sharedInstance
        var schedules  = scheduleDAO.findAll()
        var resDict = NSMutableDictionary()
        
        var eventsDAO = EventsDAO.sharedInstance
        
        //延迟加载Events数据
        for item in schedules {
            
            var schedule = item as Schedule
            
            var event = eventsDAO.findById(schedule.Event!)
            schedule.Event = event
            
            let allkey = resDict.allKeys as NSArray
            
            //把NSMutableArray结构转化为NSMutableDictionary结构
            if allkey.containsObject(schedule.GameDate!) {
                var value = resDict.objectForKey(schedule.GameDate!) as NSMutableArray
                value.addObject(schedule)
            } else {
                var value = NSMutableArray()
                value.addObject(schedule)
                resDict.setObject(value, forKey:schedule.GameDate!)
            }
        }
        return resDict
    }
}
