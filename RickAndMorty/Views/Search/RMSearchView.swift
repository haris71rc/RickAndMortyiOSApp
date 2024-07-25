//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 21/07/24.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject{
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.dynamicOption)
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation)
}

final class RMSearchView: UIView {
    
    weak var delegate: RMSearchViewDelegate?
    
    private let viewModel: RMSearchViewViewModel
    
    private let searchInputView = RMSearchInputView()
    private let noResultView = RMNoSearchResultsView()
    private let resultsView = RMSearchResultsView()
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultsView,noResultView,searchInputView)
        addConstraint()
        searchInputView.configure(with: .init(type: viewModel.config.type))
        searchInputView.delegate = self
        
        resultsView.delegate = self
        
        setUpHandlers(viewModel: viewModel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHandlers(viewModel: RMSearchViewViewModel){
        viewModel.registerOptionChangeBlock { tuple in
            // tuple: option | value
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        viewModel.registerSearchResultHandler {[weak self] results in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: results)
                self?.noResultView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        
        viewModel.registerNoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }
    
    private func addConstraint(){
        NSLayoutConstraint.activate([
            
            //Search Result View
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55:110),
            
            //Results View
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leftAnchor.constraint(equalTo: leftAnchor),
            resultsView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            //No Result View
            noResultView.widthAnchor.constraint(equalToConstant: 150),
            noResultView.heightAnchor.constraint(equalToConstant: 150),
            noResultView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    public func presentKeyboard(){
        searchInputView.presentKeyboard()
    }
}

//MARK: - Collectionview
extension RMSearchView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//MARK: - searchInputView Delegate Implementation
extension RMSearchView: RMSearchInputViewDelegate{
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.dynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
}

//MARK: - RMSearchResultsView Delegate Implementation
extension RMSearchView: RMSearchResultsViewDelegate{
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: index) else{
            return
        }
        print("tapped location at \(locationModel)")
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
    }
}
