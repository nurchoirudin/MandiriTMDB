//
//  MovieDetailRouter.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 12/02/23.
//

import UIKit

class MovieDetailRouter: MovieDetailRouterProtocol {
    static func createMovieDetailModule(with model: ResponseMovieByGenreModel.Result?) -> UIViewController {
        let view = MovieDetailViewController.loadFromNib()
        let presenter = MovieDetailPresenter()
        let interactor = MovieDetailInteractor(remoteData: NetworkProvider())
        let router = MovieDetailRouter()
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        view.model = model
        return view
    }
}
