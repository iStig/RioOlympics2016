//
//  EventsViewController.swift
//  RioOlympics2016
//
//  Created by tonymacmini on 14/11/5.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

import UIKit

//一行中列数
var COL_COUNT = 2


class EventsViewController: UICollectionViewController {
    
    
    var events : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            //如果是iPad设备，列数为5
            COL_COUNT = 5
        }
        
        let bl = EventsBL()
        //获取全部数据
        var array = bl.readData()
        self.events = array
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender : AnyObject?) {
            
            if segue.identifier == "showDetail" {
                
                let indexPaths = self.collectionView.indexPathsForSelectedItems() as [NSIndexPath]
                let indexPath: NSIndexPath = indexPaths[0]
                
                let event = self.events.objectAtIndex(indexPath.section * COL_COUNT + indexPath.row) as Events
                var detailVC = segue.destinationViewController as EventsDetailViewController
                detailVC.event = event
                
            }
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.events.count / COL_COUNT
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return COL_COUNT
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as EventsViewCell
        
        let index = indexPath.section * COL_COUNT + indexPath.row
        
        let event = self.events.objectAtIndex(index) as Events
        cell.imageView.image = UIImage(named : event.EventIcon!)
        
        return cell
    }
    
}
