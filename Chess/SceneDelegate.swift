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

final class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 64
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let item = indexPath.row
        if item % 2 == 0 {
            cell.backgroundColor = .blue
        } else {
            cell.backgroundColor = .red
        }
        return cell
    }

    private let boardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .purple
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()

    override func viewDidLayoutSubviews() {
        setupDelegates()
        setupViewStyle()
        setupViewHierarchy()
        setupViewConstraints()
    }

    private func setupViewStyle() {
        view.backgroundColor = .systemGray
    }

    private func setupViewHierarchy() {
        view.addSubview(boardCollectionView)
    }

    private func setupViewConstraints() {
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let margin = 20.0
        let width = view.frame.width - 2 * margin

        NSLayoutConstraint.activate([
            boardCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            boardCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
            boardCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
            boardCollectionView.heightAnchor.constraint(equalToConstant: width)
        ])
    }

    private func setupDelegates() {
        boardCollectionView.delegate = self
        boardCollectionView.dataSource = self
    }
}
