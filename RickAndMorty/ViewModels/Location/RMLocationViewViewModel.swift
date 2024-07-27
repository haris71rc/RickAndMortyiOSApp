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
    
    public var isdLoadingMoreLocation = false
    
    public var shouldShowLoadMoreIndicator: Bool{
        return apiInfo?.next != nil
    }
    
    public var didFinishPagination : (()->Void)?
    
    public func registerForDidFinishPagination(_ block: @escaping()->Void){
        self.didFinishPagination = block
    }
    
    //Location response info .... will contain next url if present
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    init(){}
    
    /// Paginate if additional locations is needed
    public func fetchAdditionalLocations(){
        guard !isdLoadingMoreLocation else{
            return
        }
        
        guard let urlString=apiInfo?.next,let url=URL(string: urlString) else{
            return
        }
        
        isdLoadingMoreLocation=true

        guard let request = RMRequest(url: url) else{
            isdLoadingMoreLocation=false
            return}
        
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf=self else{return}
            switch result{
            case .success(let responseModel):
                let moreResult = responseModel.results
                let info = responseModel.info
                print("more locations \(moreResult.count)")
                strongSelf.apiInfo = info
                
                strongSelf.cellViewModels.append(contentsOf: moreResult.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                }))
               
                DispatchQueue.main.async{
                    strongSelf.isdLoadingMoreLocation = false
                    
                    strongSelf.didFinishPagination?()
                }
            case .failure(let error):
                print("Error to fetch additional characters \(error)")
                strongSelf.isdLoadingMoreLocation = false
            }
        }
    }
    
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
            case .failure:
                break
            }
        }
    }
    
    private var hasMoreResults: Bool{
        return false
    }
}
