//
//  VideosListViewController.swift
//  dailymotion-tech-test
//
//  Created by Guillaume LAURES on 04/06/2022.
//

import Foundation
import UIKit

protocol VideosListView: AnyObject {

    func showLoading()
    func showContent()
}

final class VideosListViewController: UIViewController {


    private let table = UITableView()
    private let activity = UIActivityIndicatorView()
    private let emptyView = EmptyView()
    private var onGoingAnimation: UIViewPropertyAnimator?

    private let presenter: VideosListPresenter

    // MARK: - Init

    init(presenter: VideosListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Dailymotion"
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }

        setupEmptyView()
        setupTable()
        setupActivity()
        setupAutoLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.view = self
        presenter.start()
    }

    // MARK: - Views setup

    private func setupEmptyView() {

        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.refreshButtonAction = { [weak self] () in
            self?.presenter.start()
        }
        view.addSubview(emptyView)
    }

    private func setupTable() {

        table.register(VideoCell.self, forCellReuseIdentifier: VideoCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.isHidden = true
        view.addSubview(table)
    }

    private func setupActivity() {

        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activity)
    }

    private func setupAutoLayout() {

        let constraints = [
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension VideosListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case let .loaded(rows) = presenter.viewModel else { return 0 }
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = table.dequeueReusableCell(withIdentifier: VideoCell.identifier, for: indexPath) as? VideoCell,
              case let .loaded(rows) = presenter.viewModel else {
            return UITableViewCell()
        }
        cell.configure(with: rows[indexPath.row])
        return cell
    }
}

extension VideosListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        table.deselectRow(at: indexPath, animated: true)

    }
}

extension VideosListViewController: VideosListView {

    func showLoading() {

        onGoingAnimation?.stopAnimation(true)

        onGoingAnimation = fadeBetween(inView: activity, outView: emptyView)
        activity.startAnimating()
    }

    func showContent() {

        onGoingAnimation?.stopAnimation(true)
        guard let viewModel = presenter.viewModel else { return }

        let inView: UIView
        switch viewModel {
        case .loaded:
            table.reloadData()
            inView = table

        case .empty(let emptyViewModel):
            emptyView.configure(with: emptyViewModel)
            inView = emptyView
        }

        onGoingAnimation = fadeBetween(inView: inView, outView: activity)
    }
    
}
