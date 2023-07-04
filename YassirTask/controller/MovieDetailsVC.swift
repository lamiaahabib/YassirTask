//
//  MovieDetailsVC.swift
//  YassirTask
//
//  Created by lamiaa on 7/4/23.
//

import UIKit
import Kingfisher
class MovieDetailsVC: UIViewController {
    @IBOutlet weak var imgView: UIImageView?
    @IBOutlet weak var titleLbl: UILabel?
    @IBOutlet weak var reviewLbl: UITextView?
    @IBOutlet weak var dateLbl: UILabel?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    var id = 0
    lazy var viewModel: MovieDetailsVM = {
        return MovieDetailsVM()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
        initVM()
    }

    func initView() {
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
       
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    func initVM() {
        
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.viewModel.state {
                case .empty, .error:
                    self.activityIndicator?.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                      
                    })
                case .loading:
                    self.activityIndicator?.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
            
                    })
                case .populated:
                    self.activityIndicator?.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                    })
                }
            }
        }
        
        viewModel.reloadViewClosure = { [weak self] (result) in
            DispatchQueue.main.async {
           
                self?.activityIndicator?.stopAnimating()
                self?.reloadView(result: result!)
            }
        }
        loadListMovies()
    }
    func reloadView(result:Results)  {
        self.navigationItem.title = result.title
        self.imgView?.kf.setImage(with: URL(string:AppKey.imageURL + (result.poster_path ?? "")))
        self.dateLbl?.text = result.release_date
        self.titleLbl?.text = result.title
        self.reviewLbl?.text = result.overview
        
        
    }
    func loadListMovies()  {
        viewModel.initFetch(id:self.id )
    }
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}




