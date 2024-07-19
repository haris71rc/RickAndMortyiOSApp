//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 20/07/24.
//

import UIKit

class RMLocationDetailViewController: UIViewController,RMLocationDetailViewViewModelDelegate,RMLocationDetailViewDelegate {
    
    private let viewModel : RMLocationDetailViewViewModel
    private let detailView = RMLocationDetailView()
    
    //MARK: Init
    
    init(location: RMLocation){
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewViewModel(endpointURL: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location"
        view.addSubview(detailView)
        
        detailView.delegate = self
        addConstrains()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.action,
                                                            target: self,
                                                            action: #selector(didTapShare))
        
        viewModel.delegate = self
        viewModel.fetchLocationData()
    }
    
    @objc private func didTapShare(){
        
    }
    private func addConstrains(){
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    //MARK: - ViewModel Delegate
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
        
    }
    
    //MARK: - View Delegate
    func rmEpisodeDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


   


