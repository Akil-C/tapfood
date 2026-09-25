# 🍔 TapFood — Food Ordering Web Application

TapFood is a **Java-based food ordering web application** that allows users to browse restaurants, explore menus, manage a shopping cart, place orders, save delivery addresses, and view their order history.

The application follows a layered architecture using **Jakarta Servlets, JSP, JDBC, DAO, and MySQL**, with BCrypt-based password hashing for authentication.

---

## 🚀 Features

### 👤 User Authentication

* User registration with client-side and server-side validation
* Login using username or email
* BCrypt password hashing
* Forgot password and password reset functionality
* Session-based authentication
* Secure logout

### 🍕 Restaurant & Menu

* Browse available restaurants
* View restaurant cuisine, rating, and delivery information
* View restaurant-specific menus
* Display food images and menu details

### 🛒 Shopping Cart

* Add food items to cart
* Update item quantities
* Remove individual items
* Session-based cart management
* Automatic cart total calculation

### 💳 Checkout & Orders

* Select delivery address
* Select payment mode
* Place food orders
* Generate order confirmation
* View previous orders and order details

### 👤 Profile & Address Management

* View user profile
* Add delivery addresses
* Edit saved addresses
* Delete saved addresses
* Manage multiple delivery addresses

---

## 🛠️ Tech Stack

| Layer                | Technology            |
| -------------------- | --------------------- |
| Programming Language | Java 21               |
| Web Technology       | Jakarta Servlet 6.0   |
| View Layer           | JSP                   |
| Application Server   | Apache Tomcat 10.1.x  |
| Database             | MySQL                 |
| Database Access      | JDBC                  |
| JDBC Driver          | MySQL Connector/J     |
| Authentication       | BCrypt                |
| Build Tool           | Maven                 |
| Frontend             | HTML, CSS, JavaScript |
| Architecture         | Layered / MVC-style   |
| Deployment           | Docker / Render       |

---

## 🏗️ Application Architecture

The application follows a layered architecture where each layer has a specific responsibility.

```text
                    ┌───────────────────┐
                    │      Browser      │
                    │ HTML / CSS / JSP  │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │     Servlets      │
                    │   Controller      │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │      DAO          │
                    │   Interfaces      │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │     DAOImpl       │
                    │      JDBC         │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │      MySQL        │
                    │     Database      │
                    └───────────────────┘
```

### Request Flow

```text
JSP
 ↓
Servlet
 ↓
DAO Interface
 ↓
DAO Implementation
 ↓
JDBC
 ↓
MySQL
 ↓
Model Object
 ↓
Servlet
 ↓
JSP
```

This separation keeps the application organized and makes database operations independent from the controller layer.

---

## 📂 Project Structure

```text
tapfood/
│
├── pom.xml
├── mvnw
├── mvnw.cmd
├── .mvn/
│
├── database/
│   └── schema.sql
│
├── .env.example
│
└── src/
    └── main/
        ├── java/
        │   │
        │   ├── com/food/servlet/
        │   │   ├── RegisterServlet
        │   │   ├── LoginServlet
        │   │   ├── ResetPasswordServlet
        │   │   ├── RestaurantServlet
        │   │   ├── MenuServlet
        │   │   ├── CartServlet
        │   │   ├── OrderServlet
        │   │   └── AddressServlet
        │   │
        │   └── com/tap/
        │       ├── model/
        │       ├── DAO/
        │       ├── DAOImpl/
        │       └── utility/
        │           └── DBConnection
        │
        └── webapp/
            ├── *.jsp
            ├── register.html
            ├── css/
            │   └── style.css
            ├── images/
            └── WEB-INF/
                ├── web.xml
                └── jspf/
```

---

## 🗄️ Database

The application uses **MySQL** for persistent data storage.

Main entities include:

* User
* Restaurant
* Menu
* User Address
* Order
* Order Item

### Database Relationships

```text
User
 │
 ├──── User Address
 │
 └──── Orders
          │
          └──── Order Items
                    │
                    └──── Menu
                              │
                              └──── Restaurant
```

The database uses:

* Primary keys
* Foreign keys
* Constraints
* Relational mapping
* Prepared SQL statements

---

## 🔐 Security

User passwords are never stored as plain text.

Passwords are hashed using **BCrypt** before being stored in the database.

User-provided values are passed to SQL queries using `PreparedStatement` rather than directly concatenating input into SQL queries.

Database credentials are also supplied through **environment variables** rather than being hard-coded into the source code.

### Environment Variables

```text
DB_URL
DB_USERNAME
DB_PASSWORD
```

Example:

```text
DB_URL=jdbc:mysql://localhost:3306/Tapfood
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

---

## ⚙️ How to Run Locally

### Prerequisites

Make sure you have:

* JDK 21 or newer
* MySQL 8.x
* Apache Tomcat 10.1.x
* Git
* Eclipse / IntelliJ IDEA / VS Code

Maven does not need to be installed separately because the project includes the **Maven Wrapper**.

---

### 1. Clone the Repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
cd tapfood
```

---

### 2. Create the Database

Use the SQL schema provided in:

```text
database/schema.sql
```

You can execute it using MySQL:

```bash
mysql -u your_username -p < database/schema.sql
```

---

### 3. Configure Environment Variables

Configure:

```text
DB_URL
DB_USERNAME
DB_PASSWORD
```

These variables must be available to the Tomcat application.

---

### 4. Build the Project

#### Windows

```bash
mvnw.cmd clean package
```

#### Linux / macOS

```bash
./mvnw clean package
```

The WAR file will be generated inside:

```text
target/tapfood.war
```

---

### 5. Deploy to Tomcat

Copy the generated WAR file into:

```text
Tomcat/webapps/
```

Start Apache Tomcat and open:

```text
http://localhost:8080/tapfood/
```

---

## 💻 Running with Eclipse

1. Open Eclipse
2. Select **File → Import → Existing Maven Projects**
3. Select the TapFood project
4. Configure **Apache Tomcat 10.1**
5. Add the required environment variables
6. Right-click the project
7. Select **Run As → Run on Server**

---

## 🧠 What I Learned

Working on this project helped me strengthen my understanding of Java full-stack development and how different application layers communicate.

### Java Web Development

* Jakarta Servlets
* JSP
* Servlet lifecycle
* Request and response handling
* Session management
* Form handling

### Database Development

* JDBC
* CRUD operations
* PreparedStatement
* SQL queries
* Primary and foreign keys
* Database relationships

### Software Architecture

* MVC-style architecture
* DAO pattern
* Separation of concerns
* Model classes
* Interface-based design

### Security

* BCrypt password hashing
* Session-based authentication
* Server-side validation
* Secure database queries
* Environment-based configuration

### Deployment

* Maven WAR packaging
* Apache Tomcat deployment
* Docker
* Environment variables
* Database configuration
* Deployment troubleshooting

---

## 🔄 Complete Application Flow

A typical restaurant order follows this flow:

```text
User
 ↓
Restaurant Page
 ↓
Select Restaurant
 ↓
View Menu
 ↓
Add Food Item
 ↓
Session Cart
 ↓
Update Quantity
 ↓
Checkout
 ↓
Select Address
 ↓
Select Payment Mode
 ↓
Place Order
 ↓
MySQL Database
 ↓
Order Confirmation
 ↓
Order History
```

---

## 📸 Screenshots

### Home / Restaurants

*Add application screenshot here.*

### Restaurant Menu

*Add application screenshot here.*

### Shopping Cart

*Add application screenshot here.*

### Checkout

*Add application screenshot here.*

### Order History

*Add application screenshot here.*

### User Profile

*Add application screenshot here.*

---

## 🚀 Future Enhancements

Some features I plan to explore in future versions:

* Spring Boot migration
* REST API development
* React frontend
* JWT authentication
* Online payment gateway integration
* Restaurant owner/admin dashboard
* Order status tracking
* Food search and filtering
* Reviews and ratings
* Docker Compose deployment

---

## 👨‍💻 Developer

**Akil C**

Java Full Stack Developer | Java | Spring Boot | SQL | React

---

## ⭐ Project

If you find the project useful for learning Java web development, feel free to explore the repository and share feedback.

**Built as a hands-on Java Full Stack learning project.**
