import 'dart:convert';
import 'package:epub_parser/epub_parser.dart';

/// Helper class for HTML file information
class HtmlFileInfo {
  final String fileName;
  final String modifiedHtmlContent;
  final int pageIndex;

  HtmlFileInfo(this.fileName, this.modifiedHtmlContent, this.pageIndex);
}

/// Extract HTML content with embedded images from EPUB book
Future<List<HtmlFileInfo>> extractHtmlContentWithEmbeddedImages(
    EpubBook epubBook) async {
  final EpubContent? bookContent = epubBook.Content;
  final Map<String, EpubByteContentFile>? images = bookContent?.Images;
  final Map<String, EpubTextContentFile>? htmlFiles = bookContent?.Html;

  final List<HtmlFileInfo> htmlContentList = [];
  if (htmlFiles != null) {
    int index = 0;
    for (final entry in htmlFiles.entries) {
      final String htmlContent = embedImagesInHtmlContent(entry.value, images);
      htmlContentList.add(HtmlFileInfo(entry.key, htmlContent, index++));
    }
  }

  return htmlContentList;
}

/// Embed images in HTML content as base64
String embedImagesInHtmlContent(EpubTextContentFile htmlFile,
    Map<String, EpubByteContentFile>? images) {
  String htmlContent = htmlFile.Content!;
  final imgRegExp = RegExp(r'<img[^>]*>');
  final Iterable<RegExpMatch> imgTags = imgRegExp.allMatches(htmlContent);

  for (final imgMatch in imgTags) {
    final String imgTag = imgMatch.group(0)!;
    final String imageName = extractImageNameFromTag(imgTag);
    final String? base64Image = convertImageToBase64(images?['Images/$imageName']);

    if (base64Image != null) {
      final String replacement =
          '<img src="data:image/jpg;base64,$base64Image" alt="$imageName" />';
      htmlContent = htmlContent.replaceFirst(imgTag, replacement);
    }
  }

  return htmlContent;
}

/// Reorder HTML files based on spine order
List<HtmlFileInfo> reorderHtmlFilesBasedOnSpine(
    List<HtmlFileInfo> htmlFiles, List<String>? spineItems) {
  if (spineItems == null || spineItems.isEmpty) return htmlFiles;

  final Map<String, HtmlFileInfo> htmlFilesMap = {
    for (final file in htmlFiles) file.fileName.replaceAll('Text/', ''): file,
  };

  final List<HtmlFileInfo> orderedFiles = [];
  for (final spineItem in spineItems) {
    final HtmlFileInfo? file = htmlFilesMap[spineItem.replaceFirst('x', '')];
    if (file != null) {
      orderedFiles.add(file);
    }
  }
  return orderedFiles;
}

/// Extract image name from image tag
String extractImageNameFromTag(String imageTag) {
  final RegExp imgSrcRegex = RegExp(r'src="([^"]+)"');
  final Match? match = imgSrcRegex.firstMatch(imageTag);

  String imageName = '';
  if (match != null && match.groupCount >= 1) {
    imageName = match.group(1)!;
    final List<String> pathSegments = imageName.split('/');
    if (pathSegments.isNotEmpty) {
      imageName = pathSegments.last;
    }
  }
  return imageName;
}

/// Convert image to base64
String? convertImageToBase64(EpubByteContentFile? imageFile) {
  if (imageFile == null) return null;
  return base64Encode(imageFile.Content!);
}

