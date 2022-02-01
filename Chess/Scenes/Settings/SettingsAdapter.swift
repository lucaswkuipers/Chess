protocol SettingsViewProtocol {}

final class SettingsAdapter {
    var view: SettingsViewProtocol?
    var viewController: GenericViewController?
}

extension SettingsAdapter: GenericViewControllerDelegate {}
