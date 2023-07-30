enum ScalingStyles { fixed, fill, shrink }

class ScalingStyle {
  final double? dimension;
  final ScalingStyles style;

  const ScalingStyle.fill()
      : style = ScalingStyles.fill,
        dimension = null;

  const ScalingStyle.shrink()
      : style = ScalingStyles.shrink,
        dimension = null;

  const ScalingStyle.fixed(this.dimension) : style = ScalingStyles.fixed;
}
