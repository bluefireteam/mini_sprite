import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:image/image.dart' as img;

class ImageImporterService {
  ImageImporterService();

  Future<(List<List<int>> pixels, List<Color> colors)?> importImage() async {
    const typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'png'],
    );
    final file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
    );

    if (file != null) {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image != null) {
        final colors = <Color>[];

        final pixels = List<List<int>>.generate(
          image.height,
          (_) => List<int>.generate(image.width, (index) => -1),
        );

        for (var y = 0; y < image.height; y++) {
          for (var x = 0; x < image.width; x++) {
            final pixel = image.getPixelSafe(x, y);

            final alpha = pixel.a.toInt();
            final red = pixel.r.toInt();
            final green = pixel.g.toInt();
            final blue = pixel.b.toInt();

            final color = Color.fromARGB(alpha, red, green, blue);

            if (!colors.contains(color) && color.a != 0) {
              colors.add(color);
            }

            final colorIndex = colors.indexOf(color);
            pixels[y][x] = colorIndex;
          }
        }

        return (pixels, colors);
      }
    }

    return null;
  }
}
