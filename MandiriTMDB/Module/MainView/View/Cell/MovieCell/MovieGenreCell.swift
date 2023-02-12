//
//  MovieGenreCell.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 12/02/23.
//

import UIKit

class MovieGenreCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(model: ResponseGenreModel.Genre?){
        genreLabel.text = model?.name
    }
    
}
