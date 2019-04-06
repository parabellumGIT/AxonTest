//
//  HomeViewController.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ErrorRepresentable {
    
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    typealias ViewModelType = HomeViewControllerViewModel
    private var viewModel: ViewModelType!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: UserTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        activityIndicator.startAnimating()
        configureAppearance()
        configure(with: viewModel)
        viewModel.onVCReady()
    }
    
    
    
    func configure(with viewModel: HomeViewControllerViewModel) {
        viewModel.onError = {[weak self] error in
            //TODO: - localized errors
            //TODO: - retry?
            self?.showError(title: "Oops", text: "Error", completion: nil)
        }
        
        viewModel.isLoading = {[weak self] isLoading in
            //Hide error popup if internet becomes reachable
            if isLoading {
                self?.presentedViewController?.dismiss(animated: true, completion: nil)
            }
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
        
        viewModel.onRefresh = {[weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
    private func configureAppearance() {
        tableView.tableFooterView = UIView()
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        let userVM = viewModel.userViewModel(for: indexPath.row)
        cell.configure(with: userVM)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectUser(at: indexPath.row)
    }
    
}

extension HomeViewController: ControllerType {
    static func create(with viewModel: HomeViewControllerViewModel) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: HomeViewController.reuseIdentifier) as! HomeViewController
        controller.viewModel = viewModel
        controller.navigationItem.largeTitleDisplayMode = .never
        controller.navigationItem.title = "Users"
        return controller
    }
}

