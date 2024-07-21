//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 21/07/24.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject{
    func rmSearchInputView(_ inputView: RMSearchInputView,didSelectOption option: RMSearchInputViewViewModel.dynamicOption)
}

class RMSearchInputView: UIView {
    
    weak var delegate:RMSearchInputViewDelegate?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var viewModel: RMSearchInputViewViewModel?{
        didSet{
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else{
                return
            }
            let options = viewModel.options
            createOptionSelectionView(options: options)
        }
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(searchBar)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private
    private func addConstraints(){
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func createOptionStackView()->UIStackView{
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 6
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        return stackView
    }
    private func createOptionSelectionView(options: [RMSearchInputViewViewModel.dynamicOption]){
        
        let stackView =  createOptionStackView()
        
        for x in 0..<options.count {
            let option = options[x]
            let button = createButton(with: option, tag: x)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createButton(with option: RMSearchInputViewViewModel.dynamicOption,tag:Int)->UIButton{
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: option.rawValue,attributes: [
            .font:UIFont.systemFont(ofSize: 18,weight: .medium),.foregroundColor:UIColor.label
        ]),
                                  for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.tag = tag
        button.layer.cornerRadius = 6
        return button
    }
    
    @objc private func didTapButton(_ sender: UIButton){
        guard let option = viewModel?.options else{
            return
        }
        let tag = sender.tag
        let selected = option[tag]
        delegate?.rmSearchInputView(self, didSelectOption: selected)
    }
    
    //MARK: - Public
    
    public func configure(with viewModel: RMSearchInputViewViewModel){
        self.searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }
    public func presentKeyboard(){
        searchBar.becomeFirstResponder()
    }
}
