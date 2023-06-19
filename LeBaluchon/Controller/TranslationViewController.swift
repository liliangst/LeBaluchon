//
//  TranslationViewController.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 30/05/2023.
//

import UIKit

class TranslationViewController: UIViewController {
    
    // Source Language
    @IBOutlet weak var sourceLanguageLabel: UILabel! {
        didSet {
            sourceLanguageLabel.text = "Français"
        }
    }
    @IBOutlet weak var sourceLanguageInput: UITextView!
    
    // Target Language
    @IBOutlet weak var targetLanguageLabel: UILabel! {
        didSet {
            targetLanguageLabel.text = "Anglais"
        }
    }
    @IBOutlet weak var targetLanguageOutput: UITextView!
    
    @IBOutlet weak var translateButton: UIButton! {
        didSet {
            translateButton.isEnabled = false
        }
    }
    @IBOutlet weak var translationActivityIndicator: UIActivityIndicatorView! {
        didSet {
            translationActivityIndicator.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        sourceLanguageInput.delegate = self
    }
    
    @IBAction func tapDismissKeyboard(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    
    @IBAction func tapTranslateButton() {
        dismissKeyboard()
        callTranslationService()
    }
    
    func dismissKeyboard() {
        sourceLanguageInput.resignFirstResponder()
    }
}

extension TranslationViewController {
    func callTranslationService() {
        TranslationService.shared.fetchTranslationData(source: "fr", target: "en", text: sourceLanguageInput.text) { result in
            switch result {
            case .success(let translationData):
                self.targetLanguageOutput.text = translationData.text
            case .failure(let error):
                self.displayError(error)
            }
        }
    }
}

extension TranslationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text, !text.isEmpty else {
            translateButton.isEnabled = false
            return
        }
        translateButton.isEnabled = true
    }
}

extension TranslationViewController {
    func displayError(_ error: TranslationServiceError) {
        switch error {
        case .noData:
            displayAlert("Il y a eu une erreur lors de la réception des données.")
        case .wrongStatusCode:
            displayAlert("Il y a eu une erreur côté serveur.")
        case .decodingError:
            displayAlert("Il y a eu une erreur lors du décodage des données.")
        }
    }

    private func displayAlert(_ text: String) {
        let alertVC = UIAlertController(title: "Oups!",
                                        message: text, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "Réessayer", style: .default, handler: { _ in
            self.callTranslationService()
        }))
        return self.present(alertVC, animated: true, completion: nil)
    }
}
