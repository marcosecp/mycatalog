

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterbook/models/product.dart';
import 'package:flutterbook/models/user.dart';
import 'package:flutterbook/notifiers/auth_notifier.dart';
import 'package:flutterbook/notifiers/product_notifier.dart';
import 'package:uuid/uuid.dart';

logIn(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

signUp(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.displayName;

    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await firebaseUser.updateProfile(updateInfo);

      await firebaseUser.reload();

      print("Sign up: $firebaseUser");

      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setUser(currentUser);
    }
  }
}

signOut(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));
  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

getProducts(ProductNotifier productNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance.collection('Products').getDocuments();
  List<Product> _productList = [];
  snapshot.documents.forEach((document) {
    Product product = Product.fromMap(document.data);
    _productList.add(product);
  });
  productNotifier.productList = _productList;
}

uploadProductandImage(Product product, bool isUpdating, {File localFile}) async {
  if (localFile != null) {
     print('uploading image');
     var fileExtension = path.extension(localFile.path);
     var uuid = Uuid().v4();

     final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('images/products/$uuid$fileExtension');
     
     await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError){
       print(onError);
       return false;
     });
     String url = await firebaseStorageRef.getDownloadURL();
     _uploadProduct(product, isUpdating, imageUrl: url);
  } else {
    _uploadProduct(product, isUpdating);
  }
}

_uploadProduct(Product product, bool isUpdating, {String imageUrl}) async {
  CollectionReference  productRef = Firestore.instance.collection('Products');
  if (imageUrl != null) {
    product.image = imageUrl;
  }

  if (isUpdating) {
    product.updatedAt = Timestamp.now();
    await productRef.document(product.id).updateData(product.toMap());
  } else {
    product.createdAt = Timestamp.now();
    DocumentReference documentRef = await productRef.add(product.toMap());
    product.id = documentRef.documentID;
    await documentRef.setData(product.toMap(), merge: true);
  }
}