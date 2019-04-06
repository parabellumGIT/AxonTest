//
//  UserDetailsViewController.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import Kingfisher

class UserDetailsViewController: UIViewController, ControllerType, ErrorRepresentable {
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cellStackView: UIStackView!
    @IBOutlet weak var phoneStackView: UIStackView!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    typealias ViewModelType = UserDetailsVCViewModel
    private var viewModel: ViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: viewModel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
    func configure(with viewModel: UserDetailsVCViewModel) {
        viewModel.onError = {[weak self] errorText in
            self?.showError(text: errorText)
        }
        userImageView.setImage(from: viewModel.userVM.imageUrl, defaultImg: UIImage(named: "user"))
        firstNameLabel.text = viewModel.userVM.name
        lastNameLabel.text = viewModel.userVM.lastName
        phoneStackView.isHidden = viewModel.userVM.phoneNumber == nil
        cellStackView.isHidden = viewModel.userVM.cellNumber == nil
        cellLabel.text = viewModel.userVM.cellNumber
        phoneLabel.text = viewModel.userVM.phoneNumber
        birthdayLabel.text = viewModel.userVM.birthDay
        genderLabel.text = viewModel.userVM.gender
    }
    
    @IBAction func cellCallAction(_ sender: Any) {
        viewModel.call(numberType: .cell)
    }
    
    @IBAction func phoneCallAction(_ sender: Any) {
        viewModel.call(numberType: .phone)
    }
}

extension UserDetailsViewController {
    static func create(with viewModel: UserDetailsVCViewModel) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: UserDetailsViewController.reuseIdentifier) as! UserDetailsViewController
        controller.viewModel = viewModel
        controller.navigationItem.largeTitleDisplayMode = .never
        controller.navigationItem.title = viewModel.userVM.fullName
        return controller
    }
}
