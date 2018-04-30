//
//  Zap
//
//  Created by Otto Suess on 16.04.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import UIKit

class MnemonicPageViewController: UIPageViewController {

    var mnemonicViewModel: MnemonicViewModel?
    private var orderedViewControllers: [UIViewController]?
    
    var isLastViewController: Bool {
        guard let currentViewController = viewControllers?.first else { return false }
        return currentViewController == orderedViewControllers?.last
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.mediumBackground
        
        orderedViewControllers = mnemonicViewModel?.pageWords.map {
            let viewModel = Storyboard.createWallet.instantiate(viewController: MnemonicWordListViewController.self)
            viewModel.mnemonicPageViewModel = $0
            return viewModel
        }
        
        dataSource = self
        
        if let firstViewController = orderedViewControllers?.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func skipToNextViewController() {
        guard
            let currentViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers?.index(of: currentViewController),
            let nextViewController = orderedViewControllers?[currentIndex + 1]
            else { return }
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
}

extension MnemonicPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = orderedViewControllers?.index(of: viewController) else { return nil }
        return self.viewController(for: currentIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = orderedViewControllers?.index(of: viewController) else { return nil }
        return self.viewController(for: currentIndex + 1)
    }
    
    private func viewController(for index: Int) -> UIViewController? {
        guard
            let orderedViewControllers = orderedViewControllers,
            index >= 0 && index < orderedViewControllers.count
            else { return nil }
        return orderedViewControllers[index]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers?.count ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first else { return 0 }
        return orderedViewControllers?.index(of: firstViewController) ?? 0
    }
}