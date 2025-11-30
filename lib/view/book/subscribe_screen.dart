import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  bool isChecked = false;

  void _showSimpleConfirmDialog(BuildContext context, String message) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Material(
          color: ColorSystem.black.withOpacity(0.5),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: BoxDecoration(
                color: ColorSystem.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: FontSystem.KR16M.copyWith(
                      color: ColorSystem.grey[800],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 110,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => entry.remove(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorSystem.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        '확인',
                        style: FontSystem.KR16B.copyWith(
                          color: ColorSystem.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    Navigator.of(context).overlay!.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.white,
      appBar: AppBar(
        backgroundColor: ColorSystem.white,
        elevation: 0,
        title: Text('구독제 안내',
            style: FontSystem.KR20B.copyWith(color: ColorSystem.deepBlue)),
        centerTitle: true,
        iconTheme: IconThemeData(color: ColorSystem.deepBlue),
        surfaceTintColor: ColorSystem.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Center(
            child: Image.asset(
              'assets/images/subscribe_logo.png',
              height: 150,
            ),
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [ColorSystem.blue, ColorSystem.blue[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Text(
              '쉬엄시험을 구독하여\n여러가지 혜택을 누려보세요!',
              style: FontSystem.KR28B.copyWith(
                color: ColorSystem.white,
                height: 1.3,
                letterSpacing: -1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '광고 없이 쾌적하게,\n문제집을 마음껏 만들어보세요!\n쉬엄시험 구독자만의 특별한 혜택도 준비되어 있어요.',
            style: FontSystem.KR14M.copyWith(
              color: ColorSystem.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: ColorSystem.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ColorSystem.blue, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('1개월 구독', style: FontSystem.KR16B),
                Text('₩3,900',
                    style: FontSystem.KR20B.copyWith(color: ColorSystem.blue)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorSystem.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('App Store 구매안내',
                    style: FontSystem.KR16B
                        .copyWith(color: ColorSystem.grey[800])),
                const SizedBox(height: 12),
                Text('· App Store 결제는 현재 사용하고 있는 App Store 계정을 통해 결제됩니다.',
                    style: FontSystem.KR14M
                        .copyWith(color: ColorSystem.grey[500], height: 1.2)),
                const SizedBox(height: 4),
                Text('· 일부 사용자의 경우, App Store 상황에 따라 구독 마지막 날 결제될 수 있습니다.',
                    style: FontSystem.KR14M
                        .copyWith(color: ColorSystem.grey[500], height: 1.2)),
                const SizedBox(height: 4),
                Text('· 결제 금액에는 수수료가 포함되어 있습니다.',
                    style: FontSystem.KR14M
                        .copyWith(color: ColorSystem.grey[500], height: 1.2)),
                const SizedBox(height: 4),
                Text('· 결제 금액에 대한 확인 및 환불은 Apple을 통해 가능합니다.',
                    style: FontSystem.KR14M
                        .copyWith(color: ColorSystem.grey[500], height: 1.2)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (val) {
                  setState(() {
                    isChecked = val ?? false;
                  });
                },
                activeColor: ColorSystem.blue,
              ),
              const Expanded(
                child: Text(
                  '구독 약관 및 개인정보 처리방침에 동의합니다.',
                  style: FontSystem.KR14M,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: isChecked
                  ? () {
                      _showSimpleConfirmDialog(context,
                          '농협 351-1066-0725-33 예금주 이가흔\n 당신의 따뜻한 배려로 오늘도 개발자 한명은 밥을 먹을 수 있습니다..');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorSystem.blue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('₩3,900 결제하기',
                  style: FontSystem.KR16B.copyWith(color: ColorSystem.white)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
