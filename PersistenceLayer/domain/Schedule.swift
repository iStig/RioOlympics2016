//
//  Schedule.swift
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
