import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../core/app_theme.dart';
import '../data/workout_data.dart';
import '../models/workout.dart';

class ExerciseMediaPlayer extends StatefulWidget {
  const ExerciseMediaPlayer({
    super.key,
    required this.exercise,
    required this.gender,
    this.videoEnabled = true,
    this.autoPlay = false,
    this.showControls = true,
  });

  final Exercise exercise;
  final Gender gender;
  final bool videoEnabled;
  final bool autoPlay;
  final bool showControls;

  @override
  State<ExerciseMediaPlayer> createState() => _ExerciseMediaPlayerState();
}

class _ExerciseMediaPlayerState extends State<ExerciseMediaPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _initialize;
  bool _failed = false;

  bool get _shouldUseVideo =>
      widget.videoEnabled &&
      widget.gender == Gender.female &&
      _resolvedVideoAsset != null &&
      _resolvedVideoAsset!.isNotEmpty;

  bool get _hasExerciseImage =>
      widget.gender == Gender.female &&
      _resolvedImageAsset != null &&
      _resolvedImageAsset!.isNotEmpty;

  String? get _resolvedImageAsset => exerciseImageAssetFor(widget.exercise);

  String? get _resolvedVideoAsset => exerciseVideoAssetFor(widget.exercise);

  String get _fallbackAsset =>
      _hasExerciseImage ? _resolvedImageAsset! : widget.gender.asset;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  void didUpdateWidget(covariant ExerciseMediaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (exerciseVideoAssetFor(oldWidget.exercise) != _resolvedVideoAsset ||
        oldWidget.gender != widget.gender ||
        oldWidget.videoEnabled != widget.videoEnabled) {
      unawaited(_controller?.dispose());
      _controller = null;
      _initialize = null;
      _failed = false;
      _loadVideo();
    } else if (oldWidget.autoPlay != widget.autoPlay) {
      unawaited(_syncPlayback());
    }
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  void _loadVideo() {
    if (!_shouldUseVideo) return;

    final videoAsset = _resolvedVideoAsset;
    if (videoAsset == null || videoAsset.isEmpty) return;

    final controller = VideoPlayerController.asset(videoAsset);
    _controller = controller;
    _initialize = controller
        .initialize()
        .then((_) {
          controller.setLooping(true);
          if (widget.autoPlay) unawaited(controller.play());
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

  Future<void> _syncPlayback() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (widget.autoPlay && !controller.value.isPlaying) {
      await controller.play();
    } else if (!widget.autoPlay && controller.value.isPlaying) {
      await controller.pause();
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
            if (widget.showControls)
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
    if (!_hasExerciseImage && widget.gender == Gender.female) {
      return _missingMediaPlaceholder();
    }

    return Image.asset(
      _fallbackAsset,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      errorBuilder: (_, _, _) {
        if (!_hasExerciseImage && widget.gender != Gender.female) {
          return Image.asset(
            widget.gender.asset,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          );
        }

        return _missingMediaPlaceholder();
      },
    );
  }

  Widget _missingMediaPlaceholder() {
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
  }
}
