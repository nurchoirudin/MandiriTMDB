//
//  MovieReviewCell.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 12/02/23.
//

import UIKit

class MovieReviewCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(model: ResponseReviewModel.Result){
        authorLabel.text = model.author
        contentLabel.text = model.content
    }
}
