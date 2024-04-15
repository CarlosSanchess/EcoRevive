<<<<<<< HEAD
# register

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# EcoRevive Development Report

Welcome to the documentation pages of the EcoRevive!

You can find here details about our implementation, from a high-level vision to low-level implementation decisions, a kind of Software Development Report, organized by type of activities: 

* [Business modeling](#Business-Modelling) 
  * [Product Vision](#Product-Vision)
  * [Features and Assumptions](#Features-and-Assumptions)
  * [Elevator Pitch](#Elevator-pitch)
* [Requirements](#Requirements)
  * [Domain model](#Domain-model)
* [Architecture and Design](#Architecture-And-Design)
  * [MVC Architectural Pattern](#mvc-architectural-pattern)
  * [Design Patterns](#design-patterns-consideration)
  * [Logical architecture](#Logical-Architecture)
  * [Physical architecture](#Physical-Architecture)
  * [Vertical prototype](#Vertical-Prototype)
* [Project management](#Project-Management)

## Business Modelling

### Product Vision

- EcoRevive is a community-driven recycling platform that revolutionizes waste management by transforming discarded items into valuable resources, thereby promoting sustainable practices and actively contributing to the establishment of a circular economy.

### Features and Assumptions

#### Main Features

1. Product Listing: Explore a diverse array of items available, starting with electronic waste and expanding to encompass a wide range of recyclable materials. Our intuitive interface ensures easy navigation.

2. Advanced Product Filtering: Search with precision using our filtering system. Whether you're seeking specific conditions or items, robust filters help you find exactly what you need efficiently.

3. Secure Login Registration: Join our community through a secure registration process. Your personal information is safeguarded, ensuring a trusted environment for all users to engage in sustainable exchange.

4. Interactive User Chat: Foster meaningful connections and facilitate smooth transactions through our integrated chat feature. Engage in real-time conversations with fellow users to negotiate terms, ask questions, and coordinate exchanges, all within the convenience of our platform.

5. User-Friendly App: ensuring inclusivity for individuals with disabilities that still want to take part on this community.

#### Assumptions
- Firebase database to store the users credentials aswell as products listing and others...

### Elevator Pitch

- For environmentally conscious individuals tired of the hassle of recycling, the "EcoRevive" app is a sustainable solution. It's a recycling platform that simplifies the process of finding, listing, and discussing recyclable products matching people that want to discard those products, with people looking for them. Unlike other recycling apps that focus solely on listings, our app emphasizes community engagement and social interaction around sustainability. With features like chat functionality and user ratings, EcoRevive fosters meaningful connections between users, making recycling both simple and social.


## Requirements

### Domain model

Each user can list multiple products of various categories on the application.
Whenever a user sees a product that he's interested in, he can start a chat with the owner of said product, where they can message each other.
The application will send notifications to the user whenever a new message is received.
After chatting and acquiring the product, the chat participants can rate each other and leave feedback to improve user experience.
The application has moderatores that unsure guidelines are being respected, being able to ban user that don't respect them.

 <p align="center" justify="center">
  <img src="docs/diagrams/domain_model.png"/>
</p>


## Architecture and Design

### MVC Architectural Pattern:

The Model-View-Controller (MVC) architectural pattern divides an application into three interconnected components, each with distinct responsibilities:

- **Model:** Represents the application's data and business logic. In EcoRevive, the Model component manages data related to users, products, and interactions.

- **View:** Represents the user interface (UI) elements of the application. The View component in EcoRevive encompasses screens for each feature and state of the app.

- **Controller:** Acts as an intermediary between the Model and View components. It handles user input, processes requests, and updates the Model or View accordingly. In EcoRevive, the Controller component manages user interactions and orchestrates the flow of data between the Model and View.

### Design Patterns Consideration:

In the development of the EcoRevive app, we're considering the utilization of various design patterns. Two of the considered patterns are:

- **Strategy Pattern:**
   - The Strategy pattern can be beneficial for implementing different algorithms for product filtering.

- **Factory Method Pattern:**
   - The Factory Method pattern can be employed for adding different types of recyclable items or product objects to the products listing based on user input.

### Logical architecture

The logical architecture of EcoRevive outlines its core components and their interactions. It depicts the user interface (GUI), the logic handling core functionality, and the database for data management within the system (e.g user settings like the app color theme etc). Additionally, it integrates with Firebase for external services such as authentication or data storage. The diagram illustrates how user interactions flow. This logical architecture provides a high-level understanding of how EcoRevive's components work together to fulfill its functionalities.


### Components
#### EcoRevive
- **GUI**: User interface for interacting with the system.
- **Logic**: Core functionality and processing.
- **Database**: Stores and manages system data.

#### External Services
- **Firebase Server**: Integrated for features like authentication or data storage.

#### Relationships
- User interactions pass from GUI to Logic.
- Logic interacts with the Database for data.
- Logic also communicates with Firebase for external services.

![LogicalView](docs/diagrams/logical_arch.png)

### Physical architecture
The physical architecture section provides an overview of the high-level physical structure of the software system, including physical components, connections, software, and their dependencies. It also discusses the technologies considered for the implementation and justifies the selections made.

#### Technologies Considered:
- **Flutter**: A cross-platform framework for building mobile applications.
- **Firebase**: A Backend-as-a-Service (BaaS) platform providing services like authentication, database, and storage.

![DeploymentView](docs/diagrams/physical_arch.png)

### Vertical prototype
For this initial prototype, we've implemented a basic entry page that serves as the starting point for users accessing the EcoRevive app. Additionally, the entry page offers links to the registration and login pages, enabling users to create accounts or sign in to access EcoRevive's functionalities. These registration and login functionalities are connected to Firebase, ensuring secure user authentication and data management.

#### Entry Page
![Entry Page](docs/vertical-prototype/imgs/EntryPage.png)

#### Registration Page
![Registration Page](docs/vertical-prototype/imgs/RegisterPage.png)

#### Login Page
![Login Page](docs/vertical-prototype/imgs/LoginPage.png)

#### Firebase Interface
![Firebase Interface](docs/vertical-prototype/imgs/FirebaseInterface.png)


To provide a visual representation of the app's navigation flow, we have included several GIFs showcasing different scenarios. 

- **Login**: Demonstrates the successful login process, where a user enters their credentials and accesses the EcoRevive platform.
  
- **Login Failure**: We depict a scenario where the login attempt fails, typically due to incorrect credentials.

- **Register Failure**: This illustrates the process of registering for an account, highlighting a scenario where registration fails, possibly due to existing account conflicts.

- **Transition**: The Transition GIF provides an overview of transition between different pages within the app, showcasing the user experience of navigating through the platform.

Please find below the prototype in motion:

#### Login
![Login](docs/vertical-prototype/imgs/gifs/Login.gif)

#### Login Failure
![Login Failure](docs/vertical-prototype/imgs/gifs/LoginFail.gif)

#### Register Failure
![Register Failure](docs/vertical-prototype/imgs/gifs/RegisterFail.gif)

#### Transition
![Transition](docs/vertical-prototype/imgs/gifs/Transition.gif)


## Project Management

Welcome to our project management system! This system serves as a central hub for organizing and tracking our project's tasks and goals. We use a two-tiered approach, consisting of the Product Backlog and the Sprint Backlog, to effectively manage our project's development.

### Product Backlog
The Product Backlog contains a comprehensive list of all features, tasks, and user stories that need to be addressed throughout the project. Each item is prioritized based on its importance and estimated effort required for completion.

- The following image is our backlog at the start of the project development :

![Product Backlog Sprint#0](docs/diagrams/backlog.png/)


### Sprint Backlog
During sprint planning, we select items from the Product Backlog and move them into the Sprint Backlog, where they are actively worked on by our team throughtout the sprint. 

By utilizing this project management system, we ensure clear communication and efficient task allocation which facilitates the development of EcoRevive.

[Link to Project Board](https://github.com/orgs/FEUP-LEIC-ES-2023-24/projects/43/)
>>>>>>> 2031d45a00d2c526692ee275131e034ebe4d572a
