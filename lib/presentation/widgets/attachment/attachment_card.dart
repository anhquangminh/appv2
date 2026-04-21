
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AttachmentCard extends StatelessWidget {
  final String fileUrl;
  final VoidCallback onDownload;

  const AttachmentCard({
    super.key,
    required this.fileUrl,
    required this.onDownload,
  });

  bool get _isImage {
    final lower = fileUrl.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp');
  }

  String get _fileName => fileUrl.split('/').last;

  @override
  Widget build(BuildContext context) {

    return _isImage
                ? _ImageAttachment(
                    imageUrl: fileUrl,
                    onDownload: onDownload,
                  )
                : _FileAttachment(
                    fileName: _fileName,
                    fileUrl: fileUrl,
                    onDownload: onDownload,
                  );
  }
}

class _ImageAttachment extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDownload;

  const _ImageAttachment({
    required this.imageUrl,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullImage(context),
      child: Stack(
        children: [
          /// Image
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (c, w, p) =>
                    p == null ? w : const Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image, size: 36)),
              ),
            ),
          ),

          /// Small download icon
          Positioned(
            top: 6,
            right: 6,
            child: Material(
              color: Colors.black45,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onDownload,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.download,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}

class _FileAttachment extends StatelessWidget {
  final String fileName;
  final String fileUrl;
  final VoidCallback onDownload;

  const _FileAttachment({
    required this.fileName,
    required this.fileUrl,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                Icons.insert_drive_file_rounded,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),

              /// 👉 CLICK VÀO TÊN FILE → MỞ TRÌNH DUYỆT
              Expanded(
                child: InkWell(
                  onTap: () {
                    launchUrlString(
                      fileUrl,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              /// ⬇️ ICON DOWNLOAD → TẢI FILE
              IconButton(
                tooltip: 'Tải về',
                icon: Icon(
                  Icons.download_rounded,
                  color: theme.colorScheme.primary,
                ),
                onPressed: onDownload,
              ),
            ],
          ),
        ),
      ),
    );
  }
}