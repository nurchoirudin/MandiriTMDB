//
//  MovieCell.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 12/02/23.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(model: ResponseMovieByGenreModel.Result?){
        if let model = model {
            if let poster = model.posterPath {
                movieImageView.setImage("https://www.themoviedb.org/t/p/w440_and_h660_face\(poster)")
            }
            movieTitleLabel.text = model.title
            movieOverviewLabel.text = model.overview
        }
    }
}
