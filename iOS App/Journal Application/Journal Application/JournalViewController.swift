//
//  ViewController.swift
//  Journal Application
//
//  Created by khawar on 7/26/19.
//  Copyright © 2019 khawar. All rights reserved.
//

import UIKit

struct Post: Decodable {
    let id: Int
    let title, body: String
}

class Service: NSObject {
    static let shared = Service()
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>)->()) {
        guard let url = URL(string: "http://localhost:1337/posts") else {return}
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            DispatchQueue.main.async {
                if let err = err{
                    print("Failed to fetch post:", err)
                    return
                }
                guard let data = data else { return }
                
                do{
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    completion(.success(posts))
                }catch{
                    completion(.failure(error))
                    
                }
            }
            
            }.resume()
    }
    
    func createPost(title: String, body: String, completion: @escaping (Error?) -> ()) {
        guard let url = URL(string: "http://localhost:1337/post") else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let params = ["title":title, "postBody":body]
        do{
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            urlRequest.httpBody = data
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
            URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
                //                guard let data = data else { return }
                //                print(String(data: data, encoding: .utf8) ?? "")
                completion(nil)
                }.resume()
        }catch{
            completion(error)
        }
        
    }
    
    func deletePost(id: Int, completion: @escaping (Error?) -> ()) {
        guard let url = URL(string: "http://localhost:1337/post/\(id)") else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
            DispatchQueue.main.async {
                if let err = err{
                    completion(err)
                    return
                }
                if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
                    let errorString = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    completion(NSError(domain: "", code: resp.statusCode, userInfo: [NSLocalizedDescriptionKey: errorString]))
                    return
                }
                completion(nil)
            }
        }.resume()
    }
}


class JournalViewController: UITableViewController {
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Posts"
        navigationItem.rightBarButtonItem = .init(title: "Create Post", style: .plain, target: self, action: #selector(handelCreatePost))
    }
    
    fileprivate func fetchPosts(){
        Service.shared.fetchPosts { (res) in
            switch res {
            case .failure(let err):
                print("Failed to fetch posts: ", err)
            case .success(let posts):
                self.posts = posts
                self.tableView.reloadData()
            }
        }
    }
    
    @objc fileprivate func handelCreatePost(){
        let alert = UIAlertController(title: "Creating post", message: "Enter post title and body", preferredStyle: .alert)
        
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = "Post title"
        }
        
        alert.addTextField { (bodyTextField) in
            bodyTextField.placeholder = "Post body"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            let title = alert.textFields![0].text ?? ""
            let body = alert.textFields![1].text ?? ""
            Service.shared.createPost(title: title, body: body) { (error) in
                if let err = error {
                    print("Failed to creat post:", err)
                    return
                }
                
                print("Finished created post")
                self.fetchPosts()
            }
        }))
        
        self.present(alert,animated: true)

    }
}

extension JournalViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let post = self.posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print("delete")
            let post = posts[indexPath.row]
            Service.shared.deletePost(id: post.id) { (error) in
                if let err = error{
                    print("Failed to delete post: ", err)
                    return
                }
                print("Finished deleting post")
                self.posts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

