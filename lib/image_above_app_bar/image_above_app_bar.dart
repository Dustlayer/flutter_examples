import 'package:flutter/material.dart';

class ImageAboveAppBar extends StatefulWidget {
  const ImageAboveAppBar({super.key});

  @override
  State<ImageAboveAppBar> createState() => _ImageAboveAppBarState();
}

class _ImageAboveAppBarState extends State<ImageAboveAppBar> with SingleTickerProviderStateMixin {
  final _headerImageMaxHeight = 360.0;

  final _controller = ScrollController();
  late final _tabController = TabController(length: 4, vsync: this);

  OverlayEntry? _overlayEntry;
  final _layerLink = LayerLink();
  final _avatarSize = 100.0;
  double _visiblePercent = 1.0;

  @override
  void initState() {
    _controller.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAvatar();
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    _controller.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _handleScroll() {
    final total = _controller.offset + kToolbarHeight + _avatarSize / 2;
    final difference = total - _headerImageMaxHeight;
    _visiblePercent = ((_avatarSize - difference).clamp(0.0, _avatarSize).toDouble() / _avatarSize);
    _overlayEntry?.markNeedsBuild();
  }

  void _showAvatar() {
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: _headerImageMaxHeight - _controller.offset - _avatarSize / 2 - (1 - _visiblePercent) * _avatarSize,
          left: 0,
          right: 0,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: Offset(0.0, -_avatarSize / 2),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: _avatarSize,
                height: _avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                child: const Center(child: Text('Avatar')),
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        scrollDirection: Axis.vertical,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverPersistentHeader(
            delegate: HeaderImageDelegate(
              maxHeight: _headerImageMaxHeight,
              child: Image.asset(
                "assets/bee.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverAppBar(
            pinned: true,
            toolbarHeight: 80,
            title: const Padding(
              padding: EdgeInsets.only(top: 32.0),
              child: Column(
                children: [
                  Text("Santas workshop"),
                  Text(
                    "Functional back fixers",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            centerTitle: true,
            actions: const [
              Icon(Icons.quiz_outlined),
              Icon(Icons.egg_outlined),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(child: Text("Profile")),
                Tab(child: Text("Flows")),
                Tab(child: Text("Schedule")),
                Tab(child: Text("Promos")),
              ],
            ),
          ),
        ],
        body: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 0, //MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: ScreenContent(tabController: _tabController),
        ),
      ),
    );
  }
}

class HeaderAvatar extends StatelessWidget {
  const HeaderAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

class HeaderImageDelegate extends SliverPersistentHeaderDelegate {
  HeaderImageDelegate({required this.child, required this.maxHeight});

  final Widget child;
  final double maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant HeaderImageDelegate oldDelegate) {
    return child != oldDelegate.child || maxHeight != oldDelegate.maxHeight;
  }
}

class ScreenContent extends StatelessWidget {
  const ScreenContent({super.key, required this.tabController});

  static const colors = [Colors.amber, Colors.green, Colors.blueAccent, Colors.yellow, Colors.cyan];

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: const [
        Column(
          children: [Text("Profile"), Text("Santa fix my back pls"), Expanded(child: ColoredBoxes())],
        ),
        Column(
          children: [Text("Flows"), Expanded(child: ColoredBoxes())],
        ),
        Column(
          children: [Text("Schedule"), Expanded(child: ColoredBoxes())],
        ),
        Column(
          children: [Text("Promotions"), Expanded(child: ColoredBoxes())],
        ),
      ],
    );
  }
}

class ColoredBoxes extends StatelessWidget {
  const ColoredBoxes({super.key});

  static const colors = [Colors.amber, Colors.green, Colors.blueAccent, Colors.yellow, Colors.cyan];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        25,
        (index) => Container(
          height: 40,
          width: 60,
          color: colors[index % colors.length],
        ),
      ),
    );
  }
}
