//
//  EmployeeCell.swift
//  CoreDataDemo
//
//  Created by TapashM on 19/05/18.
//  Copyright © 2018 TapashM. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {

    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var employeeName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var mEmployee: Employee? {
        didSet{
            self.employeeName.text = mEmployee?.name
            self.designation.text = mEmployee?.designation
            self.age.text = String(format:"%d",(mEmployee?.age)!)
        }
    }
    
}
