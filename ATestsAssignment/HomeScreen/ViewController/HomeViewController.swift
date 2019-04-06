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
    
    typealias ViewModelType = HomeViewControllerViewModel
    private var viewModel: ViewModelType!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configure(with: viewModel)
        viewModel.onVCReady()
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl?.beginRefreshing()
        tableView.register(UINib(nibName: UserTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.reuseIdentifier)
    }

    @objc
    private func refresh() {
        viewModel.didRefresh()
    }
    
    func configure(with viewModel: HomeViewControllerViewModel) {
        viewModel.onError = {[weak self] error in
            self?.showError(title: "Oops", text: error.localizedDescription, completion: nil)
        }
        
        viewModel.isLoading = {[weak self] isLoading in
            //Hide error popup if internet becomes reachable
            if isLoading {
                self?.presentedViewController?.dismiss(animated: true, completion: nil)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }
        
        viewModel.onDidLoadUsers = {[weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
        
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.numberOfRows
        return viewModel.shouldShowLoadingCell ? count + 1 : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingIndexPath(indexPath) {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseIdentifier, for: indexPath)
            return loadingCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
            let userVM = viewModel.userViewModel(for: indexPath.row)
            cell.configure(with: userVM)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !isLoadingIndexPath(indexPath){
            viewModel.selectUser(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoadingIndexPath(indexPath) else { return }
        viewModel.fetchNextPage()
    }
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard viewModel.shouldShowLoadingCell else { return false }
        return indexPath.row == viewModel.numberOfRows
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

