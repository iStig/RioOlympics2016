//
//  EventsDAO.swift
//  MyNotes
//
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

class EventsDAO : BaseDAO {
    
    class var sharedInstance: EventsDAO {
        struct Static {
            static var instance: EventsDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = EventsDAO()
        }
        return Static.instance!
    }
    
    
    //插入方法
    func create(model: Events) -> Int {
     
       if self.openDB() {
            let sql = "INSERT INTO Events (EventName, EventIcon,KeyInfo,BasicsInfo,OlympicInfo) VALUES (?,?,?,?,?)"
            let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            var statement:COpaquePointer = nil
            //预处理过程
            if sqlite3_prepare_v2(db, cSql!, -1, &statement, nil) == SQLITE_OK {
                
                //绑定参数开始
                sqlite3_bind_text(statement, 1, model.EventName!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_text(statement, 2, model.EventIcon!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_text(statement, 3, model.KeyInfo!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_text(statement, 4, model.BasicsInfo!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_text(statement, 5, model.OlympicInfo!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                
                //执行插入
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    assert(false, "插入数据失败。")
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        return 0
    }
    
    //删除方法
    func remove(model: Events) -> Int {
        
        if self.openDB() {
            
            //先删除子表（比赛日程表）相关数据
            let sqlScheduleStr = NSString(format: "DELETE  from Schedule where EventID=%i", model.EventID!)
            //开启事务，立刻提交之前事务
            sqlite3_exec(db,"BEGIN IMMEDIATE TRANSACTION",nil, nil, nil)
            
            if sqlite3_exec(db, sqlScheduleStr.cStringUsingEncoding(NSUTF8StringEncoding), nil, nil, nil) != SQLITE_OK {
                //回滚事务
                sqlite3_exec(db,"ROLLBACK TRANSACTION", nil, nil, nil)
                assert(false, "删除数据失败。")
            }
            
            //先删除主表（比赛项目）数据
            let sqlEventsStr = NSString(format: "DELETE  from Events where EventID =%i",model.EventID!)
            
            if sqlite3_exec(db, sqlEventsStr.cStringUsingEncoding(NSUTF8StringEncoding), nil, nil, nil) != SQLITE_OK {
                //回滚事务
                sqlite3_exec(db, "ROLLBACK TRANSACTION", nil, nil, nil)
                assert(false, "删除数据失败。")
            }
            //提交事务
            sqlite3_exec(db,"COMMIT TRANSACTION",nil, nil, nil)
            
            sqlite3_close(db)
        }
        return 0
    }
    
    //修改方法
    func modify(model: Events) -> Int {
        if self.openDB() {
            let sql = "UPDATE Events set EventName=?, EventIcon=?,KeyInfo=?,BasicsInfo=?,OlympicInfo=? where EventID =?"
            let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            var statement:COpaquePointer = nil
            //预处理过程
            if sqlite3_prepare_v2(db, cSql!, -1, &statement, nil) == SQLITE_OK {
                
                //绑定参数开始
                sqlite3_bind_text(statement, 1, model.EventName!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_text(statement, 2, model.EventIcon!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_text(statement, 3, model.KeyInfo!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_text(statement, 4, model.BasicsInfo!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_text(statement, 5, model.OlympicInfo!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_int(statement, 6, Int32(model.EventID!))
                
                //执行插入
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    assert(false, "修改数据失败。")
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        return 0
    }
    
    //查询所有数据方法
    func findAll() -> NSMutableArray {
        
        var listData = NSMutableArray()
        
        if self.openDB() {
            
            let qsql = "SELECT EventName, EventIcon,KeyInfo,BasicsInfo,OlympicInfo,EventID FROM Events"
            
            var statement:COpaquePointer = nil
            
            //预处理过程
            if sqlite3_prepare_v2(db, qsql.cStringUsingEncoding(NSUTF8StringEncoding)!, -1, &statement, nil) == SQLITE_OK {
                
                //执行
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    var events = Events()
                    
                    var cEventName = UnsafePointer<Int8>(sqlite3_column_text(statement, 0))
                    events.EventName = String.fromCString(cEventName)
                    
                    var cEventIcon = UnsafePointer<Int8>(sqlite3_column_text(statement, 1))
                    events.EventIcon = String.fromCString(cEventIcon)
                    
                    var cKeyInfo = UnsafePointer<Int8>(sqlite3_column_text(statement, 2))
                    events.KeyInfo = String.fromCString(cKeyInfo)
                    
                    var cBasicsInfo = UnsafePointer<Int8>(sqlite3_column_text(statement, 3))
                    events.BasicsInfo = String.fromCString(cBasicsInfo)
                    
                    var cOlympicInfo = UnsafePointer<Int8>(sqlite3_column_text(statement, 4))
                    events.OlympicInfo = String.fromCString(cOlympicInfo)
                    
                    events.EventID = Int(sqlite3_column_int(statement, 5))
                    
                    listData.addObject(events)
                }
            }
            
            sqlite3_finalize(statement)
            sqlite3_close(db)
            
        }
        return listData
    }
    
    //修改Note方法
    func findById(model: Events) -> Events? {
        
        if self.openDB() {
            
            let qsql = "SELECT EventName, EventIcon,KeyInfo,BasicsInfo,OlympicInfo,EventID FROM Events where EventID =?"
            var statement:COpaquePointer = nil
            
            //预处理过程
            if sqlite3_prepare_v2(db, qsql.cStringUsingEncoding(NSUTF8StringEncoding)!, -1, &statement, nil) == SQLITE_OK {
                //绑定参数开始
                sqlite3_bind_int(statement, 1, Int32(model.EventID!))
                //执行
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    var events = Events()
                    
                    var cEventName = UnsafePointer<Int8>(sqlite3_column_text(statement, 0))
                    events.EventName = String.fromCString(cEventName)
                    
                    var cEventIcon = UnsafePointer<Int8>(sqlite3_column_text(statement, 1))
                    events.EventIcon = String.fromCString(cEventIcon)
                    
                    var cKeyInfo = UnsafePointer<Int8>(sqlite3_column_text(statement, 2))
                    events.KeyInfo = String.fromCString(cKeyInfo)
                    
                    var cBasicsInfo = UnsafePointer<Int8>(sqlite3_column_text(statement, 3))
                    events.BasicsInfo = String.fromCString(cBasicsInfo)
                    
                    var cOlympicInfo = UnsafePointer<Int8>(sqlite3_column_text(statement, 4))
                    events.OlympicInfo = String.fromCString(cOlympicInfo)
                    
                    events.EventID = Int(sqlite3_column_int(statement, 5))
                    
                    sqlite3_finalize(statement)
                    sqlite3_close(db)
            
                    return events
                }
            }
        }
        
        return nil
    }
    
}
