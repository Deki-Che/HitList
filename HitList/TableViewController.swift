//
//  TableViewController.swift
//  HitList
//
//  Created by Deki on 15/10/23.
//  Copyright © 2015年 Deki. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    // 保存姓名数组
    var names = [String]()
    var people = [NSManagedObject]()

    @IBAction func addName(sender: AnyObject) {
        let alertController = UIAlertController(title: "添加新姓名", message: "请输入姓名", preferredStyle: UIAlertControllerStyle.Alert)
        let alertActionDone = UIAlertAction(title: "保存", style: UIAlertActionStyle.Default) {
            (action: UIAlertAction!) -> Void in
            let textField = alertController.textFields![0] as UITextField
            
            // 保存数据coredata
            self.saveName(textField.text!)
            //self.tableView.reloadData()
            let indexPath = NSIndexPath(forRow: (self.people.count - 1), inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
            
        }
        let alertActionCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil )
        alertController.addAction(alertActionCancel)
        alertController.addAction(alertActionDone)
        
        alertController.addTextFieldWithConfigurationHandler(nil)

        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func saveName(text:String) {
        // 1 取得总代理 ，和总管对象
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // 内容总管
        let managedObjectContext = appDelegate.managedObjectContext
        
        // 2 建立一个 entity
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedObjectContext)
        
        // 创建单个人
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        // 3 person 保存传过来的数据
        person.setValue(text, forKey: "name")
        
        // 4保存entity 到托管对象总管, 需要捕获错误
        do {
            try managedObjectContext.save()
            people.append(person)
        }catch let erro as NSError {
            print("不能保存\(erro), \(erro.userInfo)")
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "姓名列表"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 取得代理总管
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let manageObjectContext = appDelegate.managedObjectContext
        
        // 获取的请求
        let fetchRequst = NSFetchRequest(entityName: "Person")
        
        // 执行请求
        do {
            let results = try manageObjectContext.executeFetchRequest(fetchRequst)
            people = results as! [NSManagedObject]
            self.tableView.reloadData()
        } catch let erro as NSError {
            print("不能捕获 \(erro), \(erro.userInfo)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  people.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = people[indexPath.row].valueForKey("name") as? String

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
