//
//  TaskTableViewCell.swift
//  ToDoApp
//
//  Created by teinen on 2018/02/25.
//  Copyright © 2018年 teinen. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    // MARK: Properties
    static let reuseIdentifier = "TaskCell"
    
    @IBOutlet weak var taskLabel: UILabel!
    
    // MARK: Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
