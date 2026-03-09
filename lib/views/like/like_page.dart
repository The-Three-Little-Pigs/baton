import 'package:baton/views/_tap/home/viewmodel/home_tap_viewmodel.dart';
import 'package:baton/views/_tap/home/widgets/category_chips.dart';
import 'package:baton/views/_tap/home/widgets/category_select_button.dart';
import 'package:baton/views/like/widgets/no_like_product';
import 'package:baton/views/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikePage extends ConsumerWidget {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsyncValue = ref.watch(homeTapViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("관심상품"),
        centerTitle: true,
        actions: [Text('편집')],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 10,
          children: [
            Row(
              children: [
                CategorySelectButton(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: CategoryChips(),
                  ),
                ),
              ],
            ),
            Expanded(
              child: postAsyncValue.when(
                data: (posts) {
                  print(posts);
                  if (posts.isEmpty) {
                    return Center(child: NoLikeProduct());
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.7,
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                        ),
                    itemBuilder: (context, index) {
                      return ProductItem(post: posts[index]);
                    },
                    itemCount: posts.length,
                  );
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(error.toString()),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(homeTapViewModelProvider.notifier)
                                .refresh();
                          },
                          child: Text("재시도"),
                        ),
                      ],
                    ),
                  );
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
