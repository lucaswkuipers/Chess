import UIKit

protocol GenericViewControllerDelegate {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillLayoutSubviews()
    func viewDidLayoutSubviews()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

extension GenericViewControllerDelegate {
    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewWillLayoutSubviews() {}
    func viewDidLayoutSubviews() {}
    func viewDidAppear() {}
    func viewWillDisappear() {}
    func viewDidDisappear() {}
}

final class GenericViewController: UIViewController {
    var delegate: GenericViewControllerDelegate?
    var screen: UIView?

    init(with screen: UIView) {
        self.screen = screen
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
        self.view = screen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.viewWillAppear()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        delegate?.viewWillLayoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        delegate?.viewDidLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.viewWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.viewDidDisappear()
    }
}

