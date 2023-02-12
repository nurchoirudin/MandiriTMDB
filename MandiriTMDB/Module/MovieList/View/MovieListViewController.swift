//
//  MovieListViewController.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 12/02/23.
//

import UIKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var presenter: MovieListPresenterProtocol?
    var loadingState = BehaviorRelay<LoadingState>(value: .notLoad) 
    var genreModel: ResponseGenreModel.Genre?
    var movieListModel: ResponseMovieByGenreModel?
    var request: RequestMovieByGenreModel?
    var movieListResultModel: [ResponseMovieByGenreModel.Result]?
    var isLoadmore: Bool = false {
        didSet {
            if self.isLoadmore {
                guard let page = request?.page else {
                    return
                }
                self.request?.page = page + 1
                if let request = request {
                    self.presenter?.getMovieByGenre(request: request)
                }
            }
        }
    }
    
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindView()
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: String(describing: MovieCell.self), bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: String(describing: MovieCell.self))
    }
    
    private func bindView(){
        if let model = genreModel {
            request = RequestMovieByGenreModel(withGenres: model.id, apiKey: NetworkConfiguration.apiKey)
            if let request = request {
                presenter?.getMovieByGenre(request: request)
            }
        }
        self.loadingState.asObservable().observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading, .notLoad:
                    break
                case .finished, .failed:
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else { return }
                        self.tableView.hideLoadingFooter()
                        self.tableView.reloadData()
                    }
                    break
                }
            }).disposed(by: disposeBag)
    }
    
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = movieListResultModel?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieCell.self), for: indexPath) as? MovieCell else { return UITableViewCell() }
        if let model = movieListResultModel {
            cell.configureCell(model: model[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let model = movieListResultModel, let total = movieListModel?.totalResults {
            let lastElement = model.count - 1
            let count = model.count
            if indexPath.row == lastElement {
                if !self.isLoadmore && count > 0 {
                    if count < total {
                        tableView.showLoadingFooter()
                        self.isLoadmore = true
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let model = movieListResultModel {
            presenter?.goToMovieDetail(model: model[indexPath.row])
        }
    }

}

extension MovieListViewController: MovieListViewProtocol {
    func didSuccess(_ model: ResponseMovieByGenreModel?) {
        if isLoadmore == false {
            movieListModel = model
            movieListResultModel = model?.results
        } else {
            guard let result = model?.results else { return }
            for data in result {
                movieListResultModel?.append(data)
            }
            isLoadmore = false
        }
    }
    
    func didFail(message: String?) {
        self.showError(title: "error", message: message ?? "")
    }
}
