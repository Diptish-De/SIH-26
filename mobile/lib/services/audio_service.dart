import 'dart:async';
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
      if (await _recorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/swarsanket_${DateTime.now().millisecondsSinceEpoch}.m4a';
        _currentFilePath = path;

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
        return true;
      }
    } catch (e) {
      // Fallback
    }
    return false;
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
      return path ?? _currentFilePath;
    }
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
