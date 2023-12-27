import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myday/provider/theme_mode_provider.dart';
import 'package:myday/widget/my_container.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class InfoView extends StatelessWidget {
  final _pageController = PageController();

  InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MyContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 0.7.sh,
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                itemBuilder: (_, index) {
                  return index == 0
                      ? MyContainer(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                width: 2.w,
                                color: context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black54,
                                style: BorderStyle.solid,
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/guide_theme_mode.png'),
                              20.verticalSpace,
                              const Text("오른쪽 상단에 아이콘 버튼으로 다크 모드 설정이 가능합니다."),
                            ],
                          ),
                        )
                      : index == 1
                          ? MyContainer(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    width: 2.w,
                                    color: context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black54,
                                    style: BorderStyle.solid,
                                  )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/guide_home_widget.png'),
                                  20.verticalSpace,
                                  const Text("추가한 일정 좌측에서 홈 위젯에 보여질 1번째, 2번째 일정을 설정 할 수 있습니다."),
                                ],
                              ),
                            )
                          : MyContainer(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    width: 2.w,
                                    color: context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black54,
                                    style: BorderStyle.solid,
                                  )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.warning_amber_outlined, size: 50.w,),
                                  20.verticalSpace,
                                  const Text("알림 서비스는 아직 개발 중입니다. 빠른 시일 내에 서비스를 제공할 수 있도록 하겠습니다."),
                                ],
                              ),
                            );
                },
              ),
            ),
            30.verticalSpace,
            SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  type: WormType.thinUnderground,
                  activeDotColor: context.watch<ThemeModeProvider>().isDark ? Colors.white : Colors.black54,
                  dotColor: context.watch<ThemeModeProvider>().isDark ? Colors.white30 : Colors.black12),
            ),
          ],
        ),
      ),
    );
  }
}
