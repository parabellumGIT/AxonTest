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
    var onDidLoadUsers: (() -> ())?
    var shouldShowLoadingCell: Bool = false
     private var isFetchingInProgress = false
    
    private weak var coordinatorDelegate: HomeViewControllerViewModelCoordinatorDelegate?
    private var currentPage = 1
    private var users: [UserModel] = []
    private let batchCount = 20
     //MAX pages cap
    private let pageCap = 30
    
    var numberOfRows: Int {
        return users.count
    }

    func fetchNextPage() {
        if !isFetchingInProgress {
            currentPage += 1
            fetchUsers()
        }
    }
    
    func didRefresh() {
        currentPage = 1
        fetchUsers(refreshing: true)
    }
    
    func userViewModel(for row: Int) -> UserViewModel {
        return UserViewModel(from: users[row], imageType: .thumb)
    }
    
    func selectUser(at row: Int) {
        coordinatorDelegate?.didSelect(user: users[row])
    }
    
    private func fetchUsers(refreshing: Bool = false){
        isFetchingInProgress = true
        isLoading?(true)
        NM.shared.getUsers(count: batchCount, page: currentPage, seed: "axon") {[weak self] (result) in
            guard let self = self else { return }
            self.isLoading?(false)
            self.isFetchingInProgress = false
            switch result {
            case .failure(let error):
                self.onError?(error)
            case .success(let users):
                if refreshing {
                    self.users = users
                } else {
                    for user in users {
                        if !self.users.contains(user) {
                            self.users.append(user)
                        }
                    }
                }
                self.shouldShowLoadingCell = self.currentPage < self.pageCap
                self.onDidLoadUsers?()
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
                fetchNextPage()
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
