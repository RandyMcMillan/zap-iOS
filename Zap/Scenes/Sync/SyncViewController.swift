//
//  Zap
//
//  Created by Otto Suess on 09.04.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import ReactiveKit
import UIKit

extension UIStoryboard {
    static func instantiateSyncViewController(with viewModel: LightningService) -> SyncViewController {
        let syncViewController = Storyboard.sync.initial(viewController: SyncViewController.self)
        syncViewController.viewModel = viewModel
        return syncViewController
    }
}

class SyncViewController: UIViewController {
    @IBOutlet private weak var syncLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var progressBar: UIProgressView!
    
    fileprivate var viewModel: LightningService?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Style.label.apply(to: syncLabel, dateLabel)
        syncLabel.textColor = .white
        dateLabel.textColor = .lightGray
                
        guard let viewModel = viewModel else { fatalError("viewModel not set.") }
        
        let percentSignal = combineLatest(viewModel.infoService.blockHeight, viewModel.infoService.blockChainHeight) { blockHeigh, maxBlockHeight -> Double in
            guard let maxBlockHeight = maxBlockHeight else { return 0 }
            return Double(blockHeigh) / Double(maxBlockHeight)
        }
        
        percentSignal
            .map { "Syncing \(Int($0 * 100))%" }
            .bind(to: syncLabel.reactive.text)
            .dispose(in: reactive.bag)
        
        percentSignal
            .map { Float($0) }
            .bind(to: progressBar.reactive.progress)
            .dispose(in: reactive.bag)
        
        viewModel.infoService.bestHeaderDate
            .map {
                if let date = $0 {
                    return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
                } else {
                    return ""
                }
            }
            .bind(to: dateLabel.reactive.text)
            .dispose(in: reactive.bag)
    }
}
