//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 12/07/24.
//

import UIKit

class RMSearchViewController: UIViewController {
    
    /// Configuration for search session
    struct Config{
        enum `Type`{
            case character // name | status | gender
            case episode  // name
            case location// name | type
            
            var title: String{
                switch self{
                case .character:
                    return "Search Characters"
                case .episode:
                    return "Search Episodes"
                case .location:
                    return "Search Locations"
                }
            }
        }
        let type: `Type`
        
    }
    
    private let viewModel: RMSearchViewViewModel
    
    private let searchView : RMSearchView
    
    //MARK: - Init
    init(config:Config){
        let viewModel = RMSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        addConstrains()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done,
                                                            target: self, action: #selector(didTapSearchExecute))
        searchView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchView.presentKeyboard()
    }
    
    @objc private func didTapSearchExecute(){
        
    }
    
    private func addConstrains(){
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

}

//MARK: - RMSearchView Delegate
extension RMSearchViewController: RMSearchViewDelegate{
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.dynamicOption) {
        print("Should present")
    }
    
    
}
