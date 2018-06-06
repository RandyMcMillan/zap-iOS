//
//  Zap
//
//  Created by Otto Suess on 28.01.18.
//  Copyright © 2018 Otto Suess. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit

final class TransactionListViewModel: NSObject {
    let sections: MutableObservable2DArray<String, TransactionViewModel>
    
    init(viewModel: LightningService) {
        sections = MutableObservable2DArray()
        super.init()
        
        viewModel.transactionService.transactions
            .observeNext { [weak self] transactions in
                guard let result = self?.bondSections(transactions: transactions) else { return }
                let array = Observable2DArray(result)

                DispatchQueue.main.async {
                    self?.sections.replace(with: array)//, performDiff: true)
                }
            }
            .dispose(in: reactive.bag)
    }

    private func dateWithoutTime(from date: Date) -> Date {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
        return Calendar.current.date(from: components) ?? date
    }

    private func sortedSections(transactions: [TransactionViewModel]) -> [(Date, [TransactionViewModel])] {
        let grouped = transactions.grouped { transaction -> Date in
            self.dateWithoutTime(from: transaction.date)
        }

        return Array(zip(grouped.keys, grouped.values))
            .sorted { $0.0 > $1.0 }
    }

    private func bondSections(transactions: [TransactionViewModel]) -> [Observable2DArraySection<String, TransactionViewModel>] {
        let sortedSections = self.sortedSections(transactions: transactions)

        return sortedSections.compactMap {
            let sortedItems = $0.1.sorted { $0.date > $1.date }

            guard let date = $0.1.first?.date else { return nil }

            let dateString = date.localized

            return Observable2DArraySection<String, TransactionViewModel>(
                metadata: dateString,
                items: sortedItems
            )
        }
    }
}
