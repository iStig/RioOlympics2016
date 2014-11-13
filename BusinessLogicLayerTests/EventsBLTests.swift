//
//  EventsBLTests.swift
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

class EventsBLTests: XCTestCase {
    
    var bl:EventsBL!
    var theEvents: Events!
    
    override func setUp() {
        super.setUp()
        
        //创建EventsBL对象
        self.bl = EventsBL()
        //创建Events对象
        self.theEvents = Events()
        self.theEvents.EventName = "test EventName"
        self.theEvents.EventIcon = "test EventIcon"
        self.theEvents.KeyInfo = "test KeyInfo"
        self.theEvents.BasicsInfo = "test BasicsInfo"
        self.theEvents.OlympicInfo = "test OlympicInfo"
        
        //插入测试数据
        let dao = EventsDAO.sharedInstance
        dao.create(self.theEvents)
    }
    
    override func tearDown() {
        //删除测试数据
        self.theEvents.EventID = 41
        let dao = EventsDAO.sharedInstance
        dao.remove(self.theEvents)
        self.bl = nil
        
        super.tearDown()
    }
    
    //测试 按照主键查询数据方法
    func testFindAll() {
        let list =  self.bl.readData()
        //断言 查询记录数为1
        XCTAssertEqual(list.count, 41)
        
        let resEvents:Events = list[40] as Events
        //断言
        XCTAssertEqual(self.theEvents.EventName! ,resEvents.EventName!)
        XCTAssertEqual(self.theEvents.EventIcon! ,resEvents.EventIcon!)
        XCTAssertEqual(self.theEvents.KeyInfo! ,resEvents.KeyInfo!)
        XCTAssertEqual(self.theEvents.BasicsInfo! ,resEvents.BasicsInfo!)
        XCTAssertEqual(self.theEvents.OlympicInfo! ,resEvents.OlympicInfo!)
    }
}
