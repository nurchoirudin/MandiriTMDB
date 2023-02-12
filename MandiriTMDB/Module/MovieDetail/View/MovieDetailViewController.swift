//
//  MovieDetailViewController.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 12/02/23.
//

import UIKit
import RxCocoa
import RxSwift
import SafariServices

class MovieDetailViewController: UIViewController {
    var presenter: MovieDetailPresenterProtocol?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    var loadingState = BehaviorRelay<LoadingState>(value: .notLoad)
    var model: ResponseMovieByGenreModel.Result?
    var request: RequestMovieDetailModel?
    var requestReview: RequestReviewModel?
    var detailModel: ResponseMovieDetailModel?
    var reviewModel: ResponseReviewModel?
    var reviewResultModel: [ResponseReviewModel.Result]?
    var isLoadmore: Bool = false {
        didSet {
            if self.isLoadmore {
                guard let page = requestReview?.page else {
                    return
                }
                self.requestReview?.page = page + 1
                self.presenter?.loadMoreReview(request: requestReview)
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    var requestVideo: RequestVideoModel?
    var videoModel: ResponseVideoModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTableView()
        configureCollectionView()
        bindView()
    }
    
    private func configureTableView(){
        var nibName = UINib(nibName: String(describing: MovieReviewCell.self), bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
        nibName = UINib(nibName: String(describing: MovieReviewCell.self), bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: String(describing: MovieReviewCell.self))
    }
    
    private func configureCollectionView(){
        var nibName = UINib(nibName: String(describing: MovieMediaCell.self), bundle: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
        nibName = UINib(nibName: String(describing: MovieMediaCell.self), bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: String(describing: MovieMediaCell.self))
    }
    
    private func bindView(){
        if let model = model {
            request = RequestMovieDetailModel(movieId: model.id, apiKey: NetworkConfiguration.apiKey)
            requestReview = RequestReviewModel(movieId: model.id, apiKey: NetworkConfiguration.apiKey)
            requestVideo = RequestVideoModel(movieId: model.id, apiKey: NetworkConfiguration.apiKey)
            presenter?.getMovieDetail(request: request)
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
                        self.collectionView.reloadData()
                    }
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func watchTrailer(_ sender: Any) {
        let urlString = "https://www.hackingwithswift.com"

        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            
            self.present(vc, animated: true)
        }
    }
}

extension MovieDetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = reviewResultModel?.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieReviewCell.self), for: indexPath) as? MovieReviewCell else {
            return UITableViewCell()
        }
        if let model = reviewResultModel {
            cell.configureCell(model: model[indexPath.row])
        }
        return cell
    }
          
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let model = reviewResultModel, let total = reviewModel?.totalResults {
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
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.videoModel?.results?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieMediaCell.self), for: indexPath) as? MovieMediaCell else {
            return UICollectionViewCell()
        }
        
        if let model = videoModel {
            cell.configureCell(model.results?[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension MovieDetailViewController: MovieDetailViewProtocol {
    func didSuccessGetVideo(_ model: ResponseVideoModel?) {
        self.videoModel = model
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didFailGetVideo(message: String?) {
        self.showError(title: "Error", message: message ?? "")
    }
    
    func didSuccessGetReview(_ model: ResponseReviewModel?) {
        if isLoadmore == false {
            self.reviewModel = model
            self.reviewResultModel = model?.results
        } else {
            guard let result = model?.results else { return }
            for data in result {
                self.reviewResultModel?.append(data)
            }
            isLoadmore = false
        }
    }
    
    func didFailGetReview(message: String?) {
        self.showError(title: "Error", message: message ?? "")
    }
    
    func didSuccess(_ model: ResponseMovieDetailModel?) {
        detailModel = model
        if let detailModel = self.detailModel {
            DispatchQueue.main.async {
                self.movieTitleLabel.text = detailModel.title
                self.movieOverviewLabel.text = detailModel.overview
                if let poster = detailModel.posterPath {
                    self.moviePosterImageView.setImage("https://www.themoviedb.org/t/p/w440_and_h660_face\(poster)")
                }
            }
        }
    }
    
    func didFail(message: String?) {
        self.showError(title: "Error", message: message ?? "")
    }
}
