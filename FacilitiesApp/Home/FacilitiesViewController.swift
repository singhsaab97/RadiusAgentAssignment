//
//  FacilitiesViewController.swift
//  FacilitiesApp
//
//  Created by Abhijit Singh on 28/06/23.
//

import UIKit
import SnapKit

final class FacilitiesViewController: UIViewController {
    
    private struct Style {
        static let backgroundColor = UIColor.systemBackground
        static let tableViewBackgroundColor = UIColor.clear
    }
        
    private let viewModel: FacilitiesViewModelable
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(), style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Style.tableViewBackgroundColor
        view.rowHeight = UITableView.automaticDimension
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var spinnerView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()
    
    init(viewModel: FacilitiesViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private Helpers
private extension FacilitiesViewController {
    
    func setup() {
        view.backgroundColor = Style.backgroundColor
        addBookButton()
        addTableView()
        viewModel.screenDidLoad()
    }
    
    func addBookButton() {
        let bookButton = UIBarButtonItem(
            title: viewModel.bookButtonTitle,
            style: .plain,
            target: self,
            action: #selector(bookButtonTapped)
        )
        navigationItem.rightBarButtonItem = bookButton
    }
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc
    func bookButtonTapped() {
        
    }
    
}

// MARK: - UITableViewDelegate Methods
extension FacilitiesViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource Methods
extension FacilitiesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

// MARK: - FacilitiesViewModelPresenter Methods
extension FacilitiesViewController: FacilitiesViewModelPresenter {
    
    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func startLoading() {
        view.addSubview(spinnerView)
        spinnerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        spinnerView.startAnimating()
    }
    
    func stopLoading() {
        spinnerView.stopAnimating()
        spinnerView.removeFromSuperview()
    }
    
}
