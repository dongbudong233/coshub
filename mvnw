#!/usr/bin/env bash
# =============================================================
# CosHub 专用 Maven Wrapper
# 用途：规避 Git Bash 下 mvn 脚本 cygpath 对中文路径的转换问题
# 用法：在项目根目录执行  ./mvnw -version  /  ./mvnw clean package
# =============================================================
set -e

# 将 MSYS 路径 /d/foo 转为 Windows 正斜杠路径 d:/foo
to_win() {
  printf '%s' "$1" | sed -E 's#^/([a-zA-Z])/#\1:/#'
}

# 优先使用本机 JDK 17+（借用 Android Studio 自带的 JDK 21，零安装）
JAVA_HOME="${JAVA_HOME:-D:/android/androidStudio/jbr}"
JAVA="$JAVA_HOME/bin/java.exe"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAVEN_HOME="$(to_win "$SCRIPT_DIR")/../.tools/apache-maven-3.9.9"
PROJECT_DIR="$(to_win "$(pwd)")"

exec "$JAVA" \
  -classpath "$MAVEN_HOME/boot/plexus-classworlds-2.8.0.jar" \
  "-Dclassworlds.conf=$MAVEN_HOME/bin/m2.conf" \
  "-Dmaven.home=$MAVEN_HOME" \
  "-Dmaven.multiModuleProjectDirectory=$PROJECT_DIR" \
  org.codehaus.plexus.classworlds.launcher.Launcher "$@"
