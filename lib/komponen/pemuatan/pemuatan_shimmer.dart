import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BlokSkeleton extends StatelessWidget {
  final double tinggi;
  final double lebar;
  final double radius;

  const BlokSkeleton({
    super.key,
    this.tinggi = 16,
    this.lebar = double.infinity,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Container(
      height: tinggi,
      width: lebar,
      decoration: BoxDecoration(
        color: warna.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class PemuatanShimmer extends StatelessWidget {
  final Widget anak;

  const PemuatanShimmer({super.key, required this.anak});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final base = warna.surfaceContainerHighest;
    final highlight = warna.surfaceContainerHigh;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: anak,
    );
  }
}

class KartuSkeletonTransaksi extends StatelessWidget {
  const KartuSkeletonTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    return const PemuatanShimmer(
      anak: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlokSkeleton(tinggi: 18, lebar: 120),
          SizedBox(height: 12),
          BlokSkeleton(tinggi: 14, lebar: 180),
          SizedBox(height: 8),
          BlokSkeleton(tinggi: 14, lebar: 100),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}