import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'news_model.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class CreateNewsScreen extends StatefulWidget {
  const CreateNewsScreen({super.key});

  @override
  State<CreateNewsScreen> createState() => _CreateNewsScreenState();
}

class _ContentBlockEdit {
  final String type;
  TextEditingController? textController;
  XFile? imageFile;
  Uint8List? previewBytes;

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
    final l10n = AppLocalizations.of(context)!;
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    final Uint8List bytes = await image.readAsBytes();

    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux)) {
      if (bytes.length > 250 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.newsCreateImageSizeError)),
          );
        }
        return;
      }
    }

    setState(() {
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
    final uploadTask = ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _publishNews() async {
    final l10n = AppLocalizations.of(context)!;
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.newsCreateEnterHeadline)),
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
        throw l10n.newsCreateNoContent;
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
        SnackBar(content: Text(l10n.newsCreateSuccess)),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.newsCreateError(e.toString()))),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newsCreateTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: _pickImage,
            tooltip: l10n.newsCreateAddImage,
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
              decoration: InputDecoration(
                labelText: l10n.newsCreateHeadline,
                border: const OutlineInputBorder(),
              ),
              maxLength: 60,
            ),
            const SizedBox(height: 16),
            Text(l10n.newsCreateAudience, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<TargetAudience>(
              segments: [
                ButtonSegment(value: TargetAudience.all, label: Text(l10n.newsCreateAudienceAll)),
                ButtonSegment(value: TargetAudience.guests, label: Text(l10n.newsCreateAudienceGuests)),
                ButtonSegment(value: TargetAudience.staff, label: Text(l10n.newsCreateAudienceStaff)),
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
                        labelText: l10n.newsCreateSectionHint(index + 1),
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
                  : Text(l10n.newsCreatePublish, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
