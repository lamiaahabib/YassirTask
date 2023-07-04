//
//  APIService.swift
//  YassirTask
//
//  Created by lamiaa on 7/2/23.
//

import Foundation
import Alamofire

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}
protocol APIServiceProtocol {
    func fetchMoves(  page:Int,complete: @escaping ( _ success: Bool, _ moves: [Results]?, _ error: APIError? )->() )
    func fetchMovieDetails(  id:Int,complete: @escaping ( _ success: Bool, _ movie: Results?, _ error: APIError? )->() )
}
func getHeaders() -> HTTPHeaders {
    let headers:HTTPHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer \(AppKey.AuthKey)"
    ]
    return headers
}
func getParameters() -> Parameters {
    let paramters:Parameters = [
        "language": "en-US",
        "api_key": AppKey.AuthKey,
    ]
    return paramters
}
class APIService: APIServiceProtocol {
    func fetchMoves( page:Int,complete: @escaping ( _ success: Bool, _ moves: [Results]?, _ error: APIError?)->()) {
        var paramters:Parameters =  getParameters()
        if page >= 1{
            paramters.updateValue(page, forKey: "page")
            
        }
        let urlComponents = NSURL(string: AppKey.MovieURL )! as URL
        let request = AF.request(urlComponents,method: .get,parameters: paramters,headers: getHeaders())
        request.responseJSON { (data) in
            switch data.result{
            case .success(let json):
                              print(json)
                print("Response", data)
                let result = try? JSONDecoder().decode(MoviesModel.self, from: data.data!)
                
                complete(true, (result?.results), nil)
                          case .failure(let error):
                              print(error)
                complete(false,[],.noNetwork)
                          }
            }
    }
    
    func fetchMovieDetails( id:Int,complete: @escaping ( _ success: Bool, _ movie: Results?, _ error: APIError?)->()) {
        let urlComponents = NSURL(string: AppKey.MovieDetailsURL + "\(id)" )! as URL
        let request = AF.request(urlComponents,method: .get,parameters: getParameters(),headers: getHeaders())
        request.responseJSON { (data) in
            switch data.result{
            case .success(let json):
                              print(json)
                print("Response", data)
                let result = try? JSONDecoder().decode(Results.self, from: data.data!)
                complete(true, (result!), nil)
                          case .failure(let error):
                              print(error)
                complete(false,nil,.noNetwork)
                          }
            }
    }
}
