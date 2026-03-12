import 'package:baton/views/write/viewmodel/write_page_view_model.dart';
import 'package:baton/views/write/widgets/bottom_complete_bar.dart';
import 'package:baton/views/write/widgets/category_section.dart';
import 'package:baton/views/write/widgets/content_section.dart';
import 'package:baton/views/write/widgets/image_select_section.dart';
import 'package:baton/views/write/widgets/price_section.dart';
import 'package:baton/views/write/widgets/title_section.dart';
import 'package:baton/views/write/widgets/trade_type_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WritePage extends ConsumerWidget {
  const WritePage({super.key, this.postId});

  final String? postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref
        .watch(writePageViewModelProvider(postId: postId))
        .isLoading;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              postId != null ? "게시글 수정" : "물건 팔기",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  spacing: 20,
                  children: [
                    ImageSelectSection(),
                    TitleSection(),
                    CategorySection(),
                    ContentSection(),
                    TradeTypeSection(),
                    PriceSection(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: MediaQuery.of(context).padding.bottom + 20,
            ),
            child: BottomCompleteBar(postId: postId),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: GestureDetector(onTap: () {}, child: DimBackground()),
          ),
      ],
    );
  }
}

class DimBackground extends StatelessWidget {
  const DimBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
