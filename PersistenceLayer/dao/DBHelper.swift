//
//  DBHelper.swift
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
            if sqlite3_open(dbFilePath!, &db) == SQLITE_OK {
                //加载数据到业务表中
                NSLog("数据库升级...")
                let createtablePath = NSBundle.mainBundle().pathForResource("create_load", ofType : "sql")!
                let sql = NSString(contentsOfFile : createtablePath, encoding : NSUTF8StringEncoding, error:nil)
                let cSql = sql?.cStringUsingEncoding(NSUTF8StringEncoding)
                
                sqlite3_exec(db,cSql!, nil, nil, nil)
                
                //把当前版本号写回到文件中
                let usql = NSString(format:"update  DBVersionInfo set version_number = %i", dbConfigVersion!.integerValue)
                let cusql = usql.cStringUsingEncoding(NSUTF8StringEncoding)
                sqlite3_exec(db,cusql, nil, nil, nil)
                
                sqlite3_close(db)
            }
        }
        
    }
    
    static func  dbVersionNubmer() -> Int {
        
        var versionNubmer = -1
        
        let dbFilePath = DBHelper.applicationDocumentsDirectoryFile(DB_FILE_NAME)
        
        if sqlite3_open(dbFilePath!, &db) == SQLITE_OK {
            let sql = "create table if not exists DBVersionInfo ( version_number int )"
            let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            sqlite3_exec(db,cSql!, nil, nil, nil)
            
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
                    sqlite3_exec(db,cInsertSql!, nil, nil, nil)
                }                
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        return versionNubmer
    }
    
}
