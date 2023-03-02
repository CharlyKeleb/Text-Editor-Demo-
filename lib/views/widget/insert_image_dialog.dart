import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_editor_flutter/views/components/custom_dialog_template.dart';

class InsertImageDialog extends StatefulWidget {
  const InsertImageDialog({super.key});

  @override
  State<InsertImageDialog> createState() => _InsertImageDialogState();
}

class _InsertImageDialogState extends State<InsertImageDialog> {
  TextEditingController link = TextEditingController();
  TextEditingController alt = TextEditingController();
  bool picked = false;

  @override
  Widget build(BuildContext context) {
    return CustomDialogTemplate(
      body: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Image link'),
            ElevatedButton(
              onPressed: () => getImage(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: const Text('Open Library'),
            ),
          ],
        ),
        TextField(
          controller: link,
          decoration: const InputDecoration(
            hintText: '',
          ),
        ),
        Visibility(
          visible: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              const Text('Alt text (optional)'),
              TextField(
                controller: alt,
                decoration: const InputDecoration(
                  hintText: '',
                ),
              ),
            ],
          ),
        ),
      ],
      onDone: () => Navigator.pop(context, [link.text, alt.text, picked]),
      onCancel: () => Navigator.pop(context),
    );
  }

  Future getImage() async {
    final picker = ImagePicker();
    var image;

    image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800.0,
      maxHeight: 600.0,
    );
    if (image != null) {
      link.text = image.path;
      picked = true;
    }
  }
}
