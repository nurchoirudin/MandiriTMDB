//
//  MovieDetailProtocols.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 12/02/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol MovieDetailViewProtocol: AnyObject {
    var presenter: MovieDetailPresenterProtocol? { get set }
    var loadingState: BehaviorRelay<LoadingState> { get set }
    var model: ResponseMovieByGenreModel.Result? { get set }
    var request: RequestMovieDetailModel? { get set }
    var requestReview: RequestReviewModel? { get set }
    var isLoadmore: Bool { get set }

    var detailModel: ResponseMovieDetailModel? { get set }
    var reviewModel: ResponseReviewModel? { get set }
    var reviewResultModel: [ResponseReviewModel.Result]? { get set }
    
    var requestVideo: RequestVideoModel? { get set }
    var videoModel: ResponseVideoModel? { get set}

    func didSuccess(_ model: ResponseMovieDetailModel?)
    func didFail(message: String?)
    func didSuccessGetReview(_ model: ResponseReviewModel?)
    func didFailGetReview(message: String?)
    func didSuccessGetVideo(_ model: ResponseVideoModel?)
    func didFailGetVideo(message: String?)
}

protocol MovieDetailPresenterProtocol: AnyObject {
    var view: MovieDetailViewProtocol? { get set }
    var interactor: MovieDetailInteractorInputProtocol? { get set }
    var router: MovieDetailRouterProtocol? { get set }
    func getMovieDetail(request: RequestMovieDetailModel?)
    func loadMoreReview(request: RequestReviewModel?)

}

protocol MovieDetailInteractorInputProtocol: AnyObject {
    var presenter: MovieDetailInteractorOutputProtocol? { get set }
    func getMovieDetail(request: RequestMovieDetailModel) -> Observable<ResponseMovieDetailModel?>
    func getMovieReview(request: RequestReviewModel) -> Observable<ResponseReviewModel?>
    func getMovieVideo(request: RequestVideoModel) -> Observable<ResponseVideoModel?>

}

protocol MovieDetailInteractorOutputProtocol: AnyObject{
    func didSuccessGetMovie(model: ResponseMovieDetailModel?)
    func didSuccessGetReview(model: ResponseReviewModel?)
    func didSuccessGetVideo(model: ResponseVideoModel?)
    func didFailGetReview(message: String?)
    func didFailGetMovie(message: String?)
    func didFailGetVideo(message: String?)
}

protocol MovieDetailRouterProtocol: AnyObject {
    static func createMovieDetailModule(with model: ResponseMovieByGenreModel.Result?) -> UIViewController
}
