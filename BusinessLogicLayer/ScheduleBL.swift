//
//  ScheduleBL.swift
//  RioOlympics2016
//
//  Created by tonymacmini on 14/11/6.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
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
