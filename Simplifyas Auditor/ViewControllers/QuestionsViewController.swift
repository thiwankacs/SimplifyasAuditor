//
//  QuestionsViewController.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/24/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController , UITableViewDelegate, TreeTableDataSource{

    @IBOutlet weak var treeView: UITableView!
    
    let fm = FileManager.default
    var rootPath = Bundle.main.bundlePath
    
    var rootItems: [String]!
    var expandedItems: [IndexPath: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "sample", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                //print(jsonResult)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>/*, let colors = jsonResult["colors"] as? [Any] */{
                    // do stuff
                    print(jsonResult)
                }
            } catch {
                // handle error
            }
        }

        expandedItems = [[0, 5] : true, [0, 5, 0] : true, [0, 5, 0, 0]: true]
        //expandedItems = [:]
        rootItems = try! fm.contentsOfDirectory(atPath: rootPath)
        
        
        let identifier = NSStringFromClass(UITableViewCell.self)
        treeView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func filePath(fromTreeIndexPath ip: IndexPath) -> String {
        var path = rootPath
        
        for i in 1 ..< ip.count {
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            path = (path as NSString).appendingPathComponent(items[ip[i]])
        }
        
//        print(path)
        return path
    }
    
    // MARK: - TreeTableDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootItems.count
    }
    
    func tableView(_ tableView: UITableView, isCellExpanded indexPath: IndexPath) -> Bool {
        if let expanded = expandedItems[indexPath] {
            return expanded
        } else {
            return false
        }
    }

    func tableView(_ tableView: UITableView, numberOfSubCellsForCellAt treeIndexPath: IndexPath) -> UInt {
        let filePath = self.filePath(fromTreeIndexPath: treeIndexPath)
        
        return UInt((try! fm.contentsOfDirectory(atPath: filePath)).count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt treeIndexPath: IndexPath) -> UITableViewCell {
        let tableIndexPath = tableView.tableIndexPath(fromTreePath: treeIndexPath)
        
        let identifier = NSStringFromClass(UITableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: tableIndexPath)
        
        cell.indentationLevel = treeIndexPath.count - 1
        
        let filePath = self.filePath(fromTreeIndexPath: treeIndexPath)
        
        var isDirectory = ObjCBool(false)
        fm.fileExists(atPath: filePath, isDirectory: &isDirectory)
        
        cell.accessoryType = isDirectory.boolValue ? .disclosureIndicator : .none
        cell.textLabel?.text = (filePath as NSString).lastPathComponent
        
        cell.textLabel?.textColor = UIColor.black
        cell.contentView.backgroundColor = UIColor.clear
        
        if tableView.isExpanded(treeIndexPath) {
            //tableView.scrollToRow(at: [0,9], at: .top, animated: true)
            //cell.layer.backgroundColor = UIColor.lightGray.cgColor
            cell.textLabel?.textColor = UIColor.white
            cell.contentView.backgroundColor = UIColor.black
            
            
            if tableView.hasRowAtIndexPath(indexPath: tableIndexPath as NSIndexPath) {
                // do something
                //tableView.scrollToRow(at: [0,1], at: .top, animated: true)
                print(tableIndexPath)
            }
            
            print(tableView.hasRowAtIndexPath(indexPath: tableIndexPath as NSIndexPath))
        }
        
        return cell;
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt tableIndexPath: IndexPath) {
        tableView.deselectRow(at: tableIndexPath, animated: true)
        
        let treeIndexPath = tableView.treeIndexPath(fromTablePath: tableIndexPath)
        
        //print(treeIndexPath)
        //print(tableView.contentOffset.y)
        
        //tableView.scrollToRow(at: [0,5], at: .top, animated: true)
        //let indexPath = IndexPath(row: 0, section: 0)
        
        //print(tableIndexPath)
        tableView.scrollToRow(at: tableIndexPath, at: .top, animated: true)
        
        //tableView.scrollToRow(at: IndexPath.init(row: 0, section: 5), at: .top, animated: true)
        
        if tableView.isExpanded(treeIndexPath) {
            let index = expandedItems.index(forKey: treeIndexPath)!
            expandedItems.remove(at: index)
            
            tableView.collapse(treeIndexPath)
        } else {
            let filePath = self.filePath(fromTreeIndexPath: treeIndexPath)
            
            var isDirectory = ObjCBool(false)
            fm.fileExists(atPath: filePath, isDirectory: &isDirectory)
            
            if isDirectory.boolValue {
                expandedItems[treeIndexPath] = true
                
                tableView.expand(treeIndexPath)
            }
        }
        
        //tableView.reloadData()
    }
}


