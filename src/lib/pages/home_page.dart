import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/viewmodels/home_viewmodel.dart';
import 'package:kudosapp/widgets/common/vector_icon.dart';
import 'package:kudosapp/widgets/decorations/bottom_decorator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          decoration: BoxDecoration(gradient: KudosTheme.mainGradient),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: LayoutBuilder(
              builder: (context, constraints) {
                var stack = Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: viewModel.tabs.map((t) => t.body).toList(),
                        onPageChanged: (page) =>
                            viewModel.selectedTabIndex = page,
                      ),
                    ),
                    Positioned.directional(
                      textDirection: TextDirection.ltr,
                      child: BottomDecorator(constraints.maxWidth),
                      bottom: 0,
                    ),
                  ],
                );
                return stack;
              },
            ),
            bottomNavigationBar: _buildNavigationBar(context, viewModel),
          ),
        );
      },
    );
  }

  Widget _buildNavigationBar(BuildContext context, HomeViewModel viewModel) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (tabIndex) => _pageController.jumpToPage(tabIndex),
        currentIndex: viewModel.selectedTabIndex,
        selectedItemColor: KudosTheme.accentColor,
        unselectedItemColor: KudosTheme.textColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: viewModel.tabs.map((tab) => getBarItem(tab)).toList(),
      ),
    );
  }

  Widget _getIcon(String assetName) => VectorIcon(assetName, Size(16, 16));

  BottomNavigationBarItem getBarItem(TabItem tabItem) {
    return BottomNavigationBarItem(
      backgroundColor: Colors.transparent,
      icon: Padding(
        padding: EdgeInsets.all(4.0),
        child: _getIcon(tabItem.iconAssetName),
      ),
      label: tabItem.title,
    );
  }
}
