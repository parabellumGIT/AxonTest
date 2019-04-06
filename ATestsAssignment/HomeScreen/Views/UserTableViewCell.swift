//
//  UserTableViewCell.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 30
    }

    func configure(with vm: UserViewModel) {
        nameLabel.text = vm.fullName
        birthdayLabel.text = "Age:"
        birthdayDateLabel.text = vm.age ?? "--"
        userImageView.setImage(from: vm.imageUrl, defaultImg: UIImage(named: "user"))
    }
}
