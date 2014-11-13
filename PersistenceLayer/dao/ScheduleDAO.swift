//
//  ScheduleDAO.swift
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

class ScheduleDAO: BaseDAO {
    
    class var sharedInstance: ScheduleDAO {
        struct Static {
            static var instance: ScheduleDAO?
            static var token: dispatch_once_t = 0
        }        
        dispatch_once(&Static.token) {
            Static.instance = ScheduleDAO()
        }
        return Static.instance!
    }
    
    //插入方法
    func create(model: Schedule) -> Int {
        
        if self.openDB() {
            let sql = "INSERT INTO Schedule (GameDate, GameTime,GameInfo,EventID) VALUES (?,?,?,?)"
            let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            var statement:COpaquePointer = nil
            //预处理过程
            if sqlite3_prepare_v2(db, cSql!, -1, &statement, nil) == SQLITE_OK {
                
                //绑定参数开始
                sqlite3_bind_text(statement, 1, model.GameDate!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_text(statement, 2, model.GameTime!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_text(statement, 3, model.GameInfo!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_int(statement, 4, Int32(model.Event!.EventID!))
                
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
    func remove(model: Schedule) -> Int {
        
            if self.openDB() {
                let sql = "DELETE  from Schedule where ScheduleID =?"
                let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
                
                var statement:COpaquePointer = nil
                //预处理过程
                if sqlite3_prepare_v2(db, cSql!, -1, &statement, nil) == SQLITE_OK {
                    
                    //绑定参数开始
                    sqlite3_bind_int(statement, 1, Int32(model.ScheduleID!))
                    
                    //执行插入
                    if (sqlite3_step(statement) != SQLITE_DONE) {
                        assert(false, "删除数据失败。")
                    }
                }
                sqlite3_finalize(statement)
                sqlite3_close(db)
            }
            
        return 0
    }
    
    //修改方法
    func modify(model: Schedule) -> Int {
        if self.openDB() {
            let sql = "UPDATE Schedule set GameInfo=?,EventID=?,GameDate =?, GameTime=? where ScheduleID=?"
            let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            var statement:COpaquePointer = nil
            //预处理过程
            if sqlite3_prepare_v2(db, cSql!, -1, &statement, nil) == SQLITE_OK {
                
                //绑定参数开始
                sqlite3_bind_text(statement, 1, model.GameInfo!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_int(statement, 2, Int32(model.Event!.EventID!))
                sqlite3_bind_text(statement, 3, model.GameDate!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_text(statement, 4, model.GameTime!.cStringUsingEncoding(NSUTF8StringEncoding), -1, nil)
                sqlite3_bind_int(statement, 5, Int32(model.ScheduleID!))
                let r = sqlite3_step(statement)
                //执行插入
                if ( r != SQLITE_DONE) {
                    println(r)
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
            
            let qsql = "SELECT GameDate, GameTime,GameInfo,EventID,ScheduleID FROM Schedule"
            
            var statement:COpaquePointer = nil
            
            //预处理过程
            if sqlite3_prepare_v2(db, qsql.cStringUsingEncoding(NSUTF8StringEncoding)!, -1, &statement, nil) == SQLITE_OK {
                
                //执行
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    var schedule = Schedule()
                    var event  = Events()
                    schedule.Event = event
                    
                    var cGameDate = UnsafePointer<Int8>(sqlite3_column_text(statement, 0))
                    schedule.GameDate = String.fromCString(cGameDate)
                    
                    var cGameTime = UnsafePointer<Int8>(sqlite3_column_text(statement, 1))
                    schedule.GameTime = String.fromCString(cGameTime)
                    
                    var cGameInfo = UnsafePointer<Int8>(sqlite3_column_text(statement, 2))
                    schedule.GameInfo = String.fromCString(cGameInfo)
                    
                    schedule.Event!.EventID = Int(sqlite3_column_int(statement, 3))
                    schedule.ScheduleID = Int(sqlite3_column_int(statement, 4))
                    
                    listData.addObject(schedule)
                }
            }
            
            sqlite3_finalize(statement)
            sqlite3_close(db)
            
        }
        return listData
    }
    
    //修改Note方法
    func findById(model: Schedule) -> Schedule? {
        
        if self.openDB() {
            
            let qsql = "SELECT GameDate, GameTime,GameInfo,EventID,ScheduleID FROM Schedule where ScheduleID=?"
            
            var statement:COpaquePointer = nil
            
            //预处理过程
            if sqlite3_prepare_v2(db, qsql.cStringUsingEncoding(NSUTF8StringEncoding)!, -1, &statement, nil) == SQLITE_OK {
                
                //绑定参数开始
                sqlite3_bind_int(statement, 1, Int32(model.ScheduleID!))
                
                //执行
                if sqlite3_step(statement) == SQLITE_ROW {
                    
                    var schedule = Schedule()
                    var event  = Events()
                    schedule.Event = event
                    
                    var cGameDate = UnsafePointer<Int8>(sqlite3_column_text(statement, 0))
                    schedule.GameDate = String.fromCString(cGameDate)
                    
                    var cGameTime = UnsafePointer<Int8>(sqlite3_column_text(statement, 1))
                    schedule.GameTime = String.fromCString(cGameTime)
                    
                    var cGameInfo = UnsafePointer<Int8>(sqlite3_column_text(statement, 2))
                    schedule.GameInfo = String.fromCString(cGameInfo)
                    
                    schedule.Event!.EventID = Int(sqlite3_column_int(statement, 3))
                    schedule.ScheduleID = Int(sqlite3_column_int(statement, 4))
                    
                    return schedule
                }
            }
        }
        
        return nil
    }
}
