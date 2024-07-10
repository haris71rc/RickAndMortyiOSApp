//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 01/07/24.
//

import UIKit

/// Controller to show details about a single character
final class RMCharacterDetailViewController: UIViewController {
    
    private let viewModel: RMCharacterDetailViewViewModel
    private let detailView : RMCharacterDetailView
    
    //MARK: - Init
    init(viewModel: RMCharacterDetailViewViewModel){
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        addConstrains()
        detailView.collectionView?.dataSource = self
        detailView.collectionView?.delegate = self
    }
    
    @objc private func didTapShare(){
        //share character info
    }
    private func addConstrains(){
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
}

extension RMCharacterDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType{
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType{
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifier,
                                                                for: indexPath) as? RMCharacterPhotoCollectionViewCell else{
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
            
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifier,
                                                                for: indexPath) as? RMCharacterInfoCollectionViewCell else{
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
                                                                for: indexPath) as? RMCharacterEpisodeCollectionViewCell else{
                fatalError()
            }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
}
