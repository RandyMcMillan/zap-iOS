//
//  Library
//
//  Created by Otto Suess on 25.07.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    @IBOutlet private weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        Style.Label.custom().apply(to: headerLabel)
        headerLabel.textColor = .white
    }
    
    var headerText: String? {
        didSet {
            headerLabel.text = headerText
        }
    }
}
