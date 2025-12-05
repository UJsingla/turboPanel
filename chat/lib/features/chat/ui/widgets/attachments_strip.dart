import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentsStrip extends StatelessWidget {
  const AttachmentsStrip({
    super.key,
    required this.imageFiles,
    required this.audioLabels,
    required this.onRemoveImage,
    required this.onRemoveAudio,
  });

  final List<XFile> imageFiles;
  final List<String> audioLabels;
  final void Function(int index) onRemoveImage;
  final void Function(int index) onRemoveAudio;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (audioLabels.isNotEmpty)
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: audioLabels.length,
              itemBuilder: (context, index) {
                final label = audioLabels[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Chip(
                    avatar: const Icon(
                      Icons.mic,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: Text(
                      label,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.black54,
                    deleteIcon: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                    onDeleted: () => onRemoveAudio(index),
                  ),
                );
              },
            ),
          ),
        if (imageFiles.isNotEmpty)
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: imageFiles.length,
              itemBuilder: (context, index) {
                final file = imageFiles[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.file(
                          File(file.path),
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => onRemoveImage(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
