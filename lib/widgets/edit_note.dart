import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:wallet/services/database.dart';

enum SaveStatus { unsaved, saving, saved }

class EditNotePage extends StatefulWidget {
  final AppDatabase database;
  final Note? note;
  const EditNotePage({super.key, required this.database, this.note});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Note? _currentNote;
  Timer? _debounce;
  SaveStatus _saveStatus = SaveStatus.saved;
  Color? _selectedColor;
  List<String> _imagePaths = [];

  final List<Color?> _themeColors = [
    null, // Default
    Colors.red[200], Colors.pink[200], Colors.deepPurple[200],
    Colors.indigo[200], Colors.blue[300], Colors.teal[200],
    Colors.green[300], Colors.orange[300], Colors.brown[300], Colors.grey[500],
  ];

  bool get _isEditing => _currentNote != null;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _currentNote = widget.note;
      _titleController.text = _currentNote!.title;
      _contentController.text = _currentNote!.content;
      _imagePaths = List<String>.from(_currentNote!.images);

      final themeColorStr = _currentNote!.theme;
      if (themeColorStr != null && themeColorStr.isNotEmpty) {
        try {
          _selectedColor = Color(int.parse(themeColorStr));
        } catch (e) {
          _selectedColor = null;
        }
      }
    }
    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    setState(() => _saveStatus = SaveStatus.unsaved);
    _debounce = Timer(const Duration(milliseconds: 800), _performSave);
  }

  void _onColorSelected(Color? color) {
    setState(() => _selectedColor = color);
    _onTextChanged();
  }

  Future<void> _saveNow() async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    await _performSave();
  }

  Future<void> _performSave() async {
    if (_titleController.text.isEmpty || !mounted) return;

    setState(() => _saveStatus = SaveStatus.saving);

    final title = _titleController.text;
    final content = _contentController.text;
    final theme = _selectedColor?.value.toString();
    final images = _imagePaths;

    try {
      if (_isEditing) {
        final noteCompanion = NotesCompanion(
          id: Value(_currentNote!.id),
          title: Value(title),
          content: Value(content),
          theme: Value(theme),
          images: Value(images),
        );
        await widget.database.updateNote(noteCompanion);
      } else {
        final noteCompanion = NotesCompanion(
          title: Value(title),
          content: Value(content),
          createdAt: Value(DateTime.now()),
          theme: Value(theme),
          images: Value(images),
        );
        final newId = await widget.database.addNote(noteCompanion);
        final newNote = await widget.database.getNoteById(newId);
        if (mounted) setState(() => _currentNote = newNote);
      }

      if (mounted) setState(() => _saveStatus = SaveStatus.saved);
    } catch (e) {
      if (mounted) setState(() => _saveStatus = SaveStatus.unsaved);
    }
  }

  Future<void> _pickAndAddImage() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(imageFile.path);
    final savedImage = await File(imageFile.path).copy('${appDir.path}/$fileName');

    setState(() => _imagePaths.add(savedImage.path));
    await _saveNow();
  }

  void _showRemoveImageDialog(String path, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Image?'),
        content: const Text('This will permanently delete the image from this note.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Remove'),
            onPressed: () async {
              Navigator.of(context).pop();
              setState(() => _imagePaths.removeAt(index));
              await File(path).delete();
              await _saveNow();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultBg = Theme.of(context).scaffoldBackgroundColor;
    final bgColor = _selectedColor ;//?.withValues(alpha: 0.6) ?? defaultBg;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.black,),
            onPressed: _pickAndAddImage,
            label: const Text('Add Image',style: TextStyle(color: Colors.black),),
          ),
          _buildSaveButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration.collapsed(hintText: 'Title'),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 8),
                  if (_isEditing)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        DateFormat.yMMMd().add_jm().format(_currentNote!.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
                      ),
                    ),
                  _buildColorPicker(),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration.collapsed(hintText: 'Your note...'),
                    style: Theme.of(context).textTheme.bodyLarge,
                    keyboardType: TextInputType.multiline,
                    maxLines: null, // Allows the field to grow indefinitely
                  ),
                ],
              ),
            ),
          ),
          _buildImageSliverList(), // Display the image gallery
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    final bool isSaving = _saveStatus == SaveStatus.saving;
    final String text;
    final IconData icon;

    switch (_saveStatus) {
      case SaveStatus.saved: text = 'Saved'; icon = Icons.check; break;
      case SaveStatus.saving: text = 'Saving'; icon = Icons.sync; break;
      case SaveStatus.unsaved: text = 'Save'; icon = Icons.save; break;
    }

    return ElevatedButton.icon(
      onPressed: isSaving ? null : _saveNow,
      icon: isSaving
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(icon, size: 16),
      label: Text(text),
    );
  }

  Widget _buildColorPicker() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _themeColors.length,
        itemBuilder: (context, index) {
          final color = _themeColors[index];
          final isSelected = color == _selectedColor;

          return GestureDetector(
            onTap: () => _onColorSelected(color),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color ?? Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                ),
              ),
              child: isSelected && color != null ? const Icon(Icons.check, size: 20, color: Colors.white) : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSliverList() {
    if (_imagePaths.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final path = _imagePaths[index];
            return GestureDetector(
              onLongPress: () => _showRemoveImageDialog(path, index),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(path),
                    width: double.infinity, // Ensures full width
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const AspectRatio(aspectRatio: 16/9, child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            );
          },
          childCount: _imagePaths.length,
        ),
      ),
    );
  }
}