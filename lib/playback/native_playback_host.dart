import '../models/play_info.dart';
import '../providers/nas_provider.dart';
import '../services/native_player_bridge.dart';
import 'playback_host.dart';
import 'playback_source.dart';

final class NativePlaybackHost implements PlaybackHost {
  const NativePlaybackHost();

  @override
  Future<bool> launch({
    required MpvMediaSource source,
    List<Map<String, dynamic>>? episodes,
    PlayInfoData? initialPlayInfo,
    String? danmakuFilePath,
    String? startSource,
    NasProvider? nas,
  }) {
    // 官方片头/片尾秒级配置（skip_opening/skip_ending）：随启动参数带给原生播放壳，
    // 供其计算精确跳转边界（避免回退到"最多 N 分钟"的粗窗口）。
    final playConfig = initialPlayInfo?.playConfig;
    return NativePlayerBridge.maybeLaunch(
      source.toMap(),
      episodes: episodes,
      initialPlayInfo: initialPlayInfo?.toJson(),
      danmakuFilePath: danmakuFilePath,
      startSource: startSource,
      introDurationSeconds: playConfig?.skipOpening,
      outroDurationSeconds: playConfig?.skipEnding,
      nas: nas,
    );
  }
}
