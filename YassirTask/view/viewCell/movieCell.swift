//
//  movieCell.swift
//  YassirTask
//
//  Created by lamiaa on 7/3/23.
//

import UIKit
import Kingfisher
class movieCell: UITableViewCell {
    @IBOutlet weak var imgMovie: UIImageView?
    @IBOutlet weak var titleMovie: UILabel?
    @IBOutlet weak var dateRelease: UILabel?
    @IBOutlet weak var voteAverage: UILabel?
    var movieCellViewModel : MovieCellViewModel? {
        didSet {
            titleMovie?.text = movieCellViewModel?.titleText
            dateRelease?.text = movieCellViewModel?.dateText
            
            voteAverage?.text = movieCellViewModel?.voteText

            imgMovie?.kf.setImage(with: URL(string: movieCellViewModel?.imageUrlText ?? ""))
            imgMovie?.kf.indicatorType = .activity
        }
    }
    
}
