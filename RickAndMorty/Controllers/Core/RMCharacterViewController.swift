//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 26/04/24.
//

import UIKit

/// Controller to show or search for character
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        let request = RMRequest(endPoint: .character,queryParameters: [
            URLQueryItem(name: "name", value: "rick"),URLQueryItem(name: "status", value: "alive")
            //name=rick&status=alive
        ])
        print(request.url)
        
        RMService.shared.execute(request, expecting: String.self) { result in
            //
        }
        
    }
}
