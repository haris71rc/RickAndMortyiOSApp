//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Mohd Haris on 21/07/24.
//

import Foundation

final class RMSearchViewViewModel{
    
    let config: RMSearchViewController.Config
    private var optionMap: [RMSearchInputViewViewModel.dynamicOption:String] = [:]
    private var optionUpdateBlock:(((RMSearchInputViewViewModel.dynamicOption,String))->Void)?
    
    private var searchText = ""
    private var searchResultHandler : ((RMSearchResultViewModel)->Void)?
    private var noResultsHandler : (()->Void)?
    private var searchResultModel: Codable?
    
    //MARK: - Init
    init(config: RMSearchViewController.Config){
        self.config = config
    }
    
    //MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping(RMSearchResultViewModel)->Void){
        self.searchResultHandler = block
    }
    public func registerNoResultsHandler(_ block: @escaping()->Void){
        self.noResultsHandler = block
    }
    
    public func set(query text: String){
        self.searchText = text
    }
    public func set(value: String, for option: RMSearchInputViewViewModel.dynamicOption){
        optionMap[option] = value
        let tuple = (option,value)
        optionUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(_ block: @escaping((RMSearchInputViewViewModel.dynamicOption,String))->Void){
        self.optionUpdateBlock = block
    }
    
    public func executeSearch(){
        //Send request on the basis of filters
        var querypara : [URLQueryItem] = [URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))]
        
        //Add Options
        querypara.append(contentsOf: optionMap.enumerated().compactMap({ _,element in
            let key: RMSearchInputViewViewModel.dynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        
        //Create request
        let request = RMRequest(endPoint: config.type.endpoint,
                                queryParameters: querypara)
        
        
        switch config.type.endpoint{
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        }
        
        //notify view of results, no results, no errors
        
    }
    /// It is responsible for making all API call for particular type whether its charcter,location,episode
    /// - Parameters:
    ///   - type: the type in which we are expecting the result in
    ///   - request: RMRequest it is simply
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request:RMRequest){
        RMService.shared.execute(request, expecting: type) { [weak self]result in
            switch result {
            case .success(let model):
                self?.processSearchResults(model: model)
            case .failure:
                self?.handleNoResults()
            }
        }
    }
    
    private func processSearchResults(model: Codable){
        var resultsVM: RMSearchResultViewModel?
        if let characterResult = model as? RMGetAllCharactersResponse{
            resultsVM = .characters(characterResult.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                                              characterStatus: $0.status,
                                                              characterImageURL: URL(string: $0.image))
            }))
        }
        else if let episodeResult = model as? RMGetAllEpisodesResponse{
            resultsVM = .episodes(episodeResult.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataURL: URL(string:$0.url))
            }))
        }
        else if let locationResult = model as? RMGetAllLocationsResponse{
            resultsVM = .locations(locationResult.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
        }
        if let results = resultsVM{
            self.searchResultModel = model
            self.searchResultHandler?(results)
        }
        else{
            //No matching results means show -: NO result view
            handleNoResults()
        }
    }
    
    private func handleNoResults(){
        noResultsHandler?()
    }
    
    public func locationSearchResult(at index: Int)->RMLocation?{
        guard let searchModel = searchResultModel as? RMGetAllLocationsResponse else{
            return nil
        }
        return searchModel.results[index]
    }
}
