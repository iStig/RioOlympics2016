//
//  ScheduleDAOTests.swift
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

class ScheduleDAOTests: XCTestCase {
    
    var dao: ScheduleDAO!
    var theSchedule: Schedule!
    
    override func setUp() {
        super.setUp()
        //创建ScheduleDAO对象
        self.dao = ScheduleDAO.sharedInstance
        //创建Schedule对象
        self.theSchedule = Schedule()
        self.theSchedule.GameDate = "test GameDate"
        self.theSchedule.GameTime = "test GameTime"
        self.theSchedule.GameInfo = "test GameInfo"
        var event = Events()
        event.EventID = 1
        self.theSchedule.Event = event
    }
    
    override func tearDown() {
        self.dao = nil
        super.tearDown()
    }
    
    //测试 插入Schedule方法
    func test_1_Create() {
        let res = self.dao.create(self.theSchedule)
        //断言 无异常，返回值为0，
        XCTAssert(res == 0)
    }
    
    //测试 按照主键查询数据方法
    func test_2_FindById() {
        
        self.theSchedule.ScheduleID = 502
        let resSchedule = self.dao.findById(self.theSchedule)
        
        //断言 查询结果非nil
        XCTAssertNotNil(resSchedule)
        //断言
        XCTAssertEqual(self.theSchedule!.GameDate!, resSchedule!.GameDate!)
        XCTAssertEqual(self.theSchedule!.GameTime!, resSchedule!.GameTime!)
        XCTAssertEqual(self.theSchedule!.GameInfo!, resSchedule!.GameInfo!)
        XCTAssertEqual(self.theSchedule!.Event!.EventID!, resSchedule!.Event!.EventID!)
    }
    
    //测试 查询所有数据方法
    func test_3_FindAll() {
        let list =  self.dao.findAll()
        //断言 查询记录数为1
        XCTAssert(list.count == 502)
        
        let resSchedule:Schedule = list[501] as Schedule
        //断言
        XCTAssertEqual(self.theSchedule!.GameDate!, resSchedule.GameDate!)
        XCTAssertEqual(self.theSchedule!.GameTime!, resSchedule.GameTime!)
        XCTAssertEqual(self.theSchedule!.GameInfo!, resSchedule.GameInfo!)
        XCTAssertEqual(self.theSchedule!.Event!.EventID!, resSchedule.Event!.EventID!)
    }
    
    
    //测试 修改Events方法
    func test_4_Modify() {
        
        self.theSchedule.ScheduleID = 502
        self.theSchedule.GameInfo = "test modify GameInfo"
        
        let res = self.dao.modify(self.theSchedule)
        //断言 无异常，返回值为0
        XCTAssert(res == 0)
        
        let resSchedule = self.dao.findById(self.theSchedule)
        //断言 查询结果非nil
        XCTAssertNotNil(resSchedule)
        //断言
        XCTAssertEqual(self.theSchedule!.GameDate!, resSchedule!.GameDate!)
        XCTAssertEqual(self.theSchedule!.GameTime!, resSchedule!.GameTime!)
        XCTAssertEqual(self.theSchedule!.GameInfo!, resSchedule!.GameInfo!)
        XCTAssertEqual(self.theSchedule!.Event!.EventID!, resSchedule!.Event!.EventID!)
        
    }
    
    
    //测试 删除数据方
    func test_5_Remove() {
        
        self.theSchedule.ScheduleID = 502
        let res = self.dao.remove(self.theSchedule)
        //断言 无异常，返回值为0
        XCTAssert(res == 0)
        
        let resSchedule = self.dao.findById(self.theSchedule)
        //断言 查询结果nil
        XCTAssertNil(resSchedule)
    }
    
}
