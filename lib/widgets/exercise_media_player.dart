import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../core/app_theme.dart';
import '../models/workout.dart';

class ExerciseMediaPlayer extends StatefulWidget {
  const ExerciseMediaPlayer({
    super.key,
    required this.exercise,
    required this.gender,
  });

  final Exercise exercise;
  final Gender gender;

  @override
  State<ExerciseMediaPlayer> createState() => _ExerciseMediaPlayerState();
}

class _ExerciseMediaPlayerState extends State<ExerciseMediaPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _initialize;
  bool _failed = false;

  bool get _shouldUseVideo =>
      widget.gender == Gender.female &&
      widget.exercise.videoAsset != null &&
      widget.exercise.videoAsset!.isNotEmpty;

  bool get _hasExerciseImage =>
      widget.gender == Gender.female &&
      widget.exercise.imageAsset != null &&
      widget.exercise.imageAsset!.isNotEmpty;

  String get _fallbackAsset =>
      _hasExerciseImage ? widget.exercise.imageAsset! : widget.gender.asset;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  void didUpdateWidget(covariant ExerciseMediaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.videoAsset != widget.exercise.videoAsset ||
        oldWidget.gender != widget.gender) {
      unawaited(_controller?.dispose());
      _controller = null;
      _initialize = null;
      _failed = false;
      _loadVideo();
    }
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  void _loadVideo() {
    if (!_shouldUseVideo) return;

    final controller = VideoPlayerController.asset(widget.exercise.videoAsset!);
    _controller = controller;
    _initialize = controller
        .initialize()
        .then((_) {
          controller.setLooping(true);
          if (mounted) setState(() {});
        })
        .catchError((Object _) {
          if (mounted) setState(() => _failed = true);
        });
  }

  Future<void> _toggle() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }
    if (mounted) setState(() {});
  }

  Future<void> _replay() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    await controller.seekTo(Duration.zero);
    await controller.play();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldUseVideo || _failed) return _fallbackImage();

    final initialize = _initialize;
    final controller = _controller;
    if (initialize == null || controller == null) return _fallbackImage();

    return FutureBuilder<void>(
      future: initialize,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !controller.value.isInitialized) {
          return Stack(
            fit: StackFit.expand,
            children: [
              _fallbackImage(),
              const Center(child: CircularProgressIndicator()),
            ],
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    onPressed: () => unawaited(_replay()),
                    icon: const Icon(Icons.replay_rounded),
                    tooltip: 'Replay video',
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    onPressed: () => unawaited(_toggle()),
                    icon: Icon(
                      controller.value.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    tooltip: controller.value.isPlaying
                        ? 'Pause video'
                        : 'Play video',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      _fallbackAsset,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      errorBuilder: (_, _, _) {
        if (!_hasExerciseImage) {
          return Image.asset(
            widget.gender.asset,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          );
        }

        return const ColoredBox(
          color: AppColors.navy,
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.white70,
              size: 56,
            ),
          ),
        );
      },
    );
  }
}
