import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rest_test/view/book/book_onboarding_steps/add_answers_step.dart';
import 'package:rest_test/view/book/book_onboarding_steps/has_image_step.dart';
import 'package:rest_test/view/book/book_onboarding_steps/has_solution_step.dart';
import 'package:rest_test/view/book/book_onboarding_steps/intro_step.dart';
import 'package:rest_test/view/book/book_onboarding_steps/question_type_step.dart';
import 'package:rest_test/view/book/widget/add_file_modal.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

class CreateMyProblemSetPage extends StatefulWidget {
  const CreateMyProblemSetPage({super.key});

  @override
  State<CreateMyProblemSetPage> createState() => _CreateMyProblemSetPageState();
}

enum _CreateStep { intro, hasImage, questionType, hasSolution, addAnswers }

class _CreateMyProblemSetPageState extends State<CreateMyProblemSetPage> {
  int _stepIndex = 0;

  bool? _hasImage;
  QuestionType? _questionType;
  bool? _hasSolution;
  bool _addAnswersValid = true;

  bool get _isLastStep => _stepIndex == _CreateStep.values.length - 1;

  _CreateStep get _step => _CreateStep.values[_stepIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        elevation: 0,
        backgroundColor: ColorSystem.white,
      ),
      backgroundColor: ColorSystem.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: _buildStepContent(),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case _CreateStep.intro:
        return const IntroStep();
      case _CreateStep.hasImage:
        return HasImageStep(
          hasImage: _hasImage,
          onTapYes: () async {
            setState(() {
              _hasImage = true;
            });
            await _onTapHasImageYes();
          },
          onTapNo: () {
            setState(() {
              _hasImage = false;
            });
          },
        );

      case _CreateStep.questionType:
        return QuestionTypeStep(
          selectedType: _questionType,
          onSelectType: (type) {
            setState(() {
              _questionType = type;
            });
          },
        );
      case _CreateStep.hasSolution:
        return HasSolutionStep(
          hasSolution: _hasSolution,
          onSelect: (value) {
            setState(() {
              _hasSolution = value;
            });
          },
        );
      case _CreateStep.addAnswers:
        return AddAnswersStep(
          onValidationChanged: (isValid) {
            setState(() {
              _addAnswersValid = isValid;
            });
          },
        );
    }
  }

  Future<void> _onTapHasImageYes() async {
    final result = await showDialog<_ImageDialogResult>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorSystem.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/logo_blue.svg',
                  height: 50,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 28),
                Text(
                  '아직 이미지 기반 문제는 정확하게 인식하기 어려워요 ㅠ.ㅠ',
                  textAlign: TextAlign.center,
                  style: FontSystem.KR14B.copyWith(color: ColorSystem.black),
                ),
                const SizedBox(height: 8),
                Text(
                  '이미지 없이 문제를 만들거나,\n첫 화면으로 돌아가 다시 시도해 주세요!',
                  textAlign: TextAlign.center,
                  style:
                      FontSystem.KR14M.copyWith(color: ColorSystem.grey[600]),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: RoundedRectangleTextButton(
                        text: '원래 화면으로',
                        textStyle: FontSystem.KR16M.copyWith(
                          color: ColorSystem.grey[600],
                        ),
                        backgroundColor: ColorSystem.back,
                        borderSide: BorderSide(
                          color: ColorSystem.grey[300]!,
                          width: 1,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(_ImageDialogResult.backToHome);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RoundedRectangleTextButton(
                        text: '이미지 없이 만들기',
                        textStyle: FontSystem.KR16M.copyWith(
                          color: ColorSystem.white,
                        ),
                        backgroundColor: ColorSystem.blue,
                        onPressed: () {
                          Navigator.of(context)
                              .pop(_ImageDialogResult.makeWithoutImage);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || result == null) return;

    switch (result) {
      case _ImageDialogResult.backToHome:
        Navigator.of(context).maybePop();
        break;
      case _ImageDialogResult.makeWithoutImage:
        setState(() {
          _hasImage = false;
        });
        _goNext();
        break;
    }
  }

  Widget _buildBottomButtons() {
    final canGoNext = _canGoNext();
    final isLast = _isLastStep ||
        (_step == _CreateStep.hasSolution && _hasSolution == false);
    final buttons = <Widget>[];

    if (_stepIndex > 0) {
      buttons.add(
        Expanded(
          child: RoundedRectangleTextButton(
            text: '이전',
            textStyle: FontSystem.KR16B.copyWith(
              color: ColorSystem.grey[500],
            ),
            backgroundColor: ColorSystem.grey[200],
            onPressed: _goPrev,
          ),
        ),
      );
      buttons.add(const SizedBox(width: 12));
    }

    buttons.add(
      Expanded(
        child: RoundedRectangleTextButton(
          text: isLast ? '문제집 생성' : '다음',
          textStyle: FontSystem.KR16B.copyWith(
            color: ColorSystem.white,
          ),
          backgroundColor: canGoNext ? ColorSystem.blue : ColorSystem.grey[400],
          onPressed: canGoNext
              ? () {
                  if (isLast) {
                    _showAddFileModal(context);
                  } else {
                    _goNext();
                  }
                }
              : null,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Row(children: buttons),
    );
  }

  bool _canGoNext() {
    switch (_step) {
      case _CreateStep.intro:
        return true;
      case _CreateStep.hasImage:
        return _hasImage == false;
      case _CreateStep.questionType:
        if (_questionType == null) return false;
        return _questionType == QuestionType.multipleChoice;
      case _CreateStep.hasSolution:
        return _hasSolution != null;
      case _CreateStep.addAnswers:
        return _addAnswersValid;
    }
  }

  void _goNext() {
    if (_stepIndex < _CreateStep.values.length - 1) {
      setState(() {
        _stepIndex++;
      });
    }
  }

  void _goPrev() {
    if (_stepIndex > 0) {
      setState(() {
        _stepIndex--;
      });
    }
  }

  void _showAddFileModal(BuildContext context) {
    try {
      final bookViewModel = Get.find<BookViewModel>();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AddFileModal(controller: bookViewModel),
      );
    } catch (e) {
      Navigator.of(context).maybePop();
    }
  }
}

enum _ImageDialogResult { backToHome, makeWithoutImage }
