//
//  EventsDAOTests.swift
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

class EventsDAOTests: XCTestCase {

    var dao: EventsDAO!
    var theEvents: Events!
    
    override func setUp() {
        super.setUp()
        
        //创建EventsDAO对象
        self.dao = EventsDAO.sharedInstance
        //创建Events对象
        self.theEvents = Events()
        self.theEvents.EventName = "test EventName"
        self.theEvents.EventIcon = "test EventIcon"
        self.theEvents.KeyInfo = "test KeyInfo"
        self.theEvents.BasicsInfo = "test BasicsInfo"
        self.theEvents.OlympicInfo = "test OlympicInfo"
        
    }
    
    override func tearDown() {
        self.dao = nil
        super.tearDown()
    }

    //测试 插入Events方法
    func test_1_Create() {
        let res = self.dao.create(self.theEvents)
        //断言 无异常，返回值为0，
        XCTAssert(res == 0)
    }
    
    //测试 按照主键查询数据方法
    func test_2_FindById() {
        self.theEvents.EventID = 41
        let resEvents = self.dao.findById(self.theEvents)
        
        //断言 查询结果非nil
        XCTAssertNotNil(resEvents)
        //断言
        XCTAssertEqual(self.theEvents.EventName!, resEvents!.EventName!)
        XCTAssertEqual(self.theEvents.EventIcon!, resEvents!.EventIcon!)
        XCTAssertEqual(self.theEvents.KeyInfo!, resEvents!.KeyInfo!)
        XCTAssertEqual(self.theEvents.BasicsInfo!, resEvents!.BasicsInfo!)
        XCTAssertEqual(self.theEvents.OlympicInfo!, resEvents!.OlympicInfo!)
    }

    //测试 查询所有数据方法
    func test_3_FindAll() {
        let list =  self.dao.findAll()
        //断言 查询记录数为1
        XCTAssert(list.count == 41)
        
        let resEvents:Events = list[40] as Events
        //断言
        XCTAssertEqual(self.theEvents.EventName!, resEvents.EventName!)
        XCTAssertEqual(self.theEvents.EventIcon!, resEvents.EventIcon!)
        XCTAssertEqual(self.theEvents.KeyInfo!, resEvents.KeyInfo!)
        XCTAssertEqual(self.theEvents.BasicsInfo!, resEvents.BasicsInfo!)
        XCTAssertEqual(self.theEvents.OlympicInfo!, resEvents.OlympicInfo!)
    }
    
    //测试 修改Events方法
    func test_4_Modify() {
        
        self.theEvents.EventID = 41
        self.theEvents.EventName = "test modify EventName"
    
        let res = self.dao.modify(self.theEvents)
        //断言 无异常，返回值为0
        XCTAssert(res == 0)
        
        let resEvents = self.dao.findById(self.theEvents)
        //断言 查询结果非nil
        XCTAssertNotNil(resEvents)
        
        //断言
        XCTAssertEqual(self.theEvents.EventName!, resEvents!.EventName!)
        XCTAssertEqual(self.theEvents.EventIcon!, resEvents!.EventIcon!)
        XCTAssertEqual(self.theEvents.KeyInfo!, resEvents!.KeyInfo!)
        XCTAssertEqual(self.theEvents.BasicsInfo!, resEvents!.BasicsInfo!)
        XCTAssertEqual(self.theEvents.OlympicInfo!, resEvents!.OlympicInfo!)
    }
    
    //测试 删除数据方
    func test_5_Remove() {
        
        self.theEvents.EventID = 41
        self.theEvents.EventName = "test modify EventName"
        
        let res = self.dao.remove(self.theEvents)
        //断言 无异常，返回值为0
        XCTAssert(res == 0)
        
        let resEvents = self.dao.findById(self.theEvents)
        //断言 查询结果nil
        XCTAssertNil(resEvents)
    }
    
}
