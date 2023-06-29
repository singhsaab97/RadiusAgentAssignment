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
        
        static let actionButtonTintColor = Constants.primaryColor
        
        static let tableViewBackgroundColor = UIColor.clear
        static let tableViewCellHeight = UITableView.automaticDimension
        
        static let popupViewHorizontalInset: CGFloat = 40
        static let fadeAnimationDuration: TimeInterval = 0.3
        static let scaleAnimationDuration: TimeInterval = 0.5
    }
        
    private let viewModel: FacilitiesViewModelable
    
    private lazy var selectButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: viewModel.selectButtonTitle,
            style: .plain,
            target: self,
            action: #selector(selectButtonTapped)
        )
        button.tintColor = Style.actionButtonTintColor
        button.isEnabled = viewModel.isSelectButtonEnabled
        return button
    }()
    
    private lazy var confirmButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: viewModel.confirmButtonTitle,
            style: .done,
            target: self,
            action: #selector(confirmButtonTapped)
        )
        button.tintColor = Style.actionButtonTintColor
        button.isEnabled = viewModel.isConfirmButtonEnabled
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(), style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Style.tableViewBackgroundColor
        view.rowHeight = Style.tableViewCellHeight
        view.delegate = self
        view.dataSource = self
        FacilityOptionTableViewCell.register(for: view)
        ErrorTableViewCell.register(for: view)
        return view
    }()
    
    private lazy var spinnerView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()
    
    private var overlayView: OverlayView {
        let view = OverlayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
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
        addActionButtons()
        addTableView()
        viewModel.screenDidLoad()
    }
    
    func addActionButtons() {
        navigationItem.leftBarButtonItem = selectButton
        navigationItem.rightBarButtonItem = confirmButton
    }
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc
    func selectButtonTapped() {
        viewModel.selectButtonTapped()
    }
    
    @objc
    func confirmButtonTapped() {
        viewModel.confirmButtonTapped()
    }
    
}

// MARK: - UITableViewDelegate Methods
extension FacilitiesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getHeader(for: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        guard viewModel.doesErrorExist else {
            guard let cellViewModel = viewModel.getFacilityCellViewModel(at: indexPath) else { return UITableViewCell() }
            let optionCell = FacilityOptionTableViewCell.dequeReusableCell(from: tableView, at: indexPath)
            optionCell.configure(with: cellViewModel)
            return optionCell
        }
        guard let cellViewModel = viewModel.getErrorCellViewModel(at: indexPath) else { return UITableViewCell() }
        let errorCell = ErrorTableViewCell.dequeReusableCell(from: tableView, at: indexPath)
        errorCell.configure(with: cellViewModel)
        return errorCell
    }
    
}

// MARK: - FacilitiesViewModelPresenter Methods
extension FacilitiesViewController: FacilitiesViewModelPresenter {
    
    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func updateSelectButtonTitle() {
        selectButton.title = viewModel.selectButtonTitle
    }
    
    func updateSelectButtonState() {
        selectButton.isEnabled = viewModel.isSelectButtonEnabled
    }
    
    func updateConfirmButtonState() {
        confirmButton.isEnabled = viewModel.isConfirmButtonEnabled
    }
    
    func updateActionButtonsState(isEnabled: Bool) {
        selectButton.isEnabled = isEnabled
        confirmButton.isEnabled = isEnabled
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
    
    func present(_ viewController: UIViewController) {
        navigationController?.present(viewController, animated: true)
    }
    
    func show(_ popupView: BookingConfirmationView, completion: @escaping () -> Void) {
        // Overlay
        let overlayView = overlayView
        view.addSubview(overlayView)
        overlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        overlayView.bringToParent(with: Style.fadeAnimationDuration)
        overlayView.onTap = { [weak overlayView, weak popupView] in
            overlayView?.removeFromParent(with: Style.fadeAnimationDuration)
            popupView?.removeFromParent(with: Style.fadeAnimationDuration) {
                completion()
            }
        }
        // Popup
        view.addSubview(popupView)
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Style.popupViewHorizontalInset)
            $0.centerY.equalToSuperview()
        }
        popupView.bringToParent(with: Style.scaleAnimationDuration)
    }
    
}
