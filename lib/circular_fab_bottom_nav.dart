import 'dart:ui';
import 'package:flutter/material.dart';

/// FAB选项配置项
/// 用于定义点击FAB按钮时弹出的选项卡片
class FabOptionItem {
  /// 图标
  final IconData icon;

  /// 图标颜色
  final Color iconColor;

  /// 背景颜色
  final Color backgroundColor;

  /// 主标题
  final String title;

  /// 副标题
  final String subtitle;

  /// 点击回调
  final VoidCallback onTap;

  const FabOptionItem({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

/// 导航栏项配置
/// 用于定义底部导航栏的每个导航项
class CircularBottomNavItem {
  /// 未选中时的图标
  final Widget icon;

  /// 选中时的图标
  final Widget activeIcon;

  /// 导航项标签（可选）
  final String? label;

  const CircularBottomNavItem({
    required this.icon,
    required this.activeIcon,
    this.label,
  });
}

/// 带圆形FAB按钮的底部导航栏组件
///
/// 特性：
/// - 支持自定义导航项和FAB选项
/// - 精美的进入/退出动画效果
/// - 交错动画和背景模糊效果
/// - 高度可定制的外观配置
/// - 自动在中间位置添加占位符，优化布局
class CircularFabBottomNav extends StatefulWidget {
  /// 导航栏项列表
  final List<CircularBottomNavItem> items;

  /// 当前选中的导航项索引
  final int currentIndex;

  /// 导航项点击回调
  final ValueChanged<int> onTap;

  /// FAB点击时显示的选项列表
  final List<FabOptionItem> fabOptions;

  // 外观配置
  /// 导航栏背景色
  final Color backgroundColor;

  /// FAB背景色
  final Color fabBackgroundColor;

  /// FAB图标颜色
  final Color fabIconColor;

  /// FAB按钮大小
  final double fabSize;

  /// FAB突出高度
  final double fabElevation;

  /// 选中项颜色
  final Color selectedItemColor;

  /// 未选中项颜色
  final Color unselectedItemColor;

  /// 图标大小
  final double iconSize;

  /// 导航栏高度
  final double height;

  const CircularFabBottomNav({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.fabOptions,
    this.backgroundColor = const Color(0xFF111113),
    this.fabBackgroundColor = Colors.white,
    this.fabIconColor = Colors.black,
    this.fabSize = 76.0,
    this.fabElevation = 20.0,
    this.selectedItemColor = Colors.white,
    this.unselectedItemColor = Colors.grey,
    this.iconSize = 26.0,
    this.height = 80.0,
  }) : super(key: key);

  @override
  State<CircularFabBottomNav> createState() => _CircularFabBottomNavState();
}

class _CircularFabBottomNavState extends State<CircularFabBottomNav>
    with TickerProviderStateMixin {
  // 状态管理
  bool _showOptions = false;
  bool _isAnimating = false; // 防止动画期间重复触发

  // 动画控制器
  late AnimationController _fabAnimationController; // FAB按钮动画
  late AnimationController _overlayAnimationController; // 背景模糊动画
  late AnimationController _optionsAnimationController; // 选项卡片动画

  // 动画曲线 - 为不同动画提供缓动效果
  late CurvedAnimation _fabAnimation;
  late CurvedAnimation _overlayAnimation;
  late CurvedAnimation _optionsAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  /// 初始化所有动画控制器和动画曲线
  void _initializeAnimations() {
    // FAB旋转动画 - 快速响应
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    // 背景模糊动画 - 中等速度
    _overlayAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // 选项出现动画 - 较慢，营造优雅效果
    _optionsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // 创建带缓动效果的动画曲线
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeOutCubic, // 进入时平滑
      reverseCurve: Curves.easeInCubic, // 退出时快速
    );

    _overlayAnimation = CurvedAnimation(
      parent: _overlayAnimationController,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInQuart, // 退出时更快
    );

    _optionsAnimation = CurvedAnimation(
      parent: _optionsAnimationController,
      curve: Curves.easeOutBack, // 带有回弹效果
      reverseCurve: Curves.easeInCubic, // 退出时使用不同曲线
    );

    // 监听动画状态变化
    _optionsAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimating = false;
      } else if (status == AnimationStatus.dismissed) {
        _isAnimating = false;
      }
    });
  }

  /// 释放所有动画资源
  void _disposeAnimations() {
    _fabAnimationController.dispose();
    _overlayAnimationController.dispose();
    _optionsAnimationController.dispose();
    _fabAnimation.dispose();
    _overlayAnimation.dispose();
    _optionsAnimation.dispose();
  }

  /// 切换选项显示状态
  void _toggleOptions() {
    if (_isAnimating) return; // 防止动画期间重复触发

    _isAnimating = true;
    setState(() {
      _showOptions = !_showOptions;
    });

    if (_showOptions) {
      _playEnterAnimation();
    } else {
      _playExitAnimation();
    }
  }

  /// 隐藏选项（外部调用）
  void _hideOptions() {
    if (_showOptions && !_isAnimating) {
      _isAnimating = true;
      setState(() {
        _showOptions = false;
      });
      _playExitAnimation();
    }
  }

  /// 播放进入动画序列
  /// 动画顺序：背景模糊 → FAB旋转 → 选项卡片依次出现
  void _playEnterAnimation() {
    // 1. 立即开始背景模糊
    _overlayAnimationController.forward();

    // 2. 100ms后FAB快速旋转变成关闭图标
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _fabAnimationController.forward();
    });

    // 3. 300ms后选项卡片从下到上交错出现
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _optionsAnimationController.forward();
    });
  }

  /// 播放退出动画序列 - 增强版
  /// 动画顺序：选项卡片消失 → FAB旋转 → 背景模糊消失
  void _playExitAnimation() {
    // 1. 立即开始隐藏选项卡片（向底部退出）
    _optionsAnimationController.reverse();

    // 2. 150ms后FAB旋转回加号图标
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _fabAnimationController.reverse();
    });

    // 3. 同时开始移除背景模糊（渐进效果）
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _overlayAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 渐变模糊背景层
        _buildBlurredOverlay(),
        // 浮动选项卡片
        _buildFloatingOptions(),
        // 底部导航栏
        _buildBottomNavigationBar(),
        // 圆形FAB按钮
        _buildCircularFAB(),
      ],
    );
  }

  /// 构建渐变模糊背景
  /// 构建渐变模糊背景（增强版：淡入淡出 + 渐变模糊）
  Widget _buildBlurredOverlay() {
    if (!_showOptions && _overlayAnimationController.isDismissed) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _overlayAnimation,
        builder: (context, child) {
          // 动画值（0.0 ~ 1.0）
          final t = _overlayAnimation.value;

          // 模糊强度和透明度随 t 变化
          final blur = 20.0 * t; // 最大模糊 20
          final opacity = 0.6 * t; // 最大透明度 0.6

          return GestureDetector(
            onTap: _hideOptions,
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                // 半透明渐变背景
                Opacity(
                  opacity: opacity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1 * t),
                          Colors.black.withOpacity(0.4 * t),
                        ],
                      ),
                    ),
                  ),
                ),
                // 模糊滤镜
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: Container(color: Colors.transparent),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 构建浮动选项卡片列表
  Widget _buildFloatingOptions() {
    if (!_showOptions && _optionsAnimationController.isDismissed) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _optionsAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: widget.height + 20,
          left: 20,
          right: 20,
          child: Column(
            children:
                widget.fabOptions
                    .asMap()
                    .entries
                    .map(
                      (entry) => _buildAnimatedOption(
                        entry.value,
                        entry.key,
                        widget.fabOptions.length,
                      ),
                    )
                    .toList(),
          ),
        );
      },
    );
  }

  /// 构建底部导航栏
  Widget _buildBottomNavigationBar() {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.3), width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(children: _buildNavigationItems()),
    );
  }

  /// 构建导航项列表，在中间位置插入占位符
  List<Widget> _buildNavigationItems() {
    List<Widget> items = [];

    // 计算中间位置
    final middleIndex = (widget.items.length / 2).floor();

    // 添加前半部分导航项
    for (int i = 0; i < middleIndex; i++) {
      items.add(_buildNavigationItem(widget.items[i], i));
    }

    // 在中间添加FAB占位符
    items.add(_buildFabPlaceholder());

    // 添加后半部分导航项
    for (int i = middleIndex; i < widget.items.length; i++) {
      items.add(_buildNavigationItem(widget.items[i], i));
    }

    return items;
  }

  /// 构建FAB占位符
  Widget _buildFabPlaceholder() {
    return Expanded(
      child: Container(
        height: widget.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 占位空间，高度与FAB相匹配
            Container(
              width: widget.fabSize * 0.6,
              height: widget.fabSize * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建单个导航项
  Widget _buildNavigationItem(CircularBottomNavItem item, int index) {
    final isSelected = index == widget.currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        child: Container(
          height: widget.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 图标切换动画
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: isSelected ? item.activeIcon : item.icon,
              ),
              // 标签文字
              if (item.label != null) ...[
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        isSelected
                            ? widget.selectedItemColor
                            : widget.unselectedItemColor,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  child: Text(item.label!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建圆形FAB按钮
  Widget _buildCircularFAB() {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 - widget.fabSize / 2,
      top: -widget.fabElevation,
      child: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_fabAnimation.value * 0.08), // 轻微缩放效果，退出时更自然
            child: Container(
              width: widget.fabSize,
              height: widget.fabSize,
              decoration: BoxDecoration(
                color: widget.fabBackgroundColor,
                shape: BoxShape.circle,
                border: Border.all(color: widget.backgroundColor, width: 8.0),
                boxShadow: [
                  // 主阴影 - 根据动画状态调整
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 2,
                    blurRadius: 12 + (_fabAnimation.value * 6),
                    offset: Offset(0, 4 + (_fabAnimation.value * 2)),
                  ),
                  // 高光效果
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    spreadRadius: -2,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(widget.fabSize / 2),
                  onTap: _toggleOptions,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    reverseDuration: const Duration(milliseconds: 150),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: RotationTransition(
                          turns: animation,
                          child: child,
                        ),
                      );
                    },
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: Icon(
                      _showOptions ? Icons.close : Icons.add,
                      key: ValueKey(_showOptions),
                      size: widget.fabSize * 0.4,
                      color: widget.fabIconColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建带动画的选项卡片 - 增强退出动画
  ///
  /// [option] 选项配置
  /// [index] 选项索引
  /// [totalCount] 选项总数
  /// 构建带动画的选项卡片 - 增强退出动画
  /// 构建带动画的选项卡片 - 支持进入和退出的交错动画
  Widget _buildAnimatedOption(FabOptionItem option, int index, int totalCount) {
    return AnimatedBuilder(
      animation: _optionsAnimation,
      builder: (context, child) {
        final status = _optionsAnimationController.status;

        // === 进入动画（从下往上交错出现） ===
        if (status == AnimationStatus.forward ||
            status == AnimationStatus.completed) {
          final staggerDelay = (totalCount - 1 - index) * 0.1; // 延迟更短更快
          final adjustedValue = (_optionsAnimation.value - staggerDelay).clamp(
            0.0,
            1.0,
          );

          final slideValue = Curves.easeOutBack.transform(adjustedValue);
          final fadeValue = Curves.easeOut.transform(adjustedValue);
          final scaleValue = Curves.easeOut.transform(adjustedValue);

          final slideOffset = Offset(0, (1 - slideValue) * 80);

          return Transform.translate(
            offset: slideOffset,
            child: Transform.scale(
              scale: 0.8 + (scaleValue * 0.2), // 缩放幅度小一点，更快更干脆
              child: Opacity(
                opacity: fadeValue,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: _buildOptionCard(option, fadeValue),
                ),
              ),
            ),
          );
        }
        // === 退出动画（从上往下交错消失） ===
        else if (status == AnimationStatus.reverse ||
            status == AnimationStatus.dismissed) {
          final staggerDelay = index * 0.1; // 从上往下依次退出
          final adjustedValue = (_optionsAnimation.value - staggerDelay).clamp(
            0.0,
            1.0,
          );

          final slideValue = Curves.easeInCubic.transform(adjustedValue);
          final fadeValue = Curves.easeIn.transform(adjustedValue);

          final slideOffset = Offset(0, (1 - slideValue) * 80);

          return Transform.translate(
            offset: slideOffset,
            child: Opacity(
              opacity: fadeValue,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: _buildOptionCard(option, fadeValue),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  /// 构建单个选项卡片UI
  Widget _buildOptionCard(FabOptionItem option, double fadeValue) {
    return GestureDetector(
      onTap: () {
        _hideOptions();
        option.onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(60),
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
          boxShadow: [
            // 主阴影 - 根据fadeValue调整强度
            BoxShadow(
              color: Colors.black.withOpacity(0.12 * fadeValue),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
            // 辅助阴影
            BoxShadow(
              color: Colors.black.withOpacity(0.06 * fadeValue),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 图标容器
            _buildOptionIcon(option, fadeValue),
            const SizedBox(width: 16),
            // 文本内容
            _buildOptionText(option),
            // 箭头指示器
            _buildArrowIndicator(),
          ],
        ),
      ),
    );
  }

  /// 构建选项图标
  Widget _buildOptionIcon(FabOptionItem option, double fadeValue) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: option.backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: option.backgroundColor.withOpacity(0.3 * fadeValue),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(option.icon, color: option.iconColor, size: 22),
    );
  }

  /// 构建选项文本
  Widget _buildOptionText(FabOptionItem option) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            option.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            option.subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建箭头指示器
  Widget _buildArrowIndicator() {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
    );
  }
}
