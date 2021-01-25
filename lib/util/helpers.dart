class Helpers {
  static String formatNumber(int stat) {
    String statStr = stat.toString();

    if (statStr.length <= 3) {
      return statStr;
    }

    if (statStr.length > 6) {
      return '${statStr.substring(0, (statStr.length - 6))}M';
    }

    return '${statStr.substring(0, (statStr.length - 3))}K';
  }
}
