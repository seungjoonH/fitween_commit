import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fitween1/global/global.dart';
import 'package:fitween1/global/palette.dart';
import 'package:fitween1/model/user/user.dart';
import 'package:fitween1/presenter/page/register.dart';
import 'package:fitween1/presenter/model/user.dart';
import 'package:fitween1/view/widget/button.dart';
import 'package:fitween1/view/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';

// 회원가입 페이지 위젯 모음

// 회원가입 페이지 AppBar
class RegisterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RegisterAppBar({
    Key? key,
    required this.onBackPressed,
    required this.theme,
  }) : super(key: key);

  final VoidCallback onBackPressed;
  final FWTheme theme;

  @override
  Size get preferredSize => const Size.fromHeight(appbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.color),
        onPressed: onBackPressed,
      ),
      title: FWText('기본 정보', size: 20.0, color: theme.color),
      backgroundColor: theme.backgroundColor,
      elevation: 0.0,
    );
  }
}

// 역할 선택 버튼 뷰
class RoleSelectionButtonView extends StatelessWidget {
  const RoleSelectionButtonView({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final FWTheme theme;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserPresenter>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 100.0),
                  child: FWText('${controller.user.nickname}',
                    size: 15.0,
                    color: Palette.accent,
                  ),
                ),
              ),
              FWText(
                ' 님은 무엇을 하고 싶으신가요?',
                size: 15.0,
                weight: FWFontWeight.thin,
                color: theme.color,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          RoleSelectionButton(theme: theme, role: Role.trainer),
          const SizedBox(height: 15.0),
          RoleSelectionButton(theme: theme, role: Role.trainee),
          Container(
            height: 50.0,
            alignment: Alignment.center,
            child: FWText(
              'TIP: 역할은 언제든지 바꿀 수 있어요!',
              size: 12.0,
              weight: FWFontWeight.thin,
              color: theme.color,
            ),
          ),
        ],
      ),
    );
  }
}

// 역할 선택 버튼
class RoleSelectionButton extends StatelessWidget {
  const RoleSelectionButton({
    Key? key,
    required this.role,
    required this.theme,
  }) : super(key: key);

  final Role role;
  final FWTheme theme;

  @override
  Widget build(BuildContext context) {
    final registerCont = Get.find<RegisterPresenter>();

    const Map<Role, String> texts = {
      Role.trainer: '트레이너로 참여하기',
      Role.trainee: '피트위너로 도전하기'
    };

    return GetBuilder<UserPresenter>(
      builder: (userCont) {
        return FWButton(
          text: texts[role],
          width: double.infinity,
          theme: theme,
          fill: role == userCont.user.role,
          onPressed: () => registerCont.roleSelected(role),
        );
      }
    );
  }
}

// 닉네임 입력 필드 위젯
class NicknameInputField extends StatelessWidget {
  const NicknameInputField({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final FWTheme theme;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterPresenter>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FWText('별명을 입력하세요.', size: 15.0, color: theme.color),
            const SizedBox(height: 8.0),
            ShakeWidget(
              autoPlay: controller.invalid,
              shakeConstant: ShakeHorizontalConstant2(),
              child: FWInputField(
                controller: RegisterPresenter.nicknameCont,
                onSubmitted: (_) => controller.nextPressed(),
                hintText: '별명',
                theme: theme,
                invalid: controller.invalid,
              ),
            ),
            const SizedBox(height: 8.0),
          ],
        );
      }
    );
  }
}

// Carousel 뷰 위젯
class CarouselView extends StatelessWidget {
  const CarouselView({Key? key, required this.theme}) : super(key: key);

  final FWTheme theme;

  // 회원가입 페이지 carousel 리스트
  static List<Widget> carouselWidgets([FWTheme theme = FWTheme.dark]) => [
    NicknameInputField(theme: theme),
    RoleSelectionButtonView(theme: theme),
  ];
  static int widgetCount = carouselWidgets().length;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool keyboardDisabled = WidgetsBinding.instance.window.viewInsets.bottom < 100.0;

    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 50.0),
            alignment: Alignment.topCenter,
            child: Container(
              constraints: BoxConstraints(minWidth: screenSize.width),
              child: CarouselSlider(
                carouselController: RegisterPresenter.carouselCont,
                items: carouselWidgets(theme).map((widget) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                  child: widget,
                )).toList(),
                options: CarouselOptions(
                  initialPage: 0,
                  reverse: false,
                  enableInfiniteScroll: false,
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  viewportFraction: 1.0,
                  // onPageChanged: controller.pageChanged,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: keyboardDisabled ? 200.0 : 100.0,
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Carousel 인디케이터
              CarouselIndicator(theme: theme, count: widgetCount),
              // Carousel 다음 버튼
              CarouselNextButton(theme: theme),
            ],
          ),
        ),
      ],
    );
  }
}

// Carousel 인디케이터 위젯
class CarouselIndicator extends StatelessWidget {
  const CarouselIndicator({
    Key? key,
    required this.count,
    this.theme = FWTheme.dark,
  }) : super(key: key);

  final int count;
  final FWTheme theme;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterPresenter>(
      builder: (controller) {
        return SizedBox(
          height: 100.0,
          child: DotsIndicator(
            dotsCount: count,
            position: controller.pageIndex.toDouble(),
            decorator: DotsDecorator(
              color: Palette.grey,
              activeColor: theme.color,
            ),
          ),
        );
      }
    );
  }
}

// Carousel 다음 버튼
class CarouselNextButton extends StatelessWidget {
  const CarouselNextButton({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final FWTheme theme;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterPresenter>();

    return FWButton(
      onPressed: () {
        controller.nextPressed();
        FocusScope.of(context).unfocus();
      },
      width: 120.0,
      height: 45.0,
      text: '다음',
      borderRadius: 1.0,
      theme: theme,
    );
  }
}
