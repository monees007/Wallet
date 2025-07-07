import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/database.dart';
import 'widgets/edit_note.dart';

class NotesPage extends StatefulWidget {
  final AppDatabase database;
  final void Function(ThemeMode) onThemeChanged;


  const NotesPage({super.key, required this.database, required this.onThemeChanged});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  void _navigateToEditPage([Note? note]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditNotePage(database: widget.database, note: note),
      ),
    );
  }

  void _showDeleteConfirmation(Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note?'),
          content: Text('Are you sure you want to delete "${note.title}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error),
              child: const Text('Delete'),
              onPressed: () {
                widget.database.deleteNote(note.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Note "${note.title}" deleted'),
                      duration: const Duration(seconds: 2)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          // --- ADD THIS BUTTON ---
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            tooltip: 'Toggle Theme',
            onPressed: () {
              // Call the callback to change the theme globally
              final newTheme = isDarkMode ? ThemeMode.light : ThemeMode.dark;
              widget.onThemeChanged(newTheme);
            },
          ),
          // You can add other page-specific buttons here as well
        ],
      ),
      body: StreamBuilder<List<Note>>(
        stream: widget.database.watchAllNotes(),
        builder: (context, snapshot) {
          final notes = snapshot.data ?? [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No notes yet.',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add a new note.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              Color cardColor = Theme.of(context).colorScheme.surfaceVariant;
              final String? themeColorStr = note.theme;
              // 2. If a theme exists, parse it
              if (themeColorStr != null && themeColorStr.isNotEmpty) {
                try {
                  cardColor =
                      Color(int.parse(themeColorStr)).withOpacity(0.6);
                } catch (e) {
                  // Fallback to default if parsing fails for any reason
                  cardColor = Theme.of(context).colorScheme.surfaceVariant;
                }
              }

              // 3. Determine text color based on background brightness
              final brightness = ThemeData.estimateBrightnessForColor(cardColor);
              final textColor =
              brightness == Brightness.dark ? Colors.white70 : Colors.black87;

              // --- THEME IMPLEMENTATION END ---

              return Card(
                elevation: 0.0,
                color: cardColor, // Use the dynamic card color
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  title: Text(
                    note.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: textColor),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        DateFormat.yMMMd().format(note.createdAt),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: textColor.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note.content,
                        maxLines: 2, // Limit content preview to 2 lines
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                  onTap: () => _navigateToEditPage(note),
                  onLongPress: () => _showDeleteConfirmation(note),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEditPage(),
        label: const Text('New Note'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}