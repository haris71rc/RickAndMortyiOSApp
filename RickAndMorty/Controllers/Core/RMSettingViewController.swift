//
//  RMSettingViewController.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 26/04/24.
//

import SafariServices
import SwiftUI
import StoreKit
import UIKit

/// Controller to show setting
final class RMSettingViewController: UIViewController {
    
//    private let viewModel = RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({
//        return RMSettingsCellViewModel(type: $0)
//    }))
    
    private var settingsSwiftUIController: UIHostingController<RMSettingsView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()
    }
    
    private func addSwiftUIController(){
        let settingsSwiftUIController = UIHostingController(rootView: RMSettingsView(viewModel: RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) {[weak self] options in
                self?.handleTap(options: options)
            }
        }))))
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        self.settingsSwiftUIController = settingsSwiftUIController
    }

    private func handleTap(options: RMSettingsOption){
        guard Thread.current.isMainThread else{ //we are doing this just to make sure we are doing all UI changes on main thread
            return
        }
        
        if let url = options.targetURL{
            //open website
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
        else if options == .rateApp{
            //open rate prompt
            if let windowScene = view.window?.windowScene{
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}
