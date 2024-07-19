//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 26/04/24.
//

import UIKit

/// Controller to show or search for location
final class RMLocationViewController: UIViewController,RMLocationViewViewModelDelegate,RMLocationViewDelegate {
    
    private let primaryView = RMLocationView()
    private let viewModel = RMLocationViewViewModel()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        view.addSubview(primaryView)
        addConstrains()
        viewModel.fetchLocations()
        viewModel.delegate = self
        primaryView.delegate = self
    }
    @objc private func didTapSearch(){
        
    }
    
    private func addConstrains(){
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    //MARK: - LocationView Model Delegate
    
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }
    
    //MARK: - LocationView Delegate
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}
