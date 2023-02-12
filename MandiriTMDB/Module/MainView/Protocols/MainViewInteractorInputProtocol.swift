//
//  MainViewInteractorInputProtocol.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 12/02/23.
//

import RxSwift

protocol MainViewInteractorInputProtocol: AnyObject {
    var presenter: MainViewInteractorOutputProtocol? { get set }
    func getGenreMovie(request: RequestGenreModel) -> Observable<ResponseGenreModel?>
}
