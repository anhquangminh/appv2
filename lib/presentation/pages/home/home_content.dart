import 'package:ducanherp/core/themes/app_theme_helper.dart';
import 'package:ducanherp/presentation/pages/home/giao_viec_tab.dart';
import 'package:ducanherp/presentation/pages/home/thuc_hien_tab.dart';
// import 'package:ducanherp/presentation/pages/home/widgets/chart_section.dart';
// import 'package:ducanherp/presentation/pages/home/widgets/summary_card.dart';
import 'package:ducanherp/presentation/pages/home/widgets/tab_switcher.dart';
// import 'package:ducanherp/presentation/pages/home/widgets/task_progress_section.dart';
// import 'package:ducanherp/presentation/pages/home/widgets/team_section.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int tabIndex = 0;
  final PageController _controller = PageController();

  void _onTabChanged(int index) {
    setState(() => tabIndex = index);
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => tabIndex = index);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16,top: 0),
            decoration: BoxDecoration(
              color: context.surface,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TabSwitcher(
                currentIndex: tabIndex,
                onChanged: _onTabChanged,
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: _onPageChanged,
              children: const [ GiaoViecTab(),ThucHienTab()],
            ),
          ),
        ],
      );
  }
}

