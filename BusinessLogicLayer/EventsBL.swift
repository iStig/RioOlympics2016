//
//  EventsBL.swift
//  RioOlympics2016
//
//  Created by tonymacmini on 14/11/6.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

import Foundation

class EventsBL: NSObject {
    
   //查询所用数据方法
    func readData() -> NSMutableArray {
        
        var dao = EventsDAO.sharedInstance
        var list  = dao.findAll()
        
        return list
    }
}
