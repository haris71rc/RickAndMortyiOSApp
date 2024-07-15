//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 11/07/24.
//

import UIKit

/// View Controller to show details about single episode
final class RMEpisodeDetailViewController: UIViewController,RMEpisodeDetailViewViewModelDelegate,RMEpisodeDetailViewDelegate {
        
    private let viewModel : RMEpisodeDetailViewViewModel
    private let detailView = RMEpisodeDetailView()
    
    //MARK: Init
    
    init(url: URL?){
        self.viewModel = RMEpisodeDetailViewViewModel(endpointURL: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.addSubview(detailView)
        
        detailView.delegate = self
        addConstrains()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.action,
                                                            target: self,
                                                            action: #selector(didTapShare))
        
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
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
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
        
    }
    
    //MARK: - View Delegate
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelect character: RMCharacter) {
        
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
