//
//  MainViewController.swift
//  Mandiri TMDB Test
//
//  Created by SehatQ on 11/02/23.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    var presenter: MainViewPresenterProtocol?
    var loadingState = BehaviorRelay<LoadingState>(value: .notLoad)
    @IBOutlet weak var tableView: UITableView!
    var model: ResponseGenreModel? = nil {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.setupNavigationWithLeftTitle(title: "")
        configureTableView()
        bindViewModel()
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: String(describing: MovieGenreCell.self), bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: String(describing: MovieGenreCell.self))
    }
    
    private func bindViewModel(){
        presenter?.getGenreMovie(request: RequestGenreModel(apiKey: NetworkConfiguration.apiKey))
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.genres?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieGenreCell.self)) as? MovieGenreCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if let genre = model {
            cell.configureCell(model: genre.genres?[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let genre = model {
            presenter?.showMovieByGenre(model: genre.genres?[indexPath.row])
        }
    }

}

extension MainViewController: MainViewProtocol {
    func showGenreMovie(_ model: ResponseGenreModel?){
        self.model = model
    }
    
    func showErrorMessage(message: String){
        self.showError(title: "Error", message: message)
    }
}
