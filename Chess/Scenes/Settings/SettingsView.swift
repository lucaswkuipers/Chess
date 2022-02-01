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

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "Duration in seconds"
        return label
    }()

    private let durationSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 2
        return slider
    }()

    init() {
        super.init(frame: .zero)
        setupViewStyle()
        setupViewHierarchy()
        setupViewConstraints()
        setupEvents()
        setupSwitchState()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func valueDidChange(_ sender: UISwitch) {
        PreferencesManager.shared.save(isRotationAnimated: sender.isOn)
    }

    private func setupViewStyle() {
        backgroundColor = .secondarySystemBackground
    }

    private func setupViewHierarchy() {
        addSubview(titleLabel)
        addSubview(animationSwitch)
        addSubview(durationLabel)
        addSubview(durationSlider)
    }

    private func setupViewConstraints() {
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),

            animationSwitch.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 20),
            animationSwitch.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            animationSwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            durationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            durationLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            durationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            durationSlider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            durationSlider.leftAnchor.constraint(equalTo: durationLabel.rightAnchor, constant: 20),
            durationSlider.rightAnchor.constraint(equalTo: rightAnchor, constant: -100),
            durationSlider.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor),
            durationSlider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }

    private func setupEvents() {
        animationSwitch.addTarget(self, action: #selector(valueDidChange(_:)), for: .valueChanged)
    }

    private func setupSwitchState() {
        animationSwitch.isOn = PreferencesManager.shared.isRotationAnimated()
    }
}
