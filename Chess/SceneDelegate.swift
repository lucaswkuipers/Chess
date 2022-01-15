import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }
}

final class ViewController: UIViewController {
    private var hasSetupView = false
    private let boardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .brown
        view.clipsToBounds = true
        return view
    }()

    private let rowsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = .zero
        stack.distribution = .fillEqually
        stack.clipsToBounds = true
        return stack
    }()


    override func viewDidLayoutSubviews() {
        if hasSetupView { return }
        setupViewStyle()
        setupViewHierarchy()
        setupViewConstraints()
        hasSetupView = true
    }

    private func setupViewStyle() {
        view.backgroundColor = .systemGray
    }

    private func setupViewHierarchy() {
        view.addSubview(boardView)
        boardView.addSubview(rowsStackView)

        if !rowsStackView.arrangedSubviews.isEmpty { return }

        let numberOfRows = 8
        let numberOfColumns = 8
        for numberOfRow in 1...numberOfRows {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = .zero
            stack.distribution = .fillEqually
            stack.clipsToBounds = true
            for numberOfColumn in 1...numberOfColumns {
                let view = UIView()
                view.clipsToBounds = true
                view.backgroundColor = (numberOfColumn + numberOfRow) % 2 == 0 ? .white : .darkGray
                stack.addArrangedSubview(view)
            }
            rowsStackView.addArrangedSubview(stack)
        }
    }

    private func setupViewConstraints() {
        boardView.translatesAutoresizingMaskIntoConstraints = false
        rowsStackView.translatesAutoresizingMaskIntoConstraints = false

        let margin = 15.0
        let width = view.frame.width - 2 * margin
        let height = view.frame.height - 2 * margin

        let smallestDimension = min(width, height)

        NSLayoutConstraint.activate([
            boardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boardView.heightAnchor.constraint(equalToConstant: smallestDimension),
            boardView.widthAnchor.constraint(equalToConstant: smallestDimension),

            rowsStackView.topAnchor.constraint(equalTo: boardView.topAnchor, constant: 20),
            rowsStackView.leftAnchor.constraint(equalTo: boardView.leftAnchor, constant: 20),
            rowsStackView.bottomAnchor.constraint(equalTo: boardView.bottomAnchor, constant: -20),
            rowsStackView.rightAnchor.constraint(equalTo: boardView.rightAnchor, constant: -20)
        ])
    }
}
