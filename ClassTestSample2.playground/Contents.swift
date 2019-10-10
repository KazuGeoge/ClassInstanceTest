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
    func rentBook(rentBook: Book) {
        
        // 本が借りられるため該当の本をbookArrayから削除する
        // 先に抽出した本と実際
        for (index, book) in bookArray.enumerated() {
            
            if book.title == rentBook.title {
                bookArray.remove(at: index)
                
                return
            }
        }
    }
    
    // 借りた本を返すメソッド、。配列に戻す
    func returnBook(book: Book) {
        
        bookArray.append(book)
    }
}

class Library {
    private var bookShelf: BookShelf
    var user = User()
    
    var allBooks: [Book]
    var rentalList: [Book] = []
    var rentalListLog: [Book] = []
    
    init(bookShelf: BookShelf, user: User) {
        self.bookShelf = bookShelf
        self.user = user
        self.allBooks = self.bookShelf.bookArray
    }
    
    func addRentalList(book: Book) {
        
        if user.isLogin == false {
            return
        }
        
        rentalList.append(book)
        rentalListLog.append(book)
        
        bookShelf.rentBook(rentBook: book)
    }
    
    func returnBook(rentBook: Book) {
        
        if user.isLogin == false {
            return
        }
        
        for (index, book) in rentalList.enumerated() {
            
            if book.title == rentBook.title {
                rentalList.remove(at: index)
                
                return
            }
        }
        bookShelf.returnBook(book: rentBook)
    }
    
    func reportAllBooks() -> [Book] {
        
        return bookShelf.bookArray
    }
}

class User {
    var userName: String?
    var userPassword: String?
    var isLogin = false
    
    func resister(userName: String, userPassword: String) {
        self.userName = userName
        self.userPassword = userPassword
    }
}

class UserLogin {
    var user = User()
    
    init(user: User) {
        self.user = user
    }
    
    func login(userName: String, userPassword: String) {
        
        if user.userName == userName && user.userPassword == userPassword {
            user.isLogin = true
        }
    }
}

// 会員登録
let user = User()
user.resister(userName: "城島", userPassword: "1112")

// ログイン
let userLogin = UserLogin(user: user)
userLogin.login(userName: "城島", userPassword: "1112")

// 本の追加
var bookArray: [Book] = []
bookArray.append(Book(title: "冒険", author: "斎藤", genre: "アドベンチャー", pageCount: 800))
bookArray.append(Book(title: "宇宙", author: "斎藤", genre: "SF", pageCount: 300))
bookArray.append(Book(title: "経済", author: "伊藤", genre: "ビジネス", pageCount: 400))
bookArray.append(Book(title: "運動", author: "田中", genre: "健康", pageCount: 200))
bookArray.append(Book(title: "宇宙", author: "斎藤", genre: "SF", pageCount: 300))

// BookShelfをインスタンス化
let bookShelf = BookShelf(bookArray: bookArray)

// libraryをインスタンス化
let library = Library(bookShelf: bookShelf, user: user)

// 追加後の本棚の本を表示
for book in library.reportAllBooks() {
    print("最初の本棚の本:\(book)")
}
// 本のレンタルを実行
for rentedBook in library.allBooks[0...2] {
    library.addRentalList(book: rentedBook)
}

for book in library.rentalList {
    print("現在借りている本:\(book)")
}

// 本の返却を実行
print("本の返却を実行")
// TODO: ログインしていないためエラーになるので対応必須
for book in library.rentalList[0...1] {
    library.returnBook(rentBook: book)
}

for book in library.rentalList {
    print("現在借りている本:\(book)")
}

for book in library.reportAllBooks() {
    print("本棚の本:\(book)")
}

for book in library.rentalListLog {
    print("過去に借りた本:\(book)")
}

var rentedCount = 0
let bookTitle = "経済"

for book in library.rentalListLog {
    
    if book.title == bookTitle {
        rentedCount += 1
    }
}
print("\(bookTitle)を過去に借りた回数:\(rentedCount)")

