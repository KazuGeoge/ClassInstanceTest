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
        // 先に抽出した本と実際
        // TODO: 同じインスタンスを判定する
        for (index, book) in bookArray.enumerated() {
            
            if book.title == rentBook.title {
                bookArray.remove(at: index)
                
                return
            }
        }
    }
    
    // 借りた本を返すメソッド、。配列に戻す
    func restoreBook(book: Book) {
        
        bookArray.append(book)
    }
}

class Library {
    private var bookShelf: BookShelf
    
    var allBooks: [Book]
    var rentalList: [Book] = []
    var rentalListLog: [Book] = []
    
    init(bookShelf: BookShelf) {
        self.bookShelf = bookShelf
        self.allBooks = self.bookShelf.bookArray
    }
    
    func rentalBook(book: Book) {
        
        rentalList.append(book)
        rentalListLog.append(book)
        
        bookShelf.orderBook(rentBook: book)
    }
    
    func returnBook(rentBook: Book) {
        // TODO: 同じインスタンスを判定する
        for (index, book) in rentalList.enumerated() {
            
            if book.title == rentBook.title {
                rentalList.remove(at: index)
                
                return
            }
        }
        bookShelf.restoreBook(book: rentBook)
    }
    
    func reportAllBooks() -> [Book] {
        
        return bookShelf.bookArray
    }
    
    func repotRentalListLog(bookTitle: String) -> Int {
        var rentedCount = 0
        
        for book in rentalListLog {
            
            if book.title == bookTitle {
                rentedCount += 1
            }
        }
        return rentedCount
    }
}

class User {
    var userName: String?
    var userPassword: String?
    var isLogin = false
    var rentedBooks: [Book] = []
    var library: Library
    
    init(library: Library) {
        self.library = library
    }
    
    func resister(userName: String, userPassword: String) {
        self.userName = userName
        self.userPassword = userPassword
    }
    
    func rentBook(rentBook: Book) {
        
        if isLogin == false {
            return
        }
        
        library.rentalBook(book: rentBook)
        
        rentedBooks.append(rentBook)
    }
    
    func returnBook(rentedBook: Book) {
        
        if isLogin == false {
            return
        }
        
        library.returnBook(rentBook: rentedBook)
        
        for (index, book) in rentedBooks.enumerated() {
            
            if book.title == rentedBook.title {
                rentedBooks.remove(at: index)
                
                return
            }
        }
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
bookArray.append(Book(title: "宇宙", author: "斎藤", genre: "SF", pageCount: 300))
bookArray.append(Book(title: "宇宙", author: "斎藤", genre: "SF", pageCount: 300))
bookArray.append(Book(title: "経済", author: "伊藤", genre: "ビジネス", pageCount: 400))
bookArray.append(Book(title: "運動", author: "田中", genre: "健康", pageCount: 200))
bookArray.append(Book(title: "冒険", author: "斎藤", genre: "アドベンチャー", pageCount: 800))

// BookShelfをインスタンス化
let bookShelf = BookShelf(bookArray: bookArray)

// libraryをインスタンス化
let library = Library(bookShelf: bookShelf)

// 会員登録
let user1 = User(library: library)
user1.resister(userName: "城島", userPassword: "1112")
// ログイン
UserLogin(user: user1).login(userName: "城島", userPassword: "1112")
// 会員登録
let user2 = User(library: library)
user2.resister(userName: "渡辺", userPassword: "1026")
// ログインはしてない
UserLogin(user: user2).login(userName: "渡辺", userPassword: "1026")

// 現在本棚にある本を取得
let allBooks = library.reportAllBooks()
for book in allBooks {
    print("現在本棚にある本:\(book)")
}

// 本のレンタルを実行
user1.rentBook(rentBook: allBooks[0])
user2.rentBook(rentBook: allBooks[0])

for book in library.rentalList {
    print("現在借し出し中の本:\(book)")
}

// 本の返却を実行
print("本の返却を実行")

user1.returnBook(rentedBook: user1.rentedBooks[0])
user2.returnBook(rentedBook: user2.rentedBooks[0])

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
print("\(bookTitle)を過去に借りた回数:\(library.repotRentalListLog(bookTitle: bookTitle))")

