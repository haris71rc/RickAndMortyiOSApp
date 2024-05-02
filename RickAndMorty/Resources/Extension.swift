//
//  Extension.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 01/05/24.
//

import UIKit

extension UIView{
    func addSubviews(_ view: UIView...){
        view.forEach({
            addSubview($0)
        })
    }
}
