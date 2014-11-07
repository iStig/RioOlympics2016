//
//  BaseDAO.swift
//  RioOlympics2016
//
//  Created by tonymacmini on 14/11/6.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

import Foundation

let DB_FILE_NAME = "app.db"

let writableDBPath = DBHelper.applicationDocumentsDirectoryFile(DB_FILE_NAME)!

class BaseDAO: NSObject {
    
    var db:COpaquePointer = nil

    override init() {
        //初始化数据库
        DBHelper.initDB()
    }
    
    func openDB()->Bool {
        if sqlite3_open(writableDBPath, &db) != SQLITE_OK {
            sqlite3_close(db)
            NSLog("数据库打开失败。")
            return false
        }
        return true
    }
    
}
