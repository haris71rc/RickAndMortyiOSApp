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
    
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    
    weak var delegate: RMSearchResultsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView)
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
            setUpCollectionView()
            
        case.episodes(let viewModels):
            setUpCollectionView()
            
        case .locations(let viewModels):
            setUpTableView(viewModels: viewModels)
        }
    }
    
    private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        self.locationCellViewModels = viewModels
        tableView.reloadData()
    }
    
    private func setUpCollectionView(){
        
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        tableView.backgroundColor = .systemBackground
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
