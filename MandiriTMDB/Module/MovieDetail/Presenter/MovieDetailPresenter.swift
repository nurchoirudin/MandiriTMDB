//
//  MovieDetailPresenter.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 12/02/23.
//

import RxSwift
import RxCocoa

final class MovieDetailPresenter: MovieDetailPresenterProtocol {
    weak var view: MovieDetailViewProtocol?
    var interactor: MovieDetailInteractorInputProtocol?
    var router: MovieDetailRouterProtocol?
    private let disposeBag = DisposeBag()
    
    func getMovieDetail(request: RequestMovieDetailModel?) {
        self.view?.loadingState.accept(.loading)
        guard let request = view?.request else { return }
        guard let requestReview = view?.requestReview else { return }
        guard let requestVideo = view?.requestVideo else { return }

        guard let getMovieDetail = interactor?.getMovieDetail(request: request) else { return }
        guard let getReviewMovie = interactor?.getMovieReview(request: requestReview) else { return }
        guard let getVideoModel = interactor?.getMovieVideo(request: requestVideo) else { return }
        
        Observable.zip(getMovieDetail, getReviewMovie, getVideoModel).map({
            if let movieDetailModel = $0.0 {
                self.didSuccessGetMovie(model: movieDetailModel)
            }
            if let reviewModel = $0.1 {
                self.didSuccessGetReview(model: reviewModel)
            }
            if let videoModel = $0.2 {
                self.didSuccessGetVideo(model: videoModel)
            }
        }).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.view?.loadingState.accept(.finished)
        }, onError: {[weak self] _ in
            guard let self = self else { return }
            self.view?.loadingState.accept(.failed)
        }).disposed(by: self.disposeBag)
    }
    
    func loadMoreReview(request: RequestReviewModel?){
        guard let request = request else {
            return
        }
        self.view?.loadingState.accept(.loading)
        interactor?.getMovieReview(request: request)
            .subscribe(onNext: { [weak self] responseModel in
                guard let self = self else { return }
                self.didSuccessGetReview(model: responseModel)
                self.view?.loadingState.accept(.finished)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.didFailGetReview(message: error.localizedDescription)
                self.view?.loadingState.accept(.failed)
            }).disposed(by: disposeBag)
    }
}

extension MovieDetailPresenter: MovieDetailInteractorOutputProtocol {
    func didSuccessGetVideo(model: ResponseVideoModel?) {
        self.view?.didSuccessGetVideo(model)
    }
    
    func didFailGetVideo(message: String?) {
        self.view?.didFailGetVideo(message: message)
    }
    
    func didSuccessGetReview(model: ResponseReviewModel?) {
        self.view?.didSuccessGetReview(model)
    }
    
    func didFailGetReview(message: String?) {
        self.view?.didFailGetReview(message: message)
    }
    
    func didSuccessGetMovie(model: ResponseMovieDetailModel?) {
        self.view?.didSuccess(model)
    }
    
    func didFailGetMovie(message: String?) {
        self.view?.didFail(message: message)
    }
}
