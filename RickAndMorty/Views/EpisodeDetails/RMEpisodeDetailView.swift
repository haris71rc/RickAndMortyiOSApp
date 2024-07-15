//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 11/07/24.
//

import UIKit

protocol RMEpisodeDetailViewDelegate:AnyObject{
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelect character: RMCharacter)
}

class RMEpisodeDetailView: UIView {
    
    private var viewModel: RMEpisodeDetailViewViewModel?{
        didSet{
            spinner.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.collectionView?.alpha = 1
            }
        }
    }
    
    public weak var delegate: RMEpisodeDetailViewDelegate?
    
    private var collectionView: UICollectionView?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView,spinner)
        addConstraints()
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints(){
        guard let collectionView = collectionView else{
            return
        }
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    private func createCollectionView()->UICollectionView{
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for:section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RMEpisodeInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        return collectionView
    }
    
    
    
    //MARK: - Public
    public func configure(with viewModel: RMEpisodeDetailViewViewModel){
        self.viewModel = viewModel
    }
    
}

extension RMEpisodeDetailView:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else{
            return 0
        }
        let sectionType = sections[section]
        switch sectionType{
        case .character(let viewModel):
            return viewModel.count
        case .information(let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = viewModel?.cellViewModels else{
            fatalError("No ViewModels")
        }
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .information(let viewModel):
            let cellViewModel = viewModel[indexPath.row]
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier,
                                                          for: indexPath) as? RMEpisodeInfoCollectionViewCell else{
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
            
        case .character(let viewModel):
            let cellVideModel = viewModel[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                                                                for: indexPath) as? RMCharacterCollectionViewCell else{
                fatalError()
            }
            cell.configure(with: cellVideModel)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let viewModel = viewModel else{
            return
        }
        let sections = viewModel.cellViewModels
        let sectionType = sections[indexPath.section]
        
        switch sectionType{
        case .information:
            break
        case .character:
            guard let character = viewModel.character(at: indexPath.row) else{
                return
            }
            delegate?.rmEpisodeDetailView(self, didSelect: character)
        }
    }
    
}

extension RMEpisodeDetailView{
    private func layout(for section: Int) -> NSCollectionLayoutSection{
        guard let sections = viewModel?.cellViewModels else{
            return createInfoLayout()
        }
        switch sections[section]{
        case .information:
            return createInfoLayout()
        case .character:
            return createCharacterLayout()
        }
    }
    
    func createInfoLayout() ->NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = .init(top: 0, leading: 2, bottom: 10, trailing: 2)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(80)),
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    func createCharacterLayout() ->NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(240)),
                                                       subitems: [item,item]) // meaning we need to put two items, side-by-side
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
