//
//  DBHelper.swift
//  RioOlympics2016
//
//  Created by tonymacmini on 14/11/6.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

import Foundation


struct DBHelper {
    
    static var db:COpaquePointer = nil
    
    //获得沙箱Document目录下全路径
    static func applicationDocumentsDirectoryFile(fileName: NSString) -> [CChar]? {
        
        let  documentDirectory: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let path = documentDirectory[0].stringByAppendingPathComponent(DB_FILE_NAME) as String
        NSLog("path : %@", path)
        
        let cpath = path.cStringUsingEncoding(NSUTF8StringEncoding)
        
        return cpath
    }
    
    //初始化并加载数据
    static func initDB() {
        
        let configTablePath = NSBundle.mainBundle().pathForResource("DBConfig", ofType : "plist")!
        NSLog("configTablePath = %@",configTablePath)
        
        let configTable = NSDictionary(contentsOfFile : configTablePath)
        
        //从配置文件获得数据版本号
        var dbConfigVersion = configTable?.objectForKey("DB_VERSION") as NSNumber?
        
        if (dbConfigVersion == nil) {
            dbConfigVersion = NSNumber(integer:0)
        }
        //从数据库DBVersionInfo表记录返回的数据库版本号
        var versionNubmer:Int = DBHelper.dbVersionNubmer()
        
        //版本号不一致
        if dbConfigVersion?.integerValue != versionNubmer {
            let dbFilePath = DBHelper.applicationDocumentsDirectoryFile(DB_FILE_NAME)
            if sqlite3_open(dbFilePath!, &db) != SQLITE_OK {
                let err = sqlite3_errmsg(db)
                sqlite3_close(db)
                let msg = "数据库打开失败:\(err)"
                assert(false, msg)
            } else {
                //加载数据到业务表中
                NSLog("数据库升级...")
                let createtablePath = NSBundle.mainBundle().pathForResource("create_load", ofType : "sql")!
                let sql = NSString(contentsOfFile : createtablePath, encoding : NSUTF8StringEncoding, error:nil)
                let cSql = sql?.cStringUsingEncoding(NSUTF8StringEncoding)
                
                if (sqlite3_exec(db,cSql!, nil, nil, nil) != SQLITE_OK) {
                    let err = sqlite3_errmsg(db)
                    let msg = "数据库升级失败原因:\(err)"
                    NSLog("数据库升级失败原因 : %@",msg)
                }
                //把当前版本号写回到文件中
                let usql = NSString(format:"update  DBVersionInfo set version_number = %i", dbConfigVersion!.integerValue)
                let cusql = usql.cStringUsingEncoding(NSUTF8StringEncoding)
                
                if (sqlite3_exec(db,cusql, nil, nil, nil) != SQLITE_OK) {
                    NSLog("更新DBVersionInfo数据失败。")
                }
                sqlite3_close(db)
            }
        }
        
    }
    
    static func  dbVersionNubmer() -> Int {
        
        var versionNubmer = -1
        
        let dbFilePath = DBHelper.applicationDocumentsDirectoryFile(DB_FILE_NAME)
        
        if sqlite3_open(dbFilePath!, &db) != SQLITE_OK {
            sqlite3_close(db)
            assert(false, "数据库打开失败。")
        } else {
            let sql = "create table if not exists DBVersionInfo ( version_number int )"
            let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            if (sqlite3_exec(db,cSql!, nil, nil, nil) != SQLITE_OK) {
                let err = sqlite3_errmsg(db)
                sqlite3_close(db)
                let msg = "建表失败:\(err)"
                assert(false, msg)
            }
            
            let qsql = "select version_number from DBVersionInfo"
            let cqsql = qsql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            var statement:COpaquePointer = nil
            //预处理过程
            if sqlite3_prepare_v2(db, cqsql!, -1, &statement, nil) == SQLITE_OK {
                //执行查询
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    NSLog("有数据情况")
                    versionNubmer = Int(sqlite3_column_int(statement, 0))
                    
                } else {
                    
                    NSLog("无数据情况")
                    let insertSql = "insert into DBVersionInfo (version_number) values(-1)"
                    let cInsertSql = insertSql.cStringUsingEncoding(NSUTF8StringEncoding)
                    
                    if (sqlite3_exec(db,cInsertSql!, nil, nil, nil) != SQLITE_OK) {
                        
                        let err = sqlite3_errmsg(db)
                        
                        sqlite3_finalize(statement)
                        sqlite3_close(db)
                        
                        let msg = "插入数据失败:\(err)"
                        assert(false, msg)
                        
                    }
                }
                
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        return versionNubmer
    }
    
}
