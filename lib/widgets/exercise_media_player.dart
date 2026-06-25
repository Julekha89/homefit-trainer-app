import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../data/workout_data.dart';
import '../models/workout.dart';

class ExerciseMediaPlayer extends StatefulWidget {
  const ExerciseMediaPlayer({
    super.key,
    required this.exercise,
    required this.gender,
    this.videoEnabled = false,
    this.autoPlay = false,
    this.fit = BoxFit.cover,
    this.showControls = false,
  });

  final Exercise exercise;
  final Gender gender;
  final bool videoEnabled;
  final bool autoPlay;
  final BoxFit fit;
  final bool showControls;

  @override
  State<ExerciseMediaPlayer> createState() => _ExerciseMediaPlayerState();
}

class _ExerciseMediaPlayerState extends State<ExerciseMediaPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _initializeFuture;
  String? _loadedVideoAsset;
  bool _videoFailed = false;

  String? get _imageAsset =>
      exerciseImageAssetFor(widget.exercise, widget.gender);
  String? get _videoAsset =>
      exerciseVideoAssetFor(widget.exercise, widget.gender);

  @override
  void initState() {
    super.initState();
    _syncVideoController();
  }

  @override
  void didUpdateWidget(covariant ExerciseMediaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise != widget.exercise ||
        oldWidget.gender != widget.gender ||
        oldWidget.videoEnabled != widget.videoEnabled) {
      _syncVideoController();
    } else if (widget.videoEnabled &&
        widget.autoPlay &&
        _controller?.value.isInitialized == true &&
        _controller?.value.isPlaying == false) {
      unawaited(_controller!.play());
    }
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  void _syncVideoController() {
    final videoAsset = _videoAsset;
    if (!widget.videoEnabled || videoAsset == null) {
      _disposeController();
      return;
    }
    if (_loadedVideoAsset == videoAsset && _controller != null) {
      if (widget.autoPlay) unawaited(_controller!.play());
      return;
    }

    _disposeController();
    _videoFailed = false;
    _loadedVideoAsset = videoAsset;
    final controller = VideoPlayerController.asset(videoAsset);
    _controller = controller;
    _initializeFuture = controller
        .initialize()
        .then((_) async {
          await controller.setLooping(true);
          if (widget.autoPlay) await controller.play();
          if (mounted) setState(() {});
        })
        .catchError((Object _) {
          _videoFailed = true;
          if (mounted) setState(() {});
        });
  }

  void _disposeController() {
    final controller = _controller;
    _controller = null;
    _initializeFuture = null;
    _loadedVideoAsset = null;
    _videoFailed = false;
    unawaited(controller?.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final image = _buildImageFallback();
    final controller = _controller;
    final initializeFuture = _initializeFuture;

    if (!widget.videoEnabled ||
        controller == null ||
        initializeFuture == null ||
        _videoFailed) {
      return image;
    }

    return FutureBuilder<void>(
      future: initializeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !controller.value.isInitialized) {
          return Stack(
            fit: StackFit.expand,
            children: [
              image,
              const Center(child: CircularProgressIndicator()),
            ],
          );
        }

        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            FittedBox(
              fit: widget.fit,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
            if (widget.showControls)
              Positioned(
                bottom: 14,
                right: 14,
                child: Row(
                  children: [
                    _RoundMediaButton(
                      icon: controller.value.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      onPressed: () {
                        setState(() {
                          controller.value.isPlaying
                              ? controller.pause()
                              : controller.play();
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    _RoundMediaButton(
                      icon: Icons.replay_rounded,
                      onPressed: () async {
                        await controller.seekTo(Duration.zero);
                        await controller.play();
                        if (mounted) setState(() {});
                      },
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildImageFallback() {
    final imageAsset = _imageAsset;
    if (imageAsset == null) {
      return Image.asset(widget.gender.asset, fit: widget.fit);
    }
    return Image.asset(
      imageAsset,
      fit: widget.fit,
      errorBuilder: (_, _, _) =>
          Image.asset(widget.gender.asset, fit: widget.fit),
    );
  }
}

class _RoundMediaButton extends StatelessWidget {
  const _RoundMediaButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.62),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
