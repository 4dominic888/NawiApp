import 'dart:io';
import 'package:logger/logger.dart';

final _log = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

const _ticksPerSecond = 100;

class ResourceUsage {
  final int memoryKb;
  final int userCpuTicks;
  final int systemCpuTicks;
  final int totalCpuTicks;
  final int idleCpuTicks;

  const ResourceUsage({
    required this.memoryKb,
    required this.userCpuTicks,
    required this.systemCpuTicks,
    required this.totalCpuTicks,
    required this.idleCpuTicks,
  });

  ResourceUsage operator -(ResourceUsage other) {
    return ResourceUsage(
      memoryKb: memoryKb - other.memoryKb,
      userCpuTicks: userCpuTicks - other.userCpuTicks,
      systemCpuTicks: systemCpuTicks - other.systemCpuTicks,
      totalCpuTicks: totalCpuTicks - other.totalCpuTicks,
      idleCpuTicks: idleCpuTicks - other.idleCpuTicks,
    );
  }

  const ResourceUsage.zero() : this(memoryKb: 0, userCpuTicks: 0, systemCpuTicks: 0, totalCpuTicks: 0, idleCpuTicks: 0);

  double get memoryGb => memoryKb / (1024 * 1024);
  double get userCpuSeconds => userCpuTicks / _ticksPerSecond;
  double get systemCpuSeconds => systemCpuTicks / _ticksPerSecond;

  factory ResourceUsage.capture() {
    try {
      final statusLines = File('/proc/self/status').readAsLinesSync();
      final statLine = File('/proc/self/stat').readAsStringSync();
      final procStatLine = File('/proc/stat')
          .readAsLinesSync()
          .firstWhere((line) => line.startsWith('cpu '));

      final memoryLine = statusLines.firstWhere(
        (line) => line.startsWith('VmRSS:'),
        orElse: () => 'VmRSS:\t0 kB',
      );

      final memoryKb = int.tryParse(RegExp(r'\d+').firstMatch(memoryLine)?.group(0) ?? '0') ?? 0;

      final statParts = statLine.split(' ');
      final userCpuTicks = int.tryParse(statParts[13]) ?? 0;
      final systemCpuTicks = int.tryParse(statParts[14]) ?? 0;

      final cpuParts = procStatLine.split(RegExp(r'\s+')).skip(1).map(int.parse).toList();
      final idleTicks = cpuParts[3] + cpuParts[4]; //* idle + iowait
      final totalTicks = cpuParts.reduce((a, b) => a + b);

      return ResourceUsage(
        memoryKb: memoryKb,
        userCpuTicks: userCpuTicks,
        systemCpuTicks: systemCpuTicks,
        totalCpuTicks: totalTicks,
        idleCpuTicks: idleTicks,
      );
    } catch (e) {
      _log.w('Error al capturar uso de recursos: $e');
      return ResourceUsage.zero();
    }
  }

  void logDiff(ResourceUsage before) {
    final deltaKb = before.memoryKb - memoryKb;
    final deltaGb = deltaKb / (1024 * 1024);

    final deltaUserTicks = userCpuTicks - before.userCpuTicks;
    final deltaSystemTicks = systemCpuTicks - before.systemCpuTicks;

    final userSeconds = deltaUserTicks / _ticksPerSecond;
    final systemSeconds = deltaSystemTicks / _ticksPerSecond;

    _log.i('📊 RAM usada: +$deltaKb kB (${deltaGb.toStringAsFixed(3)} GB)');
    _log.i('🧠 Tiempo CPU: ${userSeconds.toStringAsFixed(2)}s (user), ${systemSeconds.toStringAsFixed(2)}s (system)');
  }
}

Future<void> measureResourceUsage(Future<void> Function() task, {ResourceUsage? diffSubtract, int? diffMillis}) async {
  if (!Platform.isLinux) {
    _log.w('Medición de recursos solo disponible en Linux.');
    await task();
    return;
  }

  final usageBefore = ResourceUsage.capture();
  final stopwatch = Stopwatch()..start();

  await task();

  stopwatch.stop();
  var usageAfter = ResourceUsage.capture();
  final usageDiff = usageAfter - usageBefore;
  
  usageAfter = usageDiff - (diffSubtract ?? ResourceUsage.zero());
  final stopWatchDiff = stopwatch.elapsedMilliseconds - (diffMillis ?? 0);

  _log.i('⏱️ Tiempo total: $stopWatchDiff ms');
  usageAfter.logDiff(usageBefore);
}