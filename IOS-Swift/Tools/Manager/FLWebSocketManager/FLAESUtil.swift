//
//  AESUtil.swift
//  IOS-Swift
//
//  Created by hardy on 2024/11/7.
//

import Foundation
import CryptoKit

let key: SymmetricKey = SymmetricKey(data: Data("1234567890abcdef".utf8)) // 必须是16字节长

func generateRandomIV(length: Int) -> Data 
{
    var iv = [UInt8](repeating: 0, count: length)
    let status = SecRandomCopyBytes(kSecRandomDefault, length, &iv)
    if status == errSecSuccess {
        return Data(iv)
    } else {
        fatalError("Failed to generate random IV")
    }
}

func encrypt(string: String) -> String? {
    do {
        let data = string.data(using: .utf8)!
        FLPrint("Data to encrypt: \(data)")
        
        // 生成随机IV
        let iv = generateRandomIV(length: 12) // 12字节长
        FLPrint("Generated IV: \(iv)")
        
        // 尝试加密
        let sealedBox = try AES.GCM.seal(data, using: key, nonce: .init(data: iv))
        FLPrint("Sealed box: \(sealedBox)")
        
        // 组合IV、密文和标签
        let combinedData = iv + sealedBox.ciphertext + sealedBox.tag
        FLPrint("Combined data: \(combinedData)")
        return combinedData.base64EncodedString()
    } catch {
        FLPrint("Encryption error: \(error)")
        return nil
    }
}

func decrypt(base64String: String) -> [String: Any]? 
{
    do {
        guard let combinedData = Data(base64Encoded: base64String) else {
            print("Invalid base64 string")
            return nil
        }
        FLPrint("Combined data: \(combinedData)")
        
        // 分离IV、密文和标签
        let iv = combinedData.prefix(12)
        let encrypted = combinedData.subdata(in: 12..<combinedData.count - 16)
        let tag = combinedData.suffix(16)
        
        // 尝试解密
        let sealedBox = try AES.GCM.SealedBox(nonce: .init(data: iv), ciphertext: encrypted, tag: tag)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        
        if let string = String(data: decryptedData, encoding: .utf8) {
            FLPrint("Converted string: \(string)")
            // 解析JSON
            let json = try JSONSerialization.jsonObject(with: decryptedData, options: [])
            return json as? [String: Any]
        } else {
            FLPrint("Failed to convert data to string")
            return nil
        }
    } catch {
        FLPrint("Decryption error: \(error)")
        return nil
    }
    
}
