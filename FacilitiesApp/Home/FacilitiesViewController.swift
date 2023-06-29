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
        FacilityOptionTableViewCell.register(for: view)
        return view
    }()
    
    private lazy var spinnerView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
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
        addTableView()
        viewModel.screenDidLoad()
    }
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

// MARK: - UITableViewDelegate Methods
extension FacilitiesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getHeader(for: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectOption(at: indexPath)
    }
    
}

// MARK: - UITableViewDataSource Methods
extension FacilitiesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel.getCellViewModel(at: indexPath) else { return UITableViewCell() }
        let optionCell = FacilityOptionTableViewCell.dequeReusableCell(from: tableView, at: indexPath)
        optionCell.configure(with: cellViewModel)
        return optionCell
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
    
    func reloadOptions(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .fade)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
}
