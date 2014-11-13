//
//  ScheduleBLTests.swift
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
import XCTest

class ScheduleBLTests: XCTestCase {
    
    var bl:ScheduleBL!
    var theSchedule: Schedule!
    
    override func setUp() {
        super.setUp()
        //创建ScheduleBL对象
        self.bl = ScheduleBL()
        //创建Schedule对象
        self.theSchedule = Schedule()
        self.theSchedule.GameDate = "test GameDate"
        self.theSchedule.GameTime = "test GameTime"
        self.theSchedule.GameInfo = "test GameInfo"
        
        let event = Events()
        event.EventName = "Cycling Mountain Bike"
        event.EventID = 10
        self.theSchedule.Event = event
        
        //插入测试数据
        let dao = ScheduleDAO.sharedInstance
        dao.create(self.theSchedule)
    }
    
    override func tearDown() {
        //删除测试数据
        self.theSchedule.ScheduleID = 502
        let dao = ScheduleDAO.sharedInstance
        dao.remove(self.theSchedule)
        
        super.tearDown()
    }
    
    //测试 按照主键查询数据方法
    func testFindAll() {
        
        let dict: NSMutableDictionary = self.bl.readData()
        
        let allkey: NSArray =  dict.allKeys
        
        //断言 查询记录数为1
        XCTAssertEqual(allkey.count, 18)
        
        let schedules: NSArray = dict.objectForKey(self.theSchedule.GameDate!) as NSArray
        
        let resSchedule: Schedule = schedules[0] as Schedule
        //断言
        XCTAssertEqual(self.theSchedule.GameDate!, resSchedule.GameDate!)
        XCTAssertEqual(self.theSchedule.GameTime!, resSchedule.GameTime!)
        XCTAssertEqual(self.theSchedule.GameInfo!, resSchedule.GameInfo!)
        XCTAssertEqual(self.theSchedule.Event!.EventID!, resSchedule.Event!.EventID!)
        XCTAssertEqual(self.theSchedule.Event!.EventName!, resSchedule.Event!.EventName!)
        
    }
    
    
}
