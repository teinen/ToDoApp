//
//  ViewController.swift
//  ToDoApp
//
//  Created by AKIRA KANNO on 2018/02/25.
//  Copyright © 2018年 teinen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    @IBOutlet var taskListView: UITableView!
    
    var tasks:[Task] = []
    var tasksToShow:[String] = []
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskListView.dataSource = self
        taskListView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch Data from CoreData
        self.fetchData()
        
        // Reload list view
        taskListView.reloadData()
    }
    
    // MARK: Table View Fucntion
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "\(tasksToShow[indexPath.row])"

        return cell
    }
    
    // MARK: CoreData function
    func fetchData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            // create fetch request
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            
            tasks = try context.fetch(fetchRequest)
            
            // Reset tasks info
            tasksToShow = []
            
            // Add task name to show in list view
            for task in tasks {
                tasksToShow.append(task.name!)
            }

        } catch {
            print("Data fetching was failed.")
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

