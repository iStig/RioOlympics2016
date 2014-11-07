//
//  Schedule.swift
//  RioOlympics2016
//
//  Created by tonymacmini on 14/11/6.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

import Foundation

// 比赛日程表 实体类
class Schedule: NSObject {

    //编号
    var ScheduleID: Int?
    //比赛日期
    var GameDate : NSString?
    //比赛时间
    var GameTime : NSString?
    //比赛描述
    var GameInfo : NSString?
    //比赛项目
    var Event : Events?
    
}
