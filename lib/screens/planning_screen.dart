import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/lesson.dart';
import '../services/lessons_service.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  final LessonsService _lessonsService = LessonsService();
  final _notesController = TextEditingController();
  DateTime? _selectedDateTime;
  int _duration = 60;
  bool _creating = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time == null) return;
    setState(
      () => _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _createLesson() async {
    if (_selectedDateTime == null) return;
    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      user = null;
    }
    if (user == null) return;
    setState(() => _creating = true);
    final lesson = Lesson(
      id: '',
      studentId: user.uid,
      instructorId: null,
      startAt: _selectedDateTime!,
      durationMinutes: _duration,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );
    try {
      await _lessonsService.createLesson(lesson);
      _notesController.clear();
      setState(() => _selectedDateTime = null);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      user = null;
    }
    if (user == null)
      return const Scaffold(body: Center(child: Text('Non connecté')));

    return Scaffold(
      appBar: AppBar(title: const Text('Planning')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDateTime == null
                                ? 'Aucune date sélectionnée'
                                : 'Sélectionné: ${_selectedDateTime!.toLocal()}',
                          ),
                        ),
                        TextButton(
                          onPressed: _pickDateTime,
                          child: const Text('Choisir date'),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes (optionnel)',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Durée (minutes):'),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _duration,
                          items: const [30, 45, 60, 90]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text('$e'),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _duration = v ?? 60),
                        ),
                        const Spacer(),
                        _creating
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _createLesson,
                                child: const Text('Ajouter une leçon'),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mes leçons',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<Lesson>>(
                stream: _lessonsService.streamLessonsForUser(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  final lessons = snapshot.data ?? [];
                  if (lessons.isEmpty)
                    return const Center(child: Text('Aucune leçon programmée'));
                  return ListView.builder(
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final l = lessons[index];
                      return ListTile(
                        title: Text('Leçon: ${l.startAt.toLocal()}'),
                        subtitle: Text(
                          '${l.durationMinutes} min • ${l.status}${l.notes != null ? ' • ${l.notes}' : ''}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await _lessonsService.deleteLesson(l.id);
                          },
                        ),
                        onTap: () => Navigator.pushNamed(context, '/lesson'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
