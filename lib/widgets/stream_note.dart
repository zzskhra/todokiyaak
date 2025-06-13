import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/widgets/task_widget.dart';
import '../data/firestor.dart';

class Stream_note extends StatelessWidget {
  final bool done;
  final String searchQuery;

  const Stream_note(
    this.done, {
    this.searchQuery = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore_Datasource().stream(done),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              done ? 'No completed tasks yet.' : 'No tasks for today.',
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }

        // Ambil data
        final allNotes = Firestore_Datasource().getNotes(snapshot);

        // Filter berdasarkan teks pencarian (case-insensitive)
        final filteredNotes = allNotes.where((note) {
          final title = note.title?.toLowerCase() ?? '';
          final query = searchQuery.toLowerCase();
          return title.contains(query);
        }).toList();

        if (filteredNotes.isEmpty) {
          return const Center(
            child: Text(
              'No matching tasks found.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredNotes.length,
          itemBuilder: (context, index) {
            final note = filteredNotes[index];

            return Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.redAccent,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (_) {
                Firestore_Datasource().delet_note(note.id);
              },
              child: Task_Widget(
                note,
                strikethrough: done, // <== kasih coretan jika selesai
              ),
            );
          },
        );
      },
    );
  }
}
