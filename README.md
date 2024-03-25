# EcoRevive Development Report

Welcome to the documentation pages of the EcoRevive!

You can find here details about our implementation, from a high-level vision to low-level implementation decisions, a kind of Software Development Report, organized by type of activities: 

* [Business modeling](#Business-Modelling) 
  * [Product Vision](#Product-Vision)
  * [Features and Assumptions](#Features-and-Assumptions)
  * [Elevator Pitch](#Elevator-pitch)
* [Requirements](#Requirements)
  * [User stories](#User-stories)
  * [Domain model](#Domain-model)
* [Architecture and Design](#Architecture-And-Design)
  * [Logical architecture](#Logical-Architecture)
  * [Physical architecture](#Physical-Architecture)
  * [Vertical prototype](#Vertical-Prototype)
* [Project management](#Project-Management)


Please contact us!

Thank you!

Carlos Sanches up202107694@up.pt
Afonso Fernandes up202207987@up.pt
João Rebelo up202107209@up.pt
João Lamas up202208948@up.pt

---
## Business Modelling

### Product Vision

- EcoRevive is a community-driven recycling platform that revolutionizes waste management by transforming discarded items into valuable resources, thereby promoting sustainable practices and actively contributing to the establishment of a circular economy.

### Features and Assumptions

#### Main Features

- Product Listing: Explore a diverse array of items available, starting with electronic waste and expanding to encompass a wide range of recyclable materials. Our intuitive interface ensures easy navigation.

- Advanced Product Filtering: Search with precision using our filtering system. Whether you're seeking specific conditions or items, robust filters help you find exactly what you need efficiently.

- Secure Login Registration: Join our community through a secure registration process. Your personal information is safeguarded, ensuring a trusted environment for all users to engage in sustainable exchange.

- Interactive User Chat: Foster meaningful connections and facilitate smooth transactions through our integrated chat feature. Engage in real-time conversations with fellow users to negotiate terms, ask questions, and coordinate exchanges, all within the convenience of our platform.

#### Assumptions
- Firebase database to store the users credentials aswell as products listing and others...

### Elevator Pitch

- For environmentally conscious individuals tired of the hassle of recycling, the "EcoRevive" app is a sustainable solution. It's a recycling platform that simplifies the process of finding, listing, and discussing recyclable products matching people that want to discard those products, with people looking for them. Unlike other recycling apps that focus solely on listings, our app emphasizes community engagement and social interaction around sustainability. With features like chat functionality and user ratings, EcoRevive fosters meaningful connections between users, making recycling both simple and social.


### Requirements

#### Functional Requirements:
**User Registration and Authentication:**
   - Secure registration and login process.

**Product Listing and Management:**
   - Ability to list, edit, and remove recyclable items.

**Advanced Product Filtering and Search:**
   - Robust filtering options for efficient item search.
   - Fast and accurate search functionality.

**Interactive User Chat:**
   - Real-time chat for negotiating exchanges.

#### Non-Functional Requirements:
**Security:**
   - Data integrity.
   - Robust user authentication mechanisms.

**Performance:**

   - Minimal response times for key actions.

**Scalability:**
   - Scalable architecture for growing user base and data volumes.

**User-friendly:**

   - Accessibility features for users with disabilities.


### Domain model

To better understand the context of the software system, it is very useful to have a simple UML class diagram with all the key concepts (names, attributes) and relationships involved of the problem domain addressed by your module. 
Also provide a short textual description of each concept (domain class). 

Example:
 <p align="center" justify="center">
  <img src="domain_model.png"/>
</p>


## Architecture and Design

The architecture and design of EcoRevive will adhere to the Model-View-Controller (MVC) architectural pattern, supplemented by several design patterns to ensure good practices of software development.

### MVC Architectural Pattern:

The Model-View-Controller (MVC) architectural pattern divides an application into three interconnected components, each with distinct responsibilities:

1. **Model:** Represents the application's data and business logic. In EcoRevive, the Model component manages data related to users, products, and interactions.

2. **View:** Represents the user interface (UI) elements of the application. The View component in EcoRevive encompasses screens for each feature and state of the app.

3. **Controller:** Acts as an intermediary between the Model and View components. It handles user input, processes requests, and updates the Model or View accordingly. In EcoRevive, the Controller component manages user interactions and orchestrates the flow of data between the Model and View.

### Design Patterns Consideration:

In the development of the EcoRevive app, we're considering the utilization of various design patterns. Two of the considered patterns are:

1. **Strategy Pattern:**
   - The Strategy pattern can be beneficial for implementing different algorithms for product filtering.

2. **Factory Method Pattern:**
   - The Factory Method pattern can be employed for adding different types of recyclable items or product objects to the products listing based on user input.

### Logical architecture

The logical architecture of EcoRevive outlines its core components and their interactions. It depicts the user interface (GUI), the logic handling core functionality, and the database for data management within the system (e.g user settings like the app color theme etc). Additionally, it integrates with Firebase for external services such as authentication or data storage. The diagram illustrates how user interactions flow. This logical architecture provides a high-level understanding of how EcoRevive's components work together to fulfill its functionalities.


## Components
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

![LogicalView](logical_arch.png)

### Physical architecture
The physical architecture section provides an overview of the high-level physical structure of the software system, including physical components, connections, software, and their dependencies. It also discusses the technologies considered for the implementation and justifies the selections made.

#### Technologies Considered:
- **Flutter**: A cross-platform framework for building mobile applications.
- **Firebase**: A Backend-as-a-Service (BaaS) platform providing services like authentication, database, and storage.

![DeploymentView](physical_arch.png)

### Vertical prototype
To help on validating all the architectural, design and technological decisions made, we usually implement a vertical prototype, a thin vertical slice of the system integrating as much technologies we can.

In this subsection please describe which feature, or part of it, you have implemented, and how, together with a snapshot of the user interface, if applicable.

At this phase, instead of a complete user story, you can simply implement a small part of a feature that demonstrates thay you can use the technology, for example, show a screen with the app credits (name and authors).