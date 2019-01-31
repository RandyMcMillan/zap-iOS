//
//  ZapShared
//
//  Created by Otto Suess on 20.06.18.
//  Copyright © 2018 Zap. All rights reserved.
//

#if !REMOTEONLY

import Foundation
import Lndmobile
import LndRpc

public final class WalletApiStream: WalletApiProtocol {
    public init() {}
    
    public func generateSeed(passphrase: String? = nil, completion: @escaping (Result<[String], LndApiError>) -> Void) {
        let data = LNDGenSeedRequest(passphrase: passphrase).data()
        LndmobileGenSeed(data, StreamCallback(completion, map: WalletApiTransformations.generateSeed))
    }
    
    public func initWallet(mnemonic: [String], password: String, completion: @escaping (Result<Success, LndApiError>) -> Void) {
        let data = LNDInitWalletRequest(password: password, mnemonic: mnemonic).data()
        LndmobileInitWallet(data, StreamCallback(completion, map: WalletApiTransformations.initWallet))
    }
    
    public func unlockWallet(password: String, completion: @escaping (Result<Success, LndApiError>) -> Void) {
        let data = LNDUnlockWalletRequest(password: password).data()
        LndmobileUnlockWallet(data, StreamCallback(completion, map: WalletApiTransformations.unlockWallet))
    }
}

#endif
