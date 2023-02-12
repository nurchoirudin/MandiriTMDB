//
//  MainViewRouter.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 11/02/23.
//

import UIKit

class MainViewRouter: MainViewRouterProtocol {
    static func createMainViewModule() -> UIViewController {
        let view = MainViewController.loadFromNib()
        let presenter = MainViewPresenter()
        
        let interactor = MainViewInteractor(remoteData: NetworkProvider())
        let router = MainViewRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
    
    func presentMovieByGenre(from view: MainViewProtocol, for model: ResponseGenreModel.Genre?) {
        let goToMovieListByGenre = MovieListRouter.createMovieListModule(with: model)
        guard let viewVC = view as? UIViewController else {
            fatalError("Invalid View Protocol type")
        }
        viewVC.navigationController?.pushViewController(goToMovieListByGenre, animated: true)
    }
}
