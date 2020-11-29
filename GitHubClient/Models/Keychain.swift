//
//  KeyChain.swift
//  GitHubClient
//
//  Created by Павел on 12.11.2020.
//

import UIKit

protocol KeyChainProtocol {
    
    ///Метод, сохранающий пароль пользователя в кейчейн. Возвращает true в случае успеха и false в случае неудачи.
    func savePassword(password: String, account: String) -> Bool
    
    ///Метод, возвращающий пароль пользователя из кейчейн. Возвращает пароль или nil в случае неудачи.
    func readPassword(account: String) -> String?
    
}

struct Keychain: KeyChainProtocol {
    
    func savePassword(password: String, account: String) -> Bool {
        
        // Сначала превращаем пароль в тип Data.
        let passwordData = password.data(using: .utf8)
        
        // Проверяем, нет ли уже сохраненного пароля для данного аккаунта. Если есть, то обновляем.
        if readPassword(account: account) != nil {
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = passwordData as AnyObject
            let query = keychainQuery(account: account)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            return status == noErr
        }
        
        var item = keychainQuery(account: account)
        item[kSecValueData as String] = passwordData as AnyObject
        let status = SecItemAdd(item as CFDictionary, nil)
        return status == noErr
    }
    
    func readPassword(account: String) -> String? {
        var query = keychainQuery(account: account)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        // Переменная для записи результата запроса.
        var queryResult: AnyObject?
        
        // Статус запроса по поиску пароля.
        var status = OSStatus()
        
        // Запрос SecItemCopyMatching на поиск пароля, в результате которого в указанное место (в нашу переменную) будет возвращен результат. К сожалению, пришлось обернуть в клоужер внутри withUnsafePointer, чтобы убрать ворнинг о возможной потери данных.
        withUnsafePointer(to: &queryResult) { (pointer: UnsafePointer<AnyObject?>) -> Void in
            status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(mutating: pointer))
        }
        
        // Проверяем, что запрос успешно выполнен и результат получен.
        if status != noErr {
            return nil
        }
        
        // Парсим результат как словарь [String: AnyObject], извлекаем passwordData и конвертируем в String.
        guard let item = queryResult as? [String: AnyObject],
              let passwordData = item[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: .utf8) else { return nil }
        return password

    }
    
    //MARK: -Private
    
    ///Метод, возвращающий словарь с запросом для кейчейна.
    private func keychainQuery(account: String) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        let service = "com.pavellaukhin.GitHubClient" // название моей программы (уникальное)
        query[kSecAttrService as String] = service as AnyObject
        query[kSecAttrAccount as String] = account as AnyObject

        return query
    }
    
}
