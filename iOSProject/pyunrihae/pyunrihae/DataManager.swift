//
//  DataManager.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 3..
//  Copyright © 2017년 busride. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase
import FirebaseDatabase

class DataManager{
    
    
    // 기본 데이터 레퍼런스
    static var ref : DatabaseReference! = Database.database().reference()
    
    /*
     * 메인화면
     */
    
    // 브랜드에 따라 리뷰 가져오고, 그걸 유용순으로 정리하기.
    static func getTop3ReviewByBrand(brand : String, completion: @escaping ([Review]) -> ()) {
        
        let localRef = ref.child("review")
        
        
        if brand == "전체" { // 브랜드 : 전체를 선택한 경우
//            let query = localRef.queryOrdered(byChild: "useful").queryLimited(toLast: 3)
            localRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                var reviewList : [Review]  = []
                for childSnapshot in snapshot.children {
                    let review = Review.init(snapshot: childSnapshot as! DataSnapshot)
                    reviewList.append(review)
                }
                reviewList = reviewList.sorted(by: { $0.useful > $1.useful })
                completion(reviewList)
            })

        }else { // 특정 브랜드를 선택한 경우
//            let query = localRef.queryOrdered(byChild: "brand").queryEqual(toValue: brand)
            
            localRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                var reviewList : [Review]  = []
                for childSnapshot in snapshot.children {
                    let review = Review.init(snapshot: childSnapshot as! DataSnapshot)
                    if review.brand == brand {
                        reviewList.append(review)
                    }
                }
                reviewList = reviewList.sorted(by: { $0.useful > $1.useful })
                // 유용순으로 정렬하기
                completion(reviewList)
            })
            
        }
    }
    
    // 브랜드도 카테고리도 전체가 아닐 때
    // 카테고리로 받아와서 클라이언트에서 brand로 filter해주기 , 그리고 점수로 뿌려주기.
    static func getTopProductBy(brand : String, category : String, completion: @escaping ([Product]) -> ()) {
        let localRef = ref.child("product")
//        let query = localRef.queryOrdered(byChild: "category").queryEqual(toValue: category)
        localRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var productList : [Product] = []
            for childSnapshot in snapshot.children {
                let product = Product.init(snapshot: childSnapshot as! DataSnapshot)
                if product.brand == brand && product.category == category {
                    productList.append(product)
                }
                
            }
            // 가져온 상품를 평점 순으로 뿌려준다.
            productList = productList.sorted(by: { $0.grade_avg > $1.grade_avg})
            completion(productList)
        })
    }
    
    
    // 브랜드만 달라지고 카테고리는 전체일 때
    static func getTopProductBy(brand : String, completion : @escaping ([Product]) -> ()) {
        let localRef = ref.child("product")
//        let query = localRef.queryOrdered(byChild: "brand").queryEqual(toValue: brand)
        
        localRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var productList : [Product] = []
            for childSnapshot in snapshot.children {
                let product = Product.init(snapshot: childSnapshot as! DataSnapshot)
                if product.brand == brand{
                    productList.append(product)
                }
            }
            
            productList = productList.sorted(by: { $0.grade_avg > $1.grade_avg})
            completion(productList)
        })
    }
    
    
    // 카테고리만 달라지고 브랜드는 전체일 때
    static func getTopProductBy(category: String, completion : @escaping ([Product]) -> ()) {
        let localRef = ref.child("product")
//        let query = localRef.queryOrdered(byChild: "category").queryEqual(toValue: category)
        
        localRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var productList : [Product] = []
            for childSnapshot in snapshot.children {
                let product = Product.init(snapshot: childSnapshot as! DataSnapshot)
                if product.category == category {
                   productList.append(product)
                }
            }
            productList = productList.sorted(by: { $0.grade_avg > $1.grade_avg})
            completion(productList)
        })
    }
    
    
    // 브랜드 + 카테고리 전체일 때
    static func getTop3Product(completion: @escaping ([Product]) -> ()) {
        let localRef = ref.child("product")
        let query = localRef.queryOrdered(byChild: "grade_avg").queryLimited(toLast: 3)
        
        query.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var productList : [Product] = []
            for childSnapshot in snapshot.children {
                let product = Product.init(snapshot: childSnapshot as! DataSnapshot)
                productList.append(product)
            }
            completion(productList)
        })
    }
    
    /*
     * 리뷰 화면
     */
    
    // 브랜드와 카테고리가 전체가 아닐 때 리뷰 리스트 받아오기
    static func getReviewListBy(brand : String, category : String, completion : @escaping ([Review]) -> ()) {
        let localRef = ref.child("review")
        let query = localRef.queryOrdered(byChild: "brand").queryEqual(toValue: brand)
        query.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
             var reviewList : [Review] = []
            for childSnapshot in snapshot.children {
                let review = Review.init(snapshot: childSnapshot as! DataSnapshot)
                
                if review.category == category {
                    reviewList.append(review)
                }
            }
            
            completion(reviewList)
        })
    }
    
    // 카테고리가 전체일때 브랜드로만 리뷰 리스트 받아오기.
    static func getReviewListBy(brand: String, completion: @escaping ([Review]) ->()) {
        let localRef = ref.child("review")
        let query = localRef.queryOrdered(byChild: "brand").queryEqual(toValue: brand)
        query.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var reviewList : [Review] = []
            for childSnapshot in snapshot.children {
                let review = Review.init(snapshot: childSnapshot as! DataSnapshot)
                reviewList.append(review)
            }
            completion(reviewList)
        })
    }
    
    // 브랜드가 전체일때 카테고리로만 리뷰 리스트 받아오기.
    static func getReviewListBy(category: String, completion: @escaping ([Review]) ->()) {
        let localRef = ref.child("review")
        let query = localRef.queryOrdered(byChild: "category").queryEqual(toValue: category)
        query.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var reviewList : [Review] = []
            for childSnapshot in snapshot.children {
                let review = Review.init(snapshot: childSnapshot as! DataSnapshot)
                reviewList.append(review)
            }
            
            completion(reviewList)
        })
    }
    
    // 브랜드와 카테고리가 전체일 때 리뷰 리스트 받아오기.
    static func getReviewList(completion: @escaping ([Review]) ->()) {
        let localRef = ref.child("review")
        let query = localRef.queryOrdered(byChild: "useful")
        
        query.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var reviewList : [Review] = []
            for childSnapshot in snapshot.children {
                let review = Review.init(snapshot: childSnapshot as! DataSnapshot)
                reviewList.append(review)
            }
            completion(reviewList)
        })
    }
    
    // 상품 아이디로 리뷰 리스트 받아오기.
    static func getReviewListBy(id: String, completion: @escaping ([Review]) ->()) {
        let localRef = ref.child("review")
        let query = localRef.queryOrdered(byChild: "p_id").queryEqual(toValue: id)
        query.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var reviewList : [Review] = []
            for childSnapshot in snapshot.children {
                let review = Review.init(snapshot: childSnapshot as! DataSnapshot)
                reviewList.append(review)
            }
            completion(reviewList)
        })
    }
    
    /*
     * 랭킹화면 : 메인화면 함수 재사용. 전체 브랜드 + 전체 카테고리 일 때 함수만 재작성.
     */
    
    static func getProductAllInRank(completion : @escaping ([Product]) -> ()){
        let localRef = ref.child("product")
        
        localRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var productList : [Product] = []
            for childSnapshot in snapshot.children {
                let product = Product.init(snapshot : childSnapshot as! DataSnapshot)
                productList.append(product)
            }

            completion(productList)
        })
    }
    
    // 상품 id로 상품 가져오기
    static func getProductById(id: String, completion : @escaping (Product) -> ()) {
        let localRef = ref.child("product").child(id)
        localRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let product = Product.init(snapshot: snapshot)
            completion(product)
        })
    }
    /*
     *  상품 상세 화면
     */
    
    static func tabUsefulBtn(id: String) {
        let localRef = ref.child("review").child(id)
        localRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            if postDict["useful"] != nil {
                if var useful = postDict["useful"] as? Int {
                    useful += 1
                    localRef.updateChildValues(["useful": useful])
                }
            }
        })
    }
    static func tabBadBtn(id: String) {
        let localRef = ref.child("review").child(id)
        localRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            if postDict["bad"] != nil {
                if var bad = postDict["bad"] as? Int {
                    bad += 1
                    localRef.updateChildValues(["bad": bad])
                }
            }
        })
    }
    
    /*
     *  리뷰 쓰기 화면
     */
    
    
    // 리뷰 쓰기
    static func updateProductInfo(p_id: String, grade: Int, priceLevel: Int, flavorLevel: Int, quantityLevel: Int, allergy: [String]) {
        let localRef = ref.child("product").child(p_id)
        localRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            var update = [String: Any]()
            
            var grade_total = grade
            var grade_count = 1
            
            if postDict["grade_total"] != nil {
                if let total = postDict["grade_total"] as? Int {
                    grade_total += total
                    update["grade_total"] = grade_total
                }
            } else {
                update["grade_total"] = grade_total
            }
            if postDict["grade_count"] != nil {
                if let count = postDict["grade_count"] as? Int {
                    grade_count += count
                    update["grade_count"] = grade_count
                }
            } else {
                update["grade_count"] = grade_count
            }
            
            let grade_avg = Float(grade_total) / Float(grade_count)
            update["grade_avg"] = grade_avg
            
            if postDict["allergy"] != nil {
                if var allergyList = postDict["allergy"] as? [String] {
                    for i in 0..<allergy.count {
                        var exist = false
                        for j in 0..<allergyList.count {
                            if allergy[i] == allergyList[j] {
                                exist = true
                            }
                        }
                        if !exist {
                            allergyList.append(allergy[i])
                        }
                    }
                    update["allergy"] = allergyList
                }
            } else {
                update["allergy"] = allergy
            }
            var level = "g" + grade.description
            if postDict["grade_data"] != nil {
                if var grade_data = postDict["grade_data"] as? [String: Int] {
                    if var num = grade_data[level] {
                        num += 1
                        grade_data[level] = num
                        update["grade_data"] = grade_data
                    } else {
                        grade_data[level] = 1
                        update["grade_data"] = grade_data
                    }
                }
            } else {
                var grade_data = ["g1": 0, "g2": 0, "g3": 0, "g4": 0, "g5": 0]
                grade_data[level] = 1
                update["grade_data"] = grade_data
            }
            
            
            level = "p" + priceLevel.description
            if postDict["price_level"] != nil {
                if var price_level = postDict["price_level"] as? [String: Int] {
                    if var num = price_level[level] {
                        num += 1
                        price_level[level] = num
                        update["price_level"] = price_level
                    } else {
                        price_level[level] = 1
                        update["price_level"] = price_level
                    }
                }
            } else {
                var price_level = ["p1": 0, "p2": 0, "p3": 0, "p4": 0, "p5": 0]
                price_level[level] = 1
                update["price_level"] = price_level
            }
            
            level = "f" + flavorLevel.description
            if postDict["flavor_level"] != nil {
                if var flavor_level = postDict["flavor_level"] as? [String: Int] {
                    if var num = flavor_level[level] {
                        num += 1
                        flavor_level[level] = num
                        update["flavor_level"] = flavor_level
                    } else {
                        flavor_level[level] = 1
                        update["flavor_level"] = flavor_level
                    }
                }
            } else {
                var flavor_level = ["f1": 0, "f2": 0, "f3": 0, "f4": 0, "f5": 0]
                flavor_level[level] = 1
                update["flavor_level"] = flavor_level
            }
            
            level = "q" + quantityLevel.description
            if postDict["quantity_level"] != nil {
                if var quantity_level = postDict["quantity_level"] as? [String: Int] {
                    if var num = quantity_level[level] {
                        num += 1
                        quantity_level[level] = num
                        update["quantity_level"] = quantity_level
                    } else {
                        quantity_level[level] = 1
                        update["quantity_level"] = quantity_level
                    }
                }
            } else {
                var quantity_level = ["q1": 0, "q2": 0, "q3": 0, "q4": 0, "q5": 0]
                quantity_level[level] = 1
                update["quantity_level"] = quantity_level
            }
            localRef.updateChildValues(update)
        })
    }
    
    static func writeReview(brand: String, category: String, grade: Int, priceLevel: Int, flavorLevel: Int, quantityLevel: Int, allergy: [String], review: String, user: String,user_image: String, p_id: String, p_image: UIImage, p_name: String, p_price: Int, completion: ()->()) {
    
        let format = DateFormatter()
        format.locale = Locale(identifier: "ko_kr")
        format.timeZone = TimeZone(abbreviation: "KST")
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let today = format.string(from: Date())
        var imgURL = ""
        
        let localRef = ref.child("review")
        let id = localRef.childByAutoId()
        let storage = Storage.storage()
        
        var autoId = id.description()
        var components = autoId.components(separatedBy: "review/")
        autoId = components[1]
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference(forURL: "gs://pyeonrehae.appspot.com")
        let imagesRef = storageRef.child("images/" + autoId + ".png")
        var update = ["bad": 0, "useful": 0, "user": user, "user_image": user_image, "brand": brand, "category": category, "comment": review, "grade": grade, "price": priceLevel, "flavor": flavorLevel, "quantity": quantityLevel, "p_id": p_id, "p_name": p_name, "p_price": p_price, "timestamp": today, "id": autoId] as [String : Any]
        
        if let data = UIImagePNGRepresentation(p_image) {
            imagesRef.putData(data, metadata: nil, completion: {
                (metadata, error) in
                if error != nil {
                    update["p_image"] = imgURL
                    id.updateChildValues(update)
                    NotificationCenter.default.post(name: NSNotification.Name("reviewUpload"), object: self)
                    NotificationCenter.default.post(name: NSNotification.Name("complete"), object: self)
                } else {
                    imagesRef.downloadURL { (URL, error) -> Void in // 업로드된 이미지 url 받아오기
                        if (error != nil) { // 없으면 ""로 저장
                            update["p_image"] = imgURL
                            id.updateChildValues(update)
                            NotificationCenter.default.post(name: NSNotification.Name("reviewUpload"), object: self)
                            NotificationCenter.default.post(name: NSNotification.Name("complete"), object: self)
                        } else {
                            imgURL = (URL?.description)! // 있으면 해당 url로 저장
                            update["p_image"] = imgURL
                            id.updateChildValues(update)
                            NotificationCenter.default.post(name: NSNotification.Name("reviewUpload"), object: self)
                            NotificationCenter.default.post(name: NSNotification.Name("complete"), object: self)
                        }
                    }
                }
            })
        } else {
            update["p_image"] = imgURL
            id.updateChildValues(update)
            NotificationCenter.default.post(name: NSNotification.Name("reviewUpload"), object: self)
            NotificationCenter.default.post(name: NSNotification.Name("complete"), object: self)
        }
        
        let productRef = ref.child("product").child(p_id)
        productRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            var update = [String: Any]()
            var review_count = 1
            if postDict["review_count"] != nil {
                if let total = postDict["review_count"] as? Int {
                    review_count += total
                    update["review_count"] = review_count
                }
            } else {
                update["review_count"] = review_count
            }
            
            if postDict["reviewList"] != nil {
                if var reviewList = postDict["reviewList"] as? [String] {
                    var exist = false
                    for i in 0..<reviewList.count {
                        if reviewList[i] == autoId {
                            exist = true
                        }
                    }
                    if !exist {
                        reviewList.append(autoId)
                    }
                    update["reviewList"] = reviewList
                }
            } else {
                var reviewList = [String]()
                reviewList.append(autoId)
                update["reviewList"] = reviewList
            }
            productRef.updateChildValues(update)
            
        })
        
        completion()
    }
    
    /*
     * 검색 화면
     */
    
    
    // 상품 이름으로 상품아이디 가져오기 (겹치는 게 있을 시 처음 것)
    static func getProductId(from: String, completion : @escaping (String) -> ()){
        let localRef = ref.child("product")
        let query = localRef.queryOrdered(byChild: "name").queryEqual(toValue: from)
        
        query.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            var product = Product()
            for childSnapshot in snapshot.children {
                product = Product.init(snapshot: childSnapshot as! DataSnapshot)
            }
            completion(product.id)
        })
    }
    
    /*
     *  회원가입 화면
     */
    
    // Firebase Auth의 user를 UserModel로 가져와서 넣기
    static func saveUser(user: User) {
        let localRef = ref.child("user")
        localRef.child(user.id).setValue(["id": user.id, "email" : user.email, "nickname" : user.nickname,  "review_like_list": user.review_like_list, "product_like_list" : user.product_like_list, "wish_product_list": user.wish_product_list])
    }
    
    /*
     * 마이페이지 화면
     */
    
    // uid로 User 불러오기.
    static func getUserFromUID(uid : String, completion: @escaping (User) -> ()){
        let localRef = ref.child("user").child(uid)
        
        localRef.observe(.value, with: { (snapshot) in
            var user = User()
            user = User.init(snapshot: snapshot as! DataSnapshot)
            completion(user)
        })
    }
}
