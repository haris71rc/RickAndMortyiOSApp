//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 24/07/24.
//

import UIKit

protocol RMSearchResultsViewDelegate:AnyObject{
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
}

class RMSearchResultsView: UIView {

    private var viewModel: RMSearchResultViewModel?{
        didSet{
            self.processViewModel()
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isHidden = true
        return table
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
        
    }()
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    private var collectionViewCellViewModel: [any Hashable] = []
    
    weak var delegate: RMSearchResultsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView,collectionView)
        addConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func processViewModel(){
        guard let viewModel = viewModel else{
            return
        }
        switch viewModel{
        case .characters(let viewModels):
            self.collectionViewCellViewModel = viewModels
            setUpCollectionView()
            
        case.episodes(let viewModels):
            self.collectionViewCellViewModel = viewModels
            setUpCollectionView()
            
        case .locations(let viewModels):
            setUpTableView(viewModels: viewModels)
        }
    }
    
    private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        collectionView.isHidden = true
        self.locationCellViewModels = viewModels
        tableView.reloadData()
    }
    
    private func setUpCollectionView(){
        self.collectionView.isHidden = false
        self.tableView.isHidden = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            //TableView Constraints
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            
            //CollectionView Constraints
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor)
            
        ])
    }

    public func configure(with viewModel: RMSearchResultViewModel){
        self.viewModel = viewModel
    }
}

//MARK: - TableView
extension RMSearchResultsView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier,
                                                       for: indexPath) as? RMLocationTableViewCell else{
            fatalError("failed to dequeue a cell")
        }
        cell.configure(with: locationCellViewModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
    }
    
}

//MARK: - CollectionView
extension RMSearchResultsView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Here the cell type can be episode || character
        let firstObject = collectionViewCellViewModel[indexPath.row]
        if firstObject is RMCharacterCollectionViewCellViewModel{
            //here we have to implement character cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                                                                for: indexPath) as? RMCharacterCollectionViewCell else{
                fatalError()
            }
            if let characterVM = firstObject as? RMCharacterCollectionViewCellViewModel{
                cell.configure(with: characterVM)
            }
            
            return cell
        }
        else{
            //here we have to implement episode cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
                                                                for: indexPath) as? RMCharacterEpisodeCollectionViewCell else{
                fatalError()
            }
            if let episodeVM = firstObject as? RMCharacterEpisodeCollectionViewCellViewModel{
                cell.configure(with: episodeVM)
            }
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let firstObject = collectionViewCellViewModel[indexPath.row]
        if firstObject is RMCharacterCollectionViewCellViewModel{
            let bounds = UIScreen.main.bounds
            let width = (bounds.width-30)/2
            return CGSize(width: width, height: width*1.5)
        }
        else{
            let bounds = collectionView.bounds
            let width = bounds.width-20
            return CGSize(width: width, height: 100)
        }
        
    }
    
}
