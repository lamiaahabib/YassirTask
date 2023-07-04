//
//  ViewController.swift
//  YassirTask
//
//  Created by lamiaa on 7/2/23.
//

import UIKit

class MoviesListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let movieCellIdentifier = "movieCell"
    lazy var viewModel: MoviesViewModel = {
        return MoviesViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
        initVM()
    }

    func initView() {
        self.navigationItem.title = "Popular Movies"
      
        view.isUserInteractionEnabled = true
        tableView.estimatedRowHeight = 190
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        let placenib = UINib.init(nibName: movieCellIdentifier , bundle: nil)
        self.tableView?.register(placenib, forCellReuseIdentifier: movieCellIdentifier)
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
                self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 0.0
                    })
                case .loading:
                 self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        //self.tableView.alpha = 0.0
                    })
                case .populated:
                 self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
           
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
        loadListMovies()
    }
    
    func loadListMovies()  {

          
            viewModel.initFetch()
           
            
    
    }
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MoviesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: movieCellIdentifier, for: indexPath) as? movieCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.movieCellViewModel = cellVM
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
        if indexPath.row == viewModel.numberOfCells - 1 { // last cell
            self.loadListMovies()
              }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsVC") as? MovieDetailsVC
            vc?.id =    cellVM.id
            self.navigationController?.pushViewController(vc!, animated: true)
        }
     
    }
}

