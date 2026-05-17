import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

IconData getIcon(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();

  switch (ext) {
    case 'pdf':
      return Icons.picture_as_pdf_rounded;

    case 'doc':
    case 'docx':
    case 'txt':
    case 'rtf':
      return Icons.description_rounded;

    case 'xls':
    case 'xlsx':
    case 'csv':
      return Icons.table_chart_rounded;

    case 'ppt':
    case 'pptx':
      return Icons.slideshow_rounded;

    case 'mp3':
    case 'wav':
    case 'ogg':
    case 'm4a':
    case 'aac':
      return Icons.audio_file_rounded;

    case 'mp4':
    case 'mov':
    case 'avi':
    case 'mkv':
      return Icons.video_file_rounded;

    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'webp':
    case 'gif':
      return Icons.image_rounded;

    case 'zip':
    case 'rar':
    case '7z':
      return Icons.archive_rounded;

    case 'apk':
      return Icons.android_rounded;

    case 'dart':
    case 'js':
    case 'ts':
    case 'json':
    case 'xml':
    case 'yaml':
    case 'yml':
      return Icons.code_rounded;

    default:
      return Icons.insert_drive_file_rounded;
  }
}