import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  bool _isRecording = false;
  bool _isPaused = false;
  String? _currentFilePath;

  bool get isRecording => _isRecording;
  bool get isPaused => _isPaused;
  String? get currentFilePath => _currentFilePath;

  Stream<Amplitude> get onAmplitudeChanged => _recorder.onAmplitudeChanged(const Duration(milliseconds: 80));

  Future<bool> start() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      debugPrint('SwarSanket microphone permission: $hasPermission');

      if (!hasPermission) {
        debugPrint('SwarSanket: microphone permission denied');
        return false;
      }

      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/swarsanket_${DateTime.now().millisecondsSinceEpoch}.m4a';
      _currentFilePath = path;
      debugPrint('SwarSanket recording path: $path');

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      _isRecording = true;
      _isPaused = false;
      debugPrint('SwarSanket: recording started successfully');
      return true;
    } catch (e, stackTrace) {
      debugPrint('SwarSanket recording ERROR: $e');
      debugPrint('$stackTrace');
      return false;
    }
  }

  Future<void> pause() async {
    if (_isRecording && !_isPaused) {
      await _recorder.pause();
      _isPaused = true;
    }
  }

  Future<void> resume() async {
    if (_isRecording && _isPaused) {
      await _recorder.resume();
      _isPaused = false;
    }
  }

  Future<String?> stop() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      _isRecording = false;
      _isPaused = false;
      final resolvedPath = path ?? _currentFilePath;
      debugPrint('SwarSanket: recording stopped. Output file path: $resolvedPath');
      return resolvedPath;
    }
    debugPrint('SwarSanket: stop called but not currently recording');
    return null;
  }

  Future<void> playRecording(String? path, {Function()? onComplete}) async {
    final filePath = path ?? _currentFilePath;
    if (filePath != null) {
      await _player.stop();
      _player.onPlayerComplete.listen((_) => onComplete?.call());
      await _player.play(DeviceFileSource(filePath));
    }
  }

  Future<void> stopPlayback() async {
    await _player.stop();
  }

  void dispose() {
    _recorder.dispose();
    _player.dispose();
  }
}

