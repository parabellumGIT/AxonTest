//
//  HomeViewControllerViewModel.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import Reachability

typealias OnErrorOccuredAction = (Error) -> Void

protocol HomeViewControllerViewModelCoordinatorDelegate: class {
    func didSelect(user: UserModel)
}

final class HomeViewControllerViewModel: ViewModelProtocol {
    var onError: OnErrorOccuredAction?
    var isLoading: ((Bool) -> Void)?
    var onRefresh: (() -> ())?
    
    private weak var coordinatorDelegate: HomeViewControllerViewModelCoordinatorDelegate?
    private var page = 0
    private var users: [UserModel] = [] {
        didSet {
            onRefresh?()
        }
    }
    
    var numberOfRows: Int {
        return users.count
    }
    
    func userViewModel(for row: Int) -> UserViewModel {
       return UserViewModel(from: users[row], imageType: .thumb)
    }
    
    func selectUser(at row: Int) {
        coordinatorDelegate?.didSelect(user: users[row])
    }
    
    private var isFetchingInProgress = false
    
    private func fetchUsers(){
        isFetchingInProgress = true
        isLoading?(true)
        NM.shared.getUsers(count: 20, page: page, seed: "axon") {[weak self] (result) in
            guard let self = self else { return }
            self.isLoading?(false)
            self.isFetchingInProgress = false
            switch result {
            case .failure(let error):
                self.onError?(error)
            case .success(let users):
                self.page += 1
                self.users = users
            }
        }
    }
    
    func onVCReady() {
        fetchUsers()
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        let obj = notification.object as! Reachability
        switch obj.connection {
        case .none:
           break
        case .cellular, .wifi:
            if !isFetchingInProgress {
                fetchUsers()
            }
        }
    }
    
    init(coordinatorDelegate: HomeViewControllerViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkStatusChanged(_: )),
                                               name: .reachabilityChanged,
                                               object: NetworkReachabilityManager.shared.reachability)
    }
}
