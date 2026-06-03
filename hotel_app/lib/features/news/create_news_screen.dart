import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'news_model.dart';

class CreateNewsScreen extends StatefulWidget {
  const CreateNewsScreen({super.key});

  @override
  State<CreateNewsScreen> createState() => _CreateNewsScreenState();
}

class _ContentBlockEdit {
  final String type;
  TextEditingController? textController;
  XFile? imageFile;
  Uint8List? previewBytes; // 🚀 Для безопасного отображения превью

  _ContentBlockEdit.text({String text = ''})
      : type = 'text',
        textController = TextEditingController(text: text);

  _ContentBlockEdit.image(this.imageFile, this.previewBytes) : type = 'image';

  void dispose() {
    textController?.dispose();
  }
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final _titleController = TextEditingController();
  final List<_ContentBlockEdit> _blocks = [_ContentBlockEdit.text()];
  TargetAudience _selectedAudience = TargetAudience.all;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    for (var block in _blocks) {
      block.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    final Uint8List bytes = await image.readAsBytes();

    // Ограничение для ПК (и веба/десктопа) в 250 кБ
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux)) {
      if (bytes.length > 250 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Размер картинки для ПК не должен превышать 250 кБ')),
          );
        }
        return;
      }
    }

    setState(() {
      // Добавляем блок изображения с байтами для превью
      _blocks.add(_ContentBlockEdit.image(image, bytes));
      _blocks.add(_ContentBlockEdit.text());
    });
  }

  Future<String> _uploadImage(XFile image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('news_images')
        .child('${DateTime.now().millisecondsSinceEpoch}_${image.name}');

    final bytes = await image.readAsBytes();

    // 1. Создаем задачу загрузки
    final uploadTask = ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));

    // 2. ЖЕСТКО дожидаемся окончания загрузки файла в хранилище
    final snapshot = await uploadTask;

    // 3. Берем ссылку именно у успешно загруженного объекта
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _publishNews() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите заголовок!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final List<NewsContentBlock> finalBlocks = [];

      for (var block in _blocks) {
        if (block.type == 'text') {
          final text = block.textController?.text.trim() ?? '';
          if (text.isNotEmpty) {
            finalBlocks.add(NewsContentBlock(type: 'text', value: text));
          }
        } else if (block.type == 'image' && block.imageFile != null) {
          final url = await _uploadImage(block.imageFile!);
          finalBlocks.add(NewsContentBlock(type: 'image', value: url));
        }
      }

      if (finalBlocks.isEmpty) {
        throw 'Добавьте хотя бы немного текста или картинку';
      }

      await FirebaseFirestore.instance.collection('news').add({
        'title': _titleController.text.trim(),
        'contentBlocks': finalBlocks.map((b) => b.toMap()).toList(),
        'targetAudience': _selectedAudience.name,
        'createdAt': FieldValue.serverTimestamp(),
        'isArchived': false,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Новость успешно опубликована! 🎉')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать новость'),
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: _pickImage,
            tooltip: 'Добавить картинку',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Заголовок',
                border: OutlineInputBorder(),
              ),
              maxLength: 60,
            ),
            const SizedBox(height: 16),
            const Text('Кто увидит новость:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<TargetAudience>(
              segments: const [
                ButtonSegment(value: TargetAudience.all, label: Text('Всем')),
                ButtonSegment(value: TargetAudience.guests, label: Text('Гостям')),
                ButtonSegment(value: TargetAudience.staff, label: Text('Персоналу')),
              ],
              selected: {_selectedAudience},
              onSelectionChanged: (Set<TargetAudience> newSelection) {
                setState(() => _selectedAudience = newSelection.first);
              },
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _blocks.length,
              itemBuilder: (context, index) {
                final block = _blocks[index];
                if (block.type == 'text') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: block.textController,
                      decoration: InputDecoration(
                        labelText: 'Текст секции ${index + 1}',
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                        suffixIcon: index > 0
                            ? IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => setState(() => _blocks.removeAt(index)),
                        )
                            : null,
                      ),
                      maxLines: null,
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: block.previewBytes != null
                              ? Image.memory(block.previewBytes!, height: 200, width: double.infinity, fit: BoxFit.cover)
                              : const SizedBox(height: 200, child: Center(child: Icon(Icons.image))),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => setState(() => _blocks.removeAt(index)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _publishNews,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Опубликовать', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}