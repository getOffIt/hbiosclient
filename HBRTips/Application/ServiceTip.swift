//
//  ServiceTip.swift
//  HBRTips
//
//  Created by Antoine Rabanes on 17/11/2020.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation

struct TODOsPODO {
    let title: String
    let content: String
}

class TodosService {

    struct Endpoints {
        let todos = "https://hbrtips.com/data/latesttipPROD.json"
    }

    struct ResponseDataTip: Decodable {
        let title: String
        let content: String
    }

    var finalCompletionHandler: (TODOsPODO) -> Void = { todo in }

    func retrieve(completionHandler: @escaping (_ todos: TODOsPODO) -> Void) {
        self.finalCompletionHandler = completionHandler
        retrieveRemote(completionHandler: completionHandler)
    }

    func retrieveRemote(completionHandler: @escaping (_ todos: TODOsPODO) -> Void) {

        let session: URLSession = URLSession(configuration: .default)
        guard let todoURL = URL(string: Endpoints().todos) else {
            finishWithError("badURL")
            return
        }
        session.dataTask(with: todoURL) { data, _, error in
            guard let responseData = data else {
                self.finishWithError(error.debugDescription)
                return
            }
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseDataTip.self, from: responseData)
                self.adaptJSONToTODOsPODO(jsonData)
            } catch {
                print("error:\(error)")
            }
        }.resume()
    }

    fileprivate func adaptJSONToTODOsPODO(_ responseData: TodosService.ResponseDataTip) {

        let todo = TODOsPODO(title: responseData.title, content: responseData.content)
        finishWith(todo)
    }

    fileprivate func finishWith(_ todos: TODOsPODO) {
        DispatchQueue.global().async {
            self.finalCompletionHandler(todos)
        }
    }

    fileprivate func finishWithError(_ todos: String) {
      
            let todo = TODOsPODO(title: "error", content: todos)
            
        self.finishWith(todo)
    }

    fileprivate func finishWithGenericError() {
        finishWithError("error")
    }
}
