//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 17/07/24.
//

import UIKit

protocol RMLocationViewViewModelDelegate:AnyObject{
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel{
    
    private var locations: [RMLocation] = []{
        didSet{
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if(!cellViewModels.contains(cellViewModel)){
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    public weak var delegate: RMLocationViewViewModelDelegate?
    
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
    //Location response info .... will contain next url if present
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    init(){}
    
    public func returnLocation(at index: Int)->RMLocation?{
        guard index<locations.count, index>=0 else{
            return nil
        }
        return locations[index]
    }
    
    public func fetchLocations(){
        RMService.shared.execute(.listLocations, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                break
            }
        }
    }
    
    private var hasMoreResults: Bool{
        return false
    }
}
