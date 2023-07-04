//
//  MoviesViewModel.swift
//  YassirTask
//
//  Created by lamiaa on 7/3/23.
//

import UIKit

class MoviesViewModel: NSObject {
    
    let apiService: APIServiceProtocol
    private var movies: [Results] = [Results]()
    var page:Int = 0
    private var cellViewModels: [MovieCellViewModel] = [MovieCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
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
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetch() {
        state = .loading
        page += 1
        apiService.fetchMoves(page: page) { [weak self] (success, moves, error) in
            guard let self = self else {
                return
            }
            
            guard error == nil else {
                self.state = .error
                self.alertMessage = error?.rawValue
                return
            }
            
            self.processFetchedMovies(movies: moves!)
            self.state = .populated
        }
    }
    
    
    func getCellViewModel( at indexPath: IndexPath ) -> MovieCellViewModel {
        return cellViewModels[indexPath.row]
    }

    func createCellViewModel( result: Results ) -> MovieCellViewModel {


        return MovieCellViewModel(titleText: result.title ?? "", dateText: result.release_date ?? "", voteText: "\(result.vote_average ?? 0)", id: result.id ?? 0, imageUrlText: AppKey.imageURL + (result.poster_path ?? ""))
    }

    private func processFetchedMovies( movies: [Results] ) {
        self.movies += movies // Cache
        var vms = [MovieCellViewModel]()
        for movie in  self.movies {
            vms.append( createCellViewModel(result: movie) )
        }
        self.cellViewModels = vms
    }
    
}
