//
//  MovieDetailsVM.swift
//  YassirTask
//
//  Created by lamiaa on 7/4/23.
//


import UIKit

class MovieDetailsVM: NSObject {
    
    let apiService: APIServiceProtocol
    private var movie: Results?
  

    
    // callback for interfaces
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    var reloadViewClosure: ((Results?)->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetch(id:Int) {
        state = .loading
 
        apiService.fetchMovieDetails(id: id) { [weak self] (success, movie, error) in
            guard let self = self else {
                return
            }
            
            guard error == nil else {
                self.state = .error
                self.alertMessage = error?.rawValue
                return
            }
            if movie != nil{
                self.processFetchedMovieDetails(movie: movie!)
                
            }
            self.state = .populated
        }
    }
    private func processFetchedMovieDetails( movie: Results ) {
        self.movie = movie // Cache
        self.reloadViewClosure?(movie)
    }
    
}
