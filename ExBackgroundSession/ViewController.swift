//
//  ViewController.swift
//  ExBackgroundSession
//
//  Created by 김종권 on 2023/06/25.
//

import UIKit

class ViewController: UIViewController {
    private let id = "image_upload_task"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
func uploadImageUsingURLSession(imageData: Data, completion: @escaping (Error?) -> Void) {
    let url = URL(string: "https://example.com/upload")
    
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    
    let uniqString = UUID().uuidString
    let contentType = "multipart/form-data; boundary=\(uniqString)"
    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    
    var body = Data()
    
    body.append("--\(uniqString)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    body.append("\r\n".data(using: .utf8)!)
    body.append("--\(uniqString)--\r\n".data(using: .utf8)!)
    
    let session = URLSession(configuration: .background(withIdentifier: id))
    let task = session.uploadTask(with: request, from: body) { (data, response, error) in
        DispatchQueue.main.async {
            if let error = error {
                completion(error)
                return
            }
            // 응답 처리
            
            completion(nil)
        }
    }
    
    task.delegate = self
    
    task.resume()
}

    
    func retryRemainingTasks() {
        let configuration = URLSessionConfiguration.background(withIdentifier: id)
        let session = URLSession(configuration: configuration)

        // 이전에 실행했던 이미지 업로드 작업을 확인하고 처리
        session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            // uploadTasks에서 이전에 실행한 업로드 작업을 찾아서 처리
        }

    }
}

extension ViewController: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("progress = ", Double(bytesSent) / Double(totalBytesSent))
    }
}
