//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 21/07/24.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject{
    func rmSearchInputView(_ inputView: RMSearchInputView,didSelectOption option: RMSearchInputViewViewModel.dynamicOption)
    
    func rmSearchInputView(_ inputView: RMSearchInputView,didChangeSearchText text: String)
    
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView)

}

class RMSearchInputView: UIView {
    
    weak var delegate:RMSearchInputViewDelegate?
    private var stackView:UIStackView?
    
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
        searchBar.delegate = self
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
        self.stackView = stackView
        
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
    
    public func update(option: RMSearchInputViewViewModel.dynamicOption, value:String){
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let allOptions = viewModel?.options,
              let index = allOptions.firstIndex(of: option) else{
            return
        }
        let button: UIButton = buttons[index]
        button.setAttributedTitle(NSAttributedString(string: value.uppercased(),attributes: [
            .font:UIFont.systemFont(ofSize: 18,weight: .medium),.foregroundColor:UIColor.link
        ]),
                                  for: .normal)
    }
}

//MARK: - UISearchBar Delegate

extension RMSearchInputView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //notify delegate of change of text basically
        delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //notify delegate of that search button of keyboard is pressed
        searchBar.resignFirstResponder()
        delegate?.rmSearchInputViewDidTapSearchKeyboardButton(self)
    }
}
