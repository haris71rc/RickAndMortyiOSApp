//
//  RMSearchOptionPickerViewController.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 22/07/24.
//

import UIKit

class RMSearchOptionPickerViewController: UIViewController {

    private let option: RMSearchInputViewViewModel.dynamicOption
    private let selectionBlock: ((String)->Void)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - Init
    init(option: RMSearchInputViewViewModel.dynamicOption,selection: @escaping(String)->Void){
        self.option = option
        self.selectionBlock = selection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setUpTable()
    }
    
    private func setUpTable(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
    }
    
}
extension RMSearchOptionPickerViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return option.choices.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let choice = option.choices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = choice.uppercased()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Here we will inform the caller of choice
        let choice = option.choices[indexPath.row]
        self.selectionBlock(choice)
        dismiss(animated: true)
    }
}
