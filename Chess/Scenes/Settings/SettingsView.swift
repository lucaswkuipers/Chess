import UIKit

final class SettingsView: UIView {
    private let rotationAnimationSettingView = RotationAnimationSettingView()

    init() {
        super.init(frame: .zero)
        setupViewStyle()
        setupViewHierarchy()
        setupViewConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViewStyle() {
        backgroundColor = .systemBackground
    }

    func setupViewHierarchy() {
        addSubview(rotationAnimationSettingView)
    }

    private func setupViewConstraints() {
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            rotationAnimationSettingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            rotationAnimationSettingView.leftAnchor.constraint(equalTo: leftAnchor),
            rotationAnimationSettingView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}

extension SettingsView: SettingsViewProtocol {}

final class RotationAnimationSettingView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Animate piece rotation"
        return label
    }()

    private let animationSwitch: UISwitch = {
        let _switch = UISwitch()
        return _switch
    }()

    init() {
        super.init(frame: .zero)
        setupViewStyle()
        setupViewHierarchy()
        setupViewConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViewStyle() {
        backgroundColor = .secondarySystemBackground
    }

    private func setupViewHierarchy() {
        addSubview(titleLabel)
        addSubview(animationSwitch)
    }

    private func setupViewConstraints() {
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

            animationSwitch.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 20),
            animationSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationSwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ])
    }
}
