//
//  MainViewPresenter.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 11/02/23.
//

import RxSwift
import RxCocoa

final class MainViewPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    var interactor: MainViewInteractorInputProtocol?
    var router: MainViewRouterProtocol?
    private let disposeBag = DisposeBag()
    
    func showMovieByGenre(model: ResponseGenreModel.Genre?){
        guard let view = view else { return }
        router?.presentMovieByGenre(from: view, for: model)
    }
    
    func getGenreMovie(request: RequestGenreModel) {
        view?.loadingState.accept(.loading)
        interactor?.getGenreMovie(request: request)
        .subscribe(onNext: { [weak self] responseModel in
            guard let self = self else { return }
            self.didSuccessGetGenre(model: responseModel)
            self.view?.loadingState.accept(.finished)
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.didFailGetGenre(message: error.localizedDescription)
            self.view?.loadingState.accept(.failed)
        }).disposed(by: disposeBag)
    }
}

extension MainViewPresenter: MainViewInteractorOutputProtocol {
    func didSuccessGetGenre(model: ResponseGenreModel?){
        self.view?.showGenreMovie(model)
    }
    
    func didFailGetGenre(message: String) {
        self.view?.showErrorMessage(message: message)
    }
}
