//・本(Book)を借りることができる。本棚(Bookshelf)からは該当の本がなくなる
//・借りた本(Book)を本棚(Bookshelf)に返すことができる
//・本棚(Bookshelf)には複数冊同じ本(Book)を保管できる
//・本(Book)は過去何回借りられたか分かる

//・ユーザー(User)が会員登録(name, password)をできる
//・ユーザー(User)がログイン(name, password)をできる
//・ログインしたユーザー(User)のみ本を貸し借りをすることができる

import UIKit

struct Book {
    var title: String
    var author: String
    var genre: String
    var pageCount: Int
    var id: Int
}

// BookShelfを使う人はBookにIDが振られている事のみ認識する形に
class BookShelf {
    
    var bookArray: [Book]
    
    init(bookArray: [Book]) {
        self.bookArray = bookArray
    }
    
    // 本を借りるメソッド。配列から削除し借りた本を返す
    func orderBook(rentBook: Book) {
        
        // 本が借りられるため該当の本をbookArrayから削除する
       bookArray = bookArray.filter { $0.id != rentBook.id }
    }
    
    // 借りた本を返すメソッド、。配列に戻す
    func restoreBook(book: Book) {
        
        bookArray.append(book)
    }
}

class Library {
    private var bookShelf: BookShelf
    
    var rentalList: [Book] = []
    var rentalListLog: [Book] = []
    
    init(bookShelf: BookShelf) {
        self.bookShelf = bookShelf
    }
    
    func rentalBook(book: Book, user: User) {
        
        if user.isLogin == false {
            return
        }
        
        rentalList.append(book)
        rentalListLog.append(book)
        user.rentedBooks.append(book)
        
        bookShelf.orderBook(rentBook: book)
    }
    
    func returnBook(rentedBook: Book, user: User) {
        
        if user.isLogin == false {
            return
        }
        
        bookShelf.restoreBook(book: rentedBook)
        rentalList = rentalList.filter { $0.id != rentedBook.id }
    }
    
    func reportAllBooks() -> [Book] {
        
        return bookShelf.bookArray
    }
    
    func reportRentedCount(bookID: Int) -> Int {
        
        var rentedCount = 0
        // TODO: 同じインスタンスを判定する
        for book in rentalListLog where book.id == bookID {
            
            rentedCount += 1
        }
        
        return rentedCount
    }
}

class User {
    var userName: String?
    var userPassword: String?
    var isLogin = false
    var rentedBooks: [Book] = []
    
    func resister(userName: String, userPassword: String) {
        self.userName = userName
        self.userPassword = userPassword
    }
}

class UserLogin {
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func login(userName: String, userPassword: String) {
        
        if user.userName == userName && user.userPassword == userPassword {
            user.isLogin = true
        }
    }
}
// 本の追加
var bookArray: [Book] = []
bookArray.append(Book(title: "宇宙", author: "斎藤", genre: "SF", pageCount: 300, id: 1))
bookArray.append(Book(title: "宇宙", author: "斎藤", genre: "SF", pageCount: 300, id: 2))
bookArray.append(Book(title: "経済", author: "伊藤", genre: "ビジネス", pageCount: 400, id: 3))
bookArray.append(Book(title: "運動", author: "田中", genre: "健康", pageCount: 200, id: 4))
bookArray.append(Book(title: "冒険", author: "斎藤", genre: "アドベンチャー", pageCount: 800, id: 5))

// BookShelfをインスタンス化
let bookShelf = BookShelf(bookArray: bookArray)

// libraryをインスタンス化
let library = Library(bookShelf: bookShelf)

// 会員登録
let user1 = User()
user1.resister(userName: "城島", userPassword: "1112")
// ログイン
UserLogin(user: user1).login(userName: "城島", userPassword: "1112")
// 会員登録
let user2 = User()
user2.resister(userName: "渡辺", userPassword: "1026")
// ログインはしてない
UserLogin(user: user2).login(userName: "渡辺", userPassword: "1026")

// 現在本棚にある本を取得
let allBooks = library.reportAllBooks()
for book in allBooks {
    print("現在本棚にある本:\(book)")
}

// 本のレンタルを実行
library.rentalBook(book: allBooks[0], user: user1)
library.rentalBook(book: allBooks[0], user: user2)

for book in library.rentalList {
    print("現在借し出し中の本:\(book)")
}

// 本の返却を実行
print("本の返却を実行")

library.returnBook(rentedBook: user1.rentedBooks[0], user: user1)
library.returnBook(rentedBook: user2.rentedBooks[0], user: user2)

for book in library.rentalList {
    print("現在借りている本:\(book)")
}

for book in library.reportAllBooks() {
    print("本棚の本:\(book)")
}

for book in library.rentalListLog {
    print("過去に借りた本:\(book)")
}

let bookTitle = "宇宙"
let bookID = 1
print("\(bookTitle)を過去に借りた回数:\(library.reportRentedCount(bookID: bookID))")

