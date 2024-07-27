//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 17/07/24.
//

import UIKit

protocol RMLocationViewDelegate:AnyObject{
    func rmLocationView(_ locationView: RMLocationView, didSelect location:RMLocation)
}

class RMLocationView: UIView {
    
    private var viewModel: RMLocationViewViewModel?{
        didSet{
            tableView.isHidden = false
            spinner.stopAnimating()
            tableView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
            viewModel?.registerForDidFinishPagination { [weak self] in
                DispatchQueue.main.async{
                    
                    //indicator go bye bye
                    self?.tableView.tableFooterView = nil
                    
                    //table reloads itself
                    self?.tableView.reloadData()
                }
            }
        }
    }
    public weak var delegate: RMLocationViewDelegate?


    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        tableView.alpha = 0
        tableView.isHidden = true
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(spinner,tableView)
        spinner.startAnimating()
        addConstraints()
        configureTable()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    public func configure(with viewModel: RMLocationViewViewModel){
        self.viewModel = viewModel
    }
}

//MARK: - TableView
extension RMLocationView: UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModels = viewModel?.cellViewModels else{
            fatalError()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier, for: indexPath) as? RMLocationTableViewCell else{
            fatalError()
        }
        
        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viewModel = viewModel?.returnLocation(at: indexPath.row) else{
            return
        }
        
        delegate?.rmLocationView(self, didSelect: viewModel)
    }
}

extension RMLocationView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel = viewModel,!viewModel.cellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator, !viewModel.isdLoadingMoreLocation
               else{
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
                let offset = scrollView.contentOffset.y
                let totalContentHeight = scrollView.contentSize.height
                let totalScrollViewFixedHeight = scrollView.frame.size.height
                
                if(offset >= (totalContentHeight-totalScrollViewFixedHeight-120)){
                    DispatchQueue.main.async{
                        self?.showLoadingIndicator()
                    }
                    viewModel.fetchAdditionalLocations()
                }
                t.invalidate()
        }
    }
    
    private func showLoadingIndicator(){
        let footer = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
        tableView.tableFooterView = footer
    }
}
