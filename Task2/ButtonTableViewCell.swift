//
//  ButtonTableViewCell.swift
//  Task2
//
//  Created by Nicholas Laughter on 5/19/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    var delegate: ButtonTableViewCellDelegate?
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonTapped(sender: AnyObject) {
        delegate?.buttonCellButtonTapped(self)
    }
    
    func updateButton(isInomplete: Bool) {
        if isInomplete {
            button.setImage(UIImage(named: "incomplete"), forState: .Normal)
        } else {
            button.setImage(UIImage(named: "complete"), forState: .Normal)
        }
    }
}

extension ButtonTableViewCell {
    
    func updateWithTask(task: Task) {
        self.primaryLabel.text = task.name
        self.updateButton(task.isIncomplete.boolValue)
    }
}

protocol ButtonTableViewCellDelegate {
    func buttonCellButtonTapped(sender: ButtonTableViewCell)
}