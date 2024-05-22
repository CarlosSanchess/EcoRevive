
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:register/Auth/Auth.dart';
import 'package:register/Controllers/CloudStorageController.dart';
import 'package:register/Models/ProductInfo.dart';

import '../Models/Feedback.dart';
import '../Models/UsersInfo.dart';
import '../Models/ChatInfo.dart';
import '../Pages/myProducts.dart';

class FireStoreController {

  final db = FirebaseFirestore.instance;


  Future<String> addToProductsCollection(String productName, String description,
      String? category) async {
    final product = <String, dynamic>{
      "ProductName": productName,
      "Description": description,
      "Category": category,
      "Owner": await Auth().getUid()
    };

    final DocumentReference docRef = await db.collection("Products").add(
        product);
    return docRef.id;
  }

  Future<String> addFCMTokenToCollection(String fcmToken) async {
    final tokenInfo = <String, dynamic>{
      "UserID": await Auth().getUid(),
      "Token": fcmToken,
    };

    final DocumentReference docRef = await db.collection("FCMToken").add(
        tokenInfo);
    return docRef.id;
  }

  Future<String> getFCMTokenFromCollection(String uid) async {
    QuerySnapshot querySnapshot = await db
        .collection('FCMToken')
        .where('UserID', isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var tokenDocument = querySnapshot.docs.first;

      var fcmToken = (tokenDocument.data() as Map<String, dynamic>)['Token'];

      return fcmToken;
    } else {
      return "";
    }
  }

  Future<List<ProductInfo>> getOwnedProducts() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot ownedProducts = await db.collection('Products').where('Owner', isEqualTo: user.uid).get();
      List<ProductInfo> products = [];
      for (QueryDocumentSnapshot doc in ownedProducts.docs) {
        String name = doc['ProductName'];
        String category = doc['Category'];
        String description = doc['Description'];
        String productId = doc.id;
        String userId = doc['Owner'];

        String imageUrl = await CloudStorageController().getDownloadURL(
            'ProductImages/$productId');

        products.add(ProductInfo(productName: name, description: description, category: category, imageURL: imageUrl, UserID: userId, productID: productId));
      }
      return products;
    } else {
      throw 'Not logged in.';
    }
  }


  Future<void> deleteProduct(ProductInfo product) async {
    try {
      CloudStorageController().deleteImage(
          'ProductImages/${product.productID}');
      DocumentReference productRef = FirebaseFirestore.instance.collection(
          'Products').doc(product.productID);
      await productRef.delete();
      // Check if there exists a chat about this product
      QuerySnapshot chatSnapshot = await db
          .collection('Chats')
          .where('productId', isEqualTo: product.productID)
          .get();

      if (chatSnapshot.docs.isNotEmpty) {
        // If there exists a chat about this product, create a new product with the same info
        Map<String, dynamic> productData = {
          'ProductName': product.productName,
          'Description': product.description,
          'Category': product.category,
          'Owner': product.UserID,
        };

        await db.collection('DeletedProducts').doc(product.productID).set(productData);
        await db.collection('Products').doc(product.productID).delete();
      } else {
        // Otherwise, delete both the product and the image
        await CloudStorageController().deleteImage('ProductImages/${product.productID}');
        await db.collection('Products').doc(product.productID).delete();
      }
    } catch (error) {
      print("Error while deleting: $error");
    }
  }

  Future<void> deleteProductModerate(ProductInfo product) async {
    try {
      CloudStorageController().deleteImage(
          'ProductImages/${product.productID}');
      DocumentReference productRef = FirebaseFirestore.instance.collection(
          'Products').doc(product.productID);
      await productRef.delete();
    } catch (error) {
      print("Error while deleting: $error");
    }
  }

  Future<List<ProductInfo>> fetchProductsByCategory(String category) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot categoryProducts;
      if (category == "all") {
        categoryProducts = await db.collection('Products')
            .where('Owner', isNotEqualTo: user.uid)
            .get();
      } else {
        categoryProducts =
        await db.collection('Products').where('Category', isEqualTo: category)
            .where('Owner', isNotEqualTo: user.uid)
            .get();
      }
      List<ProductInfo> products = [];
      for (QueryDocumentSnapshot doc in categoryProducts.docs) {
        String name = doc['ProductName'];
        String productCategory = doc['Category'];
        String description = doc['Description'];
        String productId = doc.id;
        String userId = doc['Owner'];

        String imageUrl = await CloudStorageController().getDownloadURL(
            'ProductImages/$productId');
        products.add(ProductInfo(productName: name,
            description: description,
            category: productCategory,
            imageURL: imageUrl,
            UserID: userId,
            productID: productId));
      }
      return products;
    } else {
      throw 'Not logged in.';
    }
  }

  Future<List<ProductInfo>> fetchProductsBySearchTerm(String searchTerm,
      String category) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (searchTerm.isEmpty) {
        return fetchProductsByCategory(category);
      } else {
        if (category == "all") {
          QuerySnapshot productsSnapshot = await db
              .collection('Products')
              .where('Owner', isNotEqualTo: user.uid)
              .get();

          List<ProductInfo> products = [];

          for (QueryDocumentSnapshot doc in productsSnapshot.docs) {
            String name = doc['ProductName'];
            String productCategory = doc['Category'];
            String description = doc['Description'];
            String productId = doc.id;

            if (searchTerm.isEmpty ||
                name.toLowerCase().contains(searchTerm.toLowerCase())) {
              String imageUrl = await CloudStorageController().getDownloadURL(
                  'ProductImages/$productId');
              products.add(ProductInfo(productName: name,
                  description: description,
                  category: productCategory,
                  imageURL: imageUrl,
                  UserID: user.uid,
                  productID: productId));
            }
          }

          return products;
        }
        QuerySnapshot productsSnapshot = await db
            .collection('Products')
            .where('Owner', isNotEqualTo: user.uid)
            .where('Category', isEqualTo: category)
            .get();

        List<ProductInfo> products = [];

        for (QueryDocumentSnapshot doc in productsSnapshot.docs) {
          String name = doc['ProductName'];
          String productCategory = doc['Category'];
          String description = doc['Description'];
          String productId = doc.id;

          if (searchTerm.isEmpty ||
              name.toLowerCase().contains(searchTerm.toLowerCase())) {
            String imageUrl = await CloudStorageController().getDownloadURL(
                'ProductImages/$productId');
            products.add(ProductInfo(productName: name,
                description: description,
                category: productCategory,
                imageURL: imageUrl,
                UserID: user.uid,
                productID: productId));
          }
        }

        return products;
      }
    } else {
      throw 'Not logged in.';
    }
  }

  Future<List<FeedbackData>> getFeedbackForUser(String userId) async {
    try {
      final querySnapshot = await db
          .collection('Feedbacks')
          .where('revieweeId', isEqualTo: userId)
          .get();

      final List<FeedbackData> feedbackList = querySnapshot.docs
          .map((doc) => FeedbackData.fromFirestore(doc.data()))
          .toList();

      return feedbackList;
    } catch (error) {
      print("Error getting feedback for user: $error");
      throw error;
    }
  }

  Future<double> getUserOverallRating(String userId) async {
    try {
      final querySnapshot = await db
          .collection('Feedbacks')
          .where('revieweeId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return 0.0;
      }

      final List<FeedbackData> feedbackList = querySnapshot.docs
          .map((doc) => FeedbackData.fromFirestore(doc.data()))
          .toList();

      double overallRating = feedbackList
          .map((feedback) => feedback.rating)
          .reduce((value, element) => value + element) /
          feedbackList.length;

      return overallRating;
    } catch (error) {
      print("Error getting overall rating for user: $error");
      throw error;
    }
  }


  Future<List<ProductInfo>> fetchProductsBySearchTermAll(
      String searchTerm) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot productsSnapshot = await db
          .collection('Products')
          .get();

      List<ProductInfo> products = [];

      for (QueryDocumentSnapshot doc in productsSnapshot.docs) {
        String name = doc['ProductName'];
        String productCategory = doc['Category'];
        String description = doc['Description'];
        String productId = doc.id;
        String userId = doc['Owner'];

        if (searchTerm.isEmpty ||
            name.toLowerCase().contains(searchTerm.toLowerCase())) {
          String imageUrl = await CloudStorageController().getDownloadURL(
              'ProductImages/$productId');
          products.add(ProductInfo(productName: name,
              description: description,
              category: productCategory,
              imageURL: imageUrl,
              UserID: userId,
              productID: productId));
        }
      }

      return products;
    } else {
      throw 'Not logged in.';
    }
  }


  Future<List<ProductInfo>> fetchProductsAll() async {
    QuerySnapshot allProducts = await db.collection('Products').get();
    List<ProductInfo> products = [];
    for (QueryDocumentSnapshot doc in allProducts.docs) {
      String name = doc['ProductName'];
      String productCategory = doc['Category'];
      String description = doc['Description'];
      String productId = doc.id;
      String userId = doc['Owner'];

      String imageUrl = await CloudStorageController().getDownloadURL(
          'ProductImages/$productId');
      products.add(ProductInfo(productName: name,
          description: description,
          category: productCategory,
          imageURL: imageUrl,
          UserID: userId,
          productID: productId));
    }
    return products;
  }


  List<String> suspiciousWords = ['gun', 'kill', 'bomb', 'knife'];

  Future<List<ProductInfo>> fetchSuspiciousProducts() async {
    List<ProductInfo> suspiciousProducts = [];
    List<Future<List<ProductInfo>>> productFutures = [];

    for (String word in suspiciousWords) {
      productFutures.add(fetchProductsBySearchTermAll(word));
    }

    for (Future<List<ProductInfo>> future in productFutures) {
      List<ProductInfo> products = await future;
      suspiciousProducts.addAll(products);
    }

    return suspiciousProducts;
  }

  Future<String?> getEmailByUid(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(
          'Users').doc(uid).get();
      return userDoc.get('email');
    } catch (e) {
      print('Error getting email: $e');
      return null;
    }
  }

  Future<String?> getUsernameByUid(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(
          'Users').doc(uid).get();
      return userDoc.get('username');
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
  }

  Future<List<UsersInfo>> getAllUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
        'Users').get();

    List<UsersInfo> users = [];
    for (var doc in querySnapshot.docs) {
      UsersInfo user = UsersInfo(
          doc['id'],
          doc['email'],
          doc['username']
      );
      users.add(user);
    }
    return users;
  }

  Future<List<UsersInfo>> getNonAdminUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
        'Users').where('email', isNotEqualTo: 'mod@ecorevive.com').get();

    List<UsersInfo> users = [];
    for (var doc in querySnapshot.docs) {
      UsersInfo user = UsersInfo(
          doc['id'],
          doc['email'],
          doc['username']
      );
      users.add(user);
    }
    return users;
  }

  void removeUser(String uid) async {
    try {
      DocumentReference userRef = FirebaseFirestore.instance.collection('Users')
          .doc(uid);
      await userRef.delete();
      print('User with uid $uid successfully removed.');
    } catch (error) {
      print('Error removing user: $error');
    }
  }

  void removeAssociatedProducts(String uid) async {
    try {
      QuerySnapshot ownedProducts = await db.collection('Products').where(
          'Owner', isEqualTo: uid).get();
      for (QueryDocumentSnapshot doc in ownedProducts.docs) {
        doc.reference.delete();
      }
    } catch (error) {
      print('Error Removing Products: $error');
    }
  }

  Future<void> removeAssociatedRatings(String uid) async {

    final ratingsCollection = db.collection('Feedbacks');

    WriteBatch batch = db.batch();

    try {
      QuerySnapshot reviewerQuerySnapshot = await ratingsCollection
          .where('reviewerId', isEqualTo: uid)
          .get();
      for (QueryDocumentSnapshot doc in reviewerQuerySnapshot.docs) {
        batch.delete(doc.reference);
      }

      QuerySnapshot reviewedQuerySnapshot = await ratingsCollection
          .where('revieweeId', isEqualTo: uid)
          .get();
      for (QueryDocumentSnapshot doc in reviewedQuerySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      print('Error deleting documents: $e');
    }
  }

  void addToDisableCollection(UsersInfo usersInfo) async {
    removeUser(usersInfo.userID);
    final userInfo = <String, dynamic>{
      "UserID": usersInfo.userID,
      "Email": usersInfo.email,
      "DisplayName": usersInfo.displayName
    };

    final DocumentReference docRef = await db.collection("TemporaryBans").add(
        userInfo);
  }

  void addToUsersCollection(UsersInfo usersInfo) async {
    final userInfo = <String, dynamic>{
      "email": usersInfo.email,
      "id": usersInfo.userID,
      "username": usersInfo.displayName
    };

    final DocumentReference docRef = await db.collection("Users").add(
        userInfo);
  }


  void removeFromDisableCollection(String uid) async {
    final QuerySnapshot snapshot = await db
        .collection("TemporaryBans")
        .where("UserID", isEqualTo: uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final DocumentSnapshot docToDelete = snapshot.docs.first;
      await docToDelete.reference.delete();
    }
  }

  Future<List<UsersInfo>> getAllDisableUsers() async {
    QuerySnapshot querySnapshot = await db.collection('TemporaryBans').get();

    List<UsersInfo> users = [];
    for (var doc in querySnapshot.docs) {
      UsersInfo user = UsersInfo(
          doc['UserID'],
          doc['Email'],
          doc['DisplayName']
      );
      users.add(user);
    }
    return users;
  }

  Future<ProductInfo?> getProductInfoByID(String id) async {

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Products').doc(id).get();

      if (documentSnapshot.exists) {
        String description = documentSnapshot.get('Description');
        String category = documentSnapshot.get('Category');
        String imageURL = 'gs://vertical-prototype-70c6c.appspot.com/ProductImages/$id';
        String UserID = documentSnapshot.get('Owner');
        String productID = id;
        String productName = documentSnapshot.get('ProductName');

        return ProductInfo(
          productName: productName,
          description: description,
          category: category,
          imageURL: imageURL,
          UserID: UserID,
          productID: productID,
        );
    } else {
      print('No product found with ID: $id');
      return null;
    }
  }
  Future<String?> getUsernameByUidUser(String uid) async {
    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance.collection('Users').where('id', isEqualTo: uid).get();

      if (userQuery.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userQuery.docs.first;
        return userDoc.get('username');
      } else {
        print('No user found with uid: $uid');
        return null;
      }
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
  }

  Future<List<ChatInfo>> getAllChatInfo() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(
        'Chats').get();

    List<ChatInfo> chatInfo = [];
      for (var doc in querySnapshot.docs) {
        String? name1 = await getUsernameByUidUser(doc['participants'][0]);
        String? name2 = await getUsernameByUidUser(doc['participants'][1]);
        ProductInfo? product = await getProductInfoByID(doc['productId']);

        if (name1 != null && name2 != null && product != null) {
          ChatInfo chat = ChatInfo(
              chatId: doc.id,
              senderId: doc['participants'][0],
              receiverId:doc['participants'][1],
              nameID1: name1,
              nameID2: name2,
              productInfo: product
          );
          chatInfo.add(chat);
        }
      }
      return chatInfo;
    }

  void removeChat(String id) async {
    try {
      DocumentReference chatRef = FirebaseFirestore.instance.collection('Chats')
          .doc(id);
      await chatRef.delete();
    } catch (error) {
      print('Error removing user: $error');
    }
  }

}
