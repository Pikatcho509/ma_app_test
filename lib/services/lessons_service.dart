import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson.dart';

class LessonsService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _lessons =>
      _db.collection('lessons');

  Stream<List<Lesson>> streamLessonsForUser(String uid) {
    final q1 = _lessons.where('studentId', isEqualTo: uid).orderBy('startAt');
    final q2 = _lessons
        .where('instructorId', isEqualTo: uid)
        .orderBy('startAt');
    // Merge two queries by listening to both and concatenating results
    // Simpler approach: listen to all lessons and filter client-side (OK for MVP)
    return _lessons
        .orderBy('startAt')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) =>
                    Lesson.fromDoc(d as DocumentSnapshot<Map<String, dynamic>>),
              )
              .where((l) => l.studentId == uid || l.instructorId == uid)
              .toList(),
        );
  }

  Future<void> createLesson(Lesson lesson) async {
    await _lessons.add(lesson.toMap());
  }

  Future<void> updateLesson(Lesson lesson) async {
    await _lessons.doc(lesson.id).update(lesson.toMap());
  }

  Future<void> deleteLesson(String id) async {
    await _lessons.doc(id).delete();
  }
}
