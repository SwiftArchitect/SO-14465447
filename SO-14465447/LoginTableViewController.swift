//
//  LoginTableViewController.swift
//  SO-14465447
//
//  Copyright © 2017 Xavier Schott
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

class LoginTableViewLabelCell : UITableViewCell {
    @IBOutlet weak var label: UILabel!
}

// Binding class
class LoginTableViewTextFieldCell : UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!

    // Adapters
    var textFieldShouldReturnAdapter: ((_ textField: UITextField) -> Bool)? = nil
    var textFieldDidChangeAdapter: ((_ textField: UITextField) -> Void)? = nil

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textFieldShouldReturnAdapter = textFieldShouldReturnAdapter {
            return textFieldShouldReturnAdapter(textField)
        }
        return true
    }

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if let textFieldDidChangeAdapter = textFieldDidChangeAdapter {
            textFieldDidChangeAdapter(textField)
        }
    }
}

class LoginTableViewController: UITableViewController {
    let kCellCount = 6; // 0, 1, 3, 5 are ornaments, 2 & 4 are LoginTableViewTextFieldCell

    var username:String?
    var password:String?
    var passwordTextfield:UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use Autolayout to handle size
        self.tableView.estimatedRowHeight = 88
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    @IBAction func loginAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        print("username = \(username ?? ""), password = \(password ?? "")")
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kCellCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Keep cells containing user data in a cache
        switch indexPath.row {

        case 2: // User Name
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath) as! LoginTableViewTextFieldCell
            cell.textField.text = self.username // Initialize

            // Tab to password on [Next]
            cell.textFieldShouldReturnAdapter = { (textField: UITextField) -> Bool in
                if let passwordTextfield = self.passwordTextfield {
                    passwordTextfield.becomeFirstResponder()
                }
                return true
            }

            // Store text as it changes
            cell.textFieldDidChangeAdapter = { (textField: UITextField) -> Void in
                self.username = textField.text
            }
            return cell

        case 4: // Password
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath) as! LoginTableViewTextFieldCell
            cell.textField.text = self.password // Initialize
            self.passwordTextfield = cell.textField // Remember for [Next]

            // Log in on [Return]
            cell.textFieldShouldReturnAdapter = { (textField: UITextField) -> Bool in
                self.loginAction(textField)
                return true
            }

            // Store text as it changes
            cell.textFieldDidChangeAdapter = { (textField: UITextField) -> Void in
                self.password = textField.text
            }
            return cell

        default:
            return tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.row)", for: indexPath)
        }
    }
}
