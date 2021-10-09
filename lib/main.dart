import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

/// scroll用のproviderを宣言
final scrollControllerProvider = Provider((_) => AutoScrollController());

void main() {
  runApp(
    /// ✨✨✨ProviderScopeは、かなり忘れがちなので注意✨✨✨
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// riverpodから値を参照
    final controller = ref.watch(scrollControllerProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: ScrollAppBar(
          appBar: AppBar(
            title: const Text('Sample of Scroll to Jump'),
          ),
          onTap: () {
            /// ボタンを押したら先頭(=ListViewの0番目)にジャンプできる。
            /// AutoScrollPosition.beginがListのindexの頭に表示される。他に、middleとendが存在する
            controller.scrollToIndex(
              0,
              preferPosition: AutoScrollPosition.begin,
            );

            /// なお、【scroll_to_index】は、FlutterデフォルトAPIのScrollControllerを継承しているため、
            /// 前編にてジャンプ使用不可と記載しましたが、先頭に遷移させるだけであれば、実はjumpToが簡単に使えます。
            /// TwitterやInstagramは、アニメーション方式を採用している、且つユーザ体験もanimationの方が好ましいため、今回はコメントアウトしますが、お知りおきを。
            // controller.jumpTo(0);
          },
        ),

        /// 呼び出し元のメソッド
        body: const ScrollWidget(),
      ),
    );
  }
}

class ScrollWidget extends HookConsumerWidget {
  const ScrollWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(scrollControllerProvider);

    return ListView.builder(
      controller: controller,

      /// とりあえず100個だけ表示するように実装
      itemCount: 100,
      itemBuilder: (context, index) {
        /// AutoScrollTagを噛ませる
        return AutoScrollTag(
          key: ValueKey(index),
          controller: controller,
          index: index,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 80,

                /// 行頭に遷移されることがわかりやすいようにCardウィジェットを採用しています。適宜変更してください。
                child: Card(
                  child: Text(
                    '$index',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ✨✨✨デフォルトのAppBarは、Tap検出できないため、AppBarをカスタムする(GestureDetectorを噛ませた)
class ScrollAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

  const ScrollAppBar({Key? key, required this.onTap, required this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: appBar);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
