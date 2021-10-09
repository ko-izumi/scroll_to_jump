import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sample of Scroll to Jump'),
        ),

        /// 呼び出し元のメソッド
        body: const ScrollWidget(),
      ),
    );
  }
}

class ScrollWidget extends StatelessWidget {
  const ScrollWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AutoScrollController();

    return ListView.builder(
      controller: controller,

      /// とりあえず100個だけ表示するように実装
      itemCount: 100,
      itemBuilder: (context, index) {
        return AutoScrollTag(
          key: ValueKey(index),
          controller: controller,
          index: index,
          child: Column(
            children: [
              /// ListViewの先頭のみ、ボタンを設置する実装(ここは正直あんまり参考にしない方がいいかも?)。
              if (index == 0)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      /// ボタンを押したら任意の場所にジャンプできる。50の値を適宜変更してください。
                      controller.scrollToIndex(
                        50,

                        /// beginがListのindexの頭に表示される。他に、middleとendが存在する
                        preferPosition: AutoScrollPosition.begin,
                      );
                    },
                    child: const Text('50番目にジャンプ'),
                  ),
                ),
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
