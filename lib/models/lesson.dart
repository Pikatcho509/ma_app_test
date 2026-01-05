import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final String id;
  final String studentId;
  final String? instructorId;
  final DateTime startAt;
  final int durationMinutes;
  final String status;
  final String? notes;

  Lesson({
    required this.id,
    required this.studentId,
    this.instructorId,
    required this.startAt,
    this.durationMinutes = 60,
    this.status = 'scheduled',
    this.notes,
  });

  factory Lesson.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final ts = data['startAt'] as Timestamp;
    return Lesson(
      id: doc.id,
      studentId: data['studentId'] as String,
      instructorId: data['instructorId'] as String?,
      startAt: ts.toDate(),
      durationMinutes: (data['durationMinutes'] ?? 60) as int,
      status: (data['status'] ?? 'scheduled') as String,
      notes: data['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'studentId': studentId,
    'instructorId': instructorId,
    'startAt': Timestamp.fromDate(startAt),
    'durationMinutes': durationMinutes,
    'status': status,
    'notes': notes,
  };
}
