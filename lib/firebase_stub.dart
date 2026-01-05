// Minimal Firebase stubs to allow CI debug apk builds without real Firebase
import 'dart:async';

class Firebase {
  static Future<void> initializeApp() async {}
}

class User {
  final String? email;
  final String uid;
  User({this.email, String? uid}) : uid = uid ?? 'stub-uid';
}

class UserCredential {
  final User? user;
  UserCredential({this.user});
}

class FirebaseAuth {
  static final FirebaseAuth instance = FirebaseAuth();
  Stream<User?> authStateChanges() => const Stream.empty();
  User? get currentUser => null;
  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    return UserCredential(user: User(email: email));
  }

  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    return UserCredential(user: User(email: email));
  }

  Future<void> signOut() async {}
}

class FieldValue {
  static dynamic serverTimestamp() => null;
}

class Timestamp {
  DateTime toDate() => DateTime.now();
  static Timestamp fromDate(DateTime d) => Timestamp();
}

class DocumentSnapshot<T> {
  final String id;
  final T? _data;
  DocumentSnapshot({this.id = '', T? data}) : _data = data;
  T? data() => _data;
}

class DocumentReference<T> {
  final String id;
  DocumentReference({this.id = ''});
  Future<DocumentSnapshot<T>> get() async => DocumentSnapshot<T>(id: id);
  Future<void> set(Map<String, dynamic> data) async {}
  Future<void> update(Map<String, dynamic> data) async {}
  Future<void> delete() async {}
}

class QuerySnapshot<T> {
  final List<DocumentSnapshot<T>> docs;
  QuerySnapshot([this.docs = const []]);
}

class Query<T> {
  Stream<QuerySnapshot<T>> snapshots() => const Stream.empty();
  Query<T> orderBy(String field) => this;
}

class CollectionReference<T> {
  CollectionReference();
  Query<T> orderBy(String field) => Query<T>();
  Query<T> where(String field, {required dynamic isEqualTo}) => Query<T>();
  DocumentReference<T> doc([String? id]) => DocumentReference<T>(id: id ?? '');
  Future<DocumentReference<T>> add(Map<String, dynamic> data) async =>
      DocumentReference<T>(id: 'added-id');
}

class FirebaseFirestore {
  static final FirebaseFirestore instance = FirebaseFirestore();
  CollectionReference<Map<String, dynamic>> collection(String name) =>
      CollectionReference<Map<String, dynamic>>();
}
