
import UIKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) // WebViewViewController получил код
    func webViewViewControllerDidCancell(_ vc: WebViewViewController) // пользователь нажал кнопку назад и отменил авторизацию
}
