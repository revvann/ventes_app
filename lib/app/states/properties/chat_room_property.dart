import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:ventes/app/api/models/chat_model.dart';
import 'package:ventes/app/states/typedefs/chat_room_typedef.dart';
import 'package:ventes/core/states/state_property.dart';

class ChatRoomProperty extends StateProperty with PropertyMixin {
  int? userid;
  late String downloadPath;

  final Rx<List<Map<String, dynamic>>> _fileLoading = Rx([]);
  List<Map<String, dynamic>> get fileLoading => _fileLoading.value;
  Map<String, dynamic>? getFileProgress(String filename) => fileLoading.firstWhereOrNull((element) => element['filename'] == filename);
  bool isFileLoading(String filename) {
    Map<String, dynamic>? data = getFileProgress(filename);
    return !(data?['status'] == DownloadTaskStatus.complete || data?['status'] == DownloadTaskStatus.failed);
  }

  bool isFileDownloaded(String filename) => File("$downloadPath/$filename").existsSync();

  final Rx<List<Chat>> _chats = Rx<List<Chat>>([]);
  List<Chat> get chats => _chats.value;
  set chats(List<Chat> chats) => _chats.value = chats;

  final Rx<FilePickerResult?> _chatFiles = Rx(null);
  FilePickerResult? get chatFiles => _chatFiles.value;
  set chatFiles(FilePickerResult? file) => _chatFiles.value = file;

  Socket get socket => Get.find<Socket>();
  TextEditingController messageTEC = TextEditingController();
  final ReceivePort _port = ReceivePort();

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      _fileLoading.update((val) {
        try {
          Map<String, dynamic>? data = val?.firstWhereOrNull((element) => element.containsValue(taskId));
          if (data != null) {
            data['status'] = status;
            data['progress'] = progress;
          }
        } catch (e) {
          print(e);
        }
      });
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void sendMessage(Map<String, dynamic> data, {bool binary = false}) {
    if (binary) {
      socket.emitWithAck('message', data, binary: true);
    } else {
      socket.emit('message', data);
    }
  }

  String sizeShort(int price) {
    if (price < 1e3) {
      return "${price.toStringAsFixed(0)} B";
    } else if (price < 1e6) {
      return "${(price ~/ 1e3)} KB";
    } else if (price < 1e9) {
      return "${(price ~/ 1e6)} MB";
    } else {
      return "${(price ~/ 1e9)} GB";
    }
  }

  Future<String?> _findLocalPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<void> _prepareSaveDir() async {
    downloadPath = (await _findLocalPath())!;
    final savedDir = Directory(downloadPath);
    final hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  Future saveFile(String url) async {
    return FlutterDownloader.enqueue(
      url: url,
      savedDir: downloadPath,
      showNotification: true,
      openFileFromNotification: true,
      saveInPublicStorage: true,
    );
  }

  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) async {}

  @override
  void init() {
    super.init();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void ready() {
    super.ready();
    _prepareSaveDir();
    socket.on('message', listener.onMessage);
    socket.on('messagefailed', listener.onFailed);
    socket.on('messageerror', listener.onError);
    socket.on('readmessagefailed', listener.onFailed);
    socket.on('readmessageerror', listener.onError);
  }

  @override
  void close() {
    super.close();
    messageTEC.dispose();
    socket.off('message');
    _unbindBackgroundIsolate();
  }
}
