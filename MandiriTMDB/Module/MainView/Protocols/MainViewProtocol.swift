//
//  MainViewProtocol.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 11/02/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol MainViewProtocol: AnyObject {
    var presenter: MainViewPresenterProtocol? { get set }
    func showGenreMovie(_ model: ResponseGenreModel?)
    func showErrorMessage(message: String)
    var loadingState: BehaviorRelay<LoadingState> { get set }
}

protocol MainViewPresenterProtocol: AnyObject {
    
    var view: MainViewProtocol? { get set }
    var interactor: MainViewInteractorInputProtocol? { get set }
    var router: MainViewRouterProtocol? { get set }

    func getGenreMovie(request: RequestGenreModel)
    func showMovieByGenre(model: ResponseGenreModel.Genre?)
}

protocol MainViewInteractorOutputProtocol: AnyObject{
    func didSuccessGetGenre(model: ResponseGenreModel?)
    func didFailGetGenre(message: String)
}

protocol MainViewRouterProtocol: AnyObject {    
    static func createMainViewModule() -> UIViewController
    func presentMovieByGenre(from view: MainViewProtocol, for model: ResponseGenreModel.Genre?)
}
