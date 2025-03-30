import 'dart:async'; //  导入Dart的异步编程库
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';

void main() async { //  主函数，程序的入口
  WidgetsFlutterBinding.ensureInitialized(); //  确保Flutter框架已初始化
  await windowManager.ensureInitialized(); //  确保窗口管理库已初始化
  
  runApp(const MyApp()); //  运行MyApp应用
}

class MyApp extends StatelessWidget { //  无状态组件，用于构建整个应用程序
  const MyApp({super.key}); //  构造函数，接受一个可选的key参数
  @override
  Widget build(BuildContext context) { //  构建组件的方法
    return MaterialApp(
      title: '护眼提醒', //  应用的标题
      theme: ThemeData( //  应用程序的主题
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 59, 209, 36)),
        useMaterial3: true, //  使用Material 3设计
      ),
      home: MyHomePage(title: '护眼提醒'), //  应用的主页
    );
  }
}

class MyHomePage extends StatefulWidget { //  定义一个有状态的Widget，用于创建主页面
  MyHomePage({super.key, required this.title}); //  构造函数，接收一个key和一个必需的title参数
  final String title; //  定义一个final类型的字符串变量title，用于存储页面标题

  @override //  创建并返回一个_MyHomePageState实例，用于管理状态
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> { //  定义_MyHomePageState类，继承自State<MyHomePage>，用于管理MyHomePage的状态
  @override //  构建Widget树的方法
  Widget build(BuildContext context) {
    return Scaffold( //  返回一个Scaffold结构，它是Material Design中页面的基本布局结构
      appBar: AppBar( //  设置AppBar，即页面顶部的工具栏
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, //  设置AppBar的背景颜色为当前主题的反向主色
        title: Text(widget.title), //  设置AppBar的标题，使用widget.title获取传入的标题
      ),
      body: HomePage( //  设置页面的主体部分

      )
    );
  }
}

class HomePage extends StatefulWidget { //  定义一个有状态的Widget，用于创建HomePage
  const HomePage({super.key}); //  构造函数，接收一个key参数

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int time = 5; // 默认5分钟
  bool is_timering = false;

  Future<void> startTimer() async {
    setState(() {
      is_timering = true;
    });
    //窗口最小化
    await windowManager.minimize(); //  最小化窗口
    // 开始倒计时
    Timer(Duration(minutes: time), () async {
      await windowManager.center(); //  将窗口居中
      await windowManager.restore(); //  恢复窗口
      await windowManager.maximize(); //  最大化窗口
      showDialog(
        context: context,
        builder: (BuildContext context) {
          is_timering = false; //  设置计时器状态为未计时
          return AlertDialog( //  返回一个对话框
            title: const Text('休息时间到！'), //  对话框标题
            content: const Text('请休息一下眼睛，保护视力！'), //  对话框内容
            actions: <Widget>[ //  定义一个包含多个Widget的actions列表
              TextButton( //  创建一个文本按钮
                onPressed: () { //  当按钮被点击时执行的操作
                  Navigator.of(context).pop(); //  关闭当前对话框或页面
                  startTimer(); // 重新开始计时
                },
                child: const Text('好的'),
              ),
            ],
          );
        },
      );
    });
  }
  @override
  Widget _buildTimerUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "让我们来保护眼睛",
            style: TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 10),
          DropdownButton<int>(
            value: time,
            items: [5, 10, 15, 20, 25, 30, 40, 60].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value 分钟', style: const TextStyle(fontSize: 30, color: Colors.black)),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                time = newValue!;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              startTimer();
            },
            child: const Text('开始吧！', style: TextStyle(fontSize: 30)),
          ),
        ],
      ),
    );
  }

  Widget _buildProtectingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "已启用护眼提醒",
            style: TextStyle(
              fontSize: 80,
              color: Colors.green,
              fontWeight: FontWeight.bold
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                is_timering = false;
              });
            },
            child: Text("停止",style: TextStyle(fontSize: 30))
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !is_timering ? _buildTimerUI() : _buildProtectingUI();
  }
}
