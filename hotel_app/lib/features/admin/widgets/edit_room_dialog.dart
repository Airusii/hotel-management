import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/rooms/room_model.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/services/services_provider.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class EditRoomDialog extends ConsumerStatefulWidget {
  final Room room;
  const EditRoomDialog({super.key, required this.room});

  @override
  ConsumerState<EditRoomDialog> createState() => _EditRoomDialogState();
}

class _RoomImageSource {
  final String? url;
  final Uint8List? bytes;
  final XFile? file;

  _RoomImageSource({this.url, this.bytes, this.file});
}

class _EditRoomDialogState extends ConsumerState<EditRoomDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  
  String? _selectedTypeId;
  final List<String> _selectedServiceIds = [];
  
  _RoomImageSource? _mainImage;
  final List<_RoomImageSource> _galleryImages = [];
  bool _isSubmitting = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.room.name);
    _priceController = TextEditingController(text: widget.room.price.toString());
    _selectedTypeId = widget.room.typeId;
    _selectedServiceIds.addAll(widget.room.services);
    
    if (widget.room.image != null) {
      _mainImage = _RoomImageSource(url: widget.room.image);
    }
    
    for (var url in widget.room.images) {
      _galleryImages.add(_RoomImageSource(url: url));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickMainImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _mainImage = _RoomImageSource(file: image, bytes: bytes));
    }
  }

  Future<void> _pickGalleryImages() async {
    final List<XFile> images = await _picker.pickMultiImage(imageQuality: 70);
    if (images.isNotEmpty) {
      for (var image in images) {
        final bytes = await image.readAsBytes();
        setState(() => _galleryImages.add(_RoomImageSource(file: image, bytes: bytes)));
      }
    }
  }

  Future<String> _uploadToStorage(XFile image, String subfolder) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('rooms')
        .child(subfolder)
        .child('${DateTime.now().millisecondsSinceEpoch}_${image.name}');
    
    final bytes = await image.readAsBytes();
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }

  void _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate() || _selectedTypeId == null) return;

    setState(() => _isSubmitting = true);

    try {
      String? mainUrl = _mainImage?.url;
      if (_mainImage?.file != null) {
        mainUrl = await _uploadToStorage(_mainImage!.file!, 'thumbnails');
      }

      List<String> galleryUrls = [];
      for (var img in _galleryImages) {
        if (img.url != null) {
          galleryUrls.add(img.url!);
        } else if (img.file != null) {
          final url = await _uploadToStorage(img.file!, 'gallery');
          galleryUrls.add(url);
        }
      }

      final updatedRoom = widget.room.copyWith(
        name: _nameController.text.trim(),
        typeId: _selectedTypeId!,
        price: double.parse(_priceController.text),
        image: mainUrl,
        images: galleryUrls,
        services: _selectedServiceIds,
      );

      await ref.read(roomsRepositoryProvider).updateRoom(updatedRoom);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final roomTypesAsync = ref.watch(roomTypesStreamProvider);
    final servicesAsync = ref.watch(servicesStreamProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Редактировать номер'),
      content: _isSubmitting 
        ? const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()))
        : SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.adminRoomsNameLabel),
                validator: (val) => val!.isEmpty ? l10n.adminRoomsEnterName : null,
              ),
              const SizedBox(height: 16),
              roomTypesAsync.when(
                data: (types) => DropdownButtonFormField<String>(
                  value: _selectedTypeId,
                  hint: Text(l10n.adminRoomsSelectTypeHint),
                  items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) => setState(() => _selectedTypeId = val),
                  validator: (val) => val == null ? l10n.adminRoomsSelectType : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(l10n.adminRoomsErrorTypes),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: l10n.adminRoomsPriceLabel),
                keyboardType: TextInputType.number,
                validator: (val) => (double.tryParse(val ?? '') ?? 0) <= 0 ? l10n.adminRoomsEnterPrice : null,
              ),
              const SizedBox(height: 24),

              const Text('Обложка номера', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickMainImage,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: _mainImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _mainImage!.bytes != null
                        ? Image.memory(_mainImage!.bytes!, fit: BoxFit.cover, width: double.infinity, height: 120)
                        : Image.network(_mainImage!.url!, fit: BoxFit.cover, width: double.infinity, height: 120),
                  )
                      : const Icon(Icons.add_a_photo, size: 32),
                ),
              ),
              const SizedBox(height: 24),

              const Text('Галерея', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._galleryImages.asMap().entries.map((entry) {
                    final img = entry.value;
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: img.bytes != null 
                            ? Image.memory(img.bytes!, width: 70, height: 70, fit: BoxFit.cover)
                            : Image.network(img.url!, width: 70, height: 70, fit: BoxFit.cover),
                        ),
                        Positioned(
                          right: -2,
                          top: -2,
                          child: GestureDetector(
                            onTap: () => setState(() => _galleryImages.remove(img)),
                            child: const CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Icon(Icons.close, size: 12, color: Colors.white)),
                          ),
                        ),
                      ],
                    );
                  }),
                  GestureDetector(
                    onTap: _pickGalleryImages,
                    child: Container(
                      width: 70, height: 70,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_photo_alternate_outlined),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(l10n.adminRoomsServices, style: const TextStyle(fontWeight: FontWeight.bold)),
              servicesAsync.when(
                data: (services) => Wrap(
                  spacing: 8,
                  children: services.map((s) => FilterChip(
                    label: Text(s.name),
                    selected: _selectedServiceIds.contains(s.id),
                    onSelected: (selected) {
                      setState(() {
                        selected ? _selectedServiceIds.add(s.id) : _selectedServiceIds.remove(s.id);
                      });
                    },
                  )).toList(),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (err, __) => Text('Error: $err'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.adminRoomsCancel)),
        ElevatedButton(onPressed: _submit, child: const Text('Сохранить')),
      ],
    );
  }
}
