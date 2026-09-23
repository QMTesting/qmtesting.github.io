# Appendix B — Complete Final `FSWEP_Login` Source Code

This appendix contains the complete source-controlled code required to reconstruct the final clean-room accepted `FSWEP_Login` Regression and Retest framework. Legacy, experimental, generated, IDE-specific, and build-output files are intentionally excluded.

> **Publication-safety note:** The two JSON test-data files are reproduced with placeholder credentials. Nonblank usernames are shown as `YOUR_TEST_USERNAME`; valid and intentionally invalid passwords are shown as `YOUR_VALID_TEST_PASSWORD` and `YOUR_INVALID_TEST_PASSWORD`. Blank username/password values used by negative Test Cases remain blank. Apart from those credential substitutions, the core listings are taken from the final uploaded project files. Before running the project, replace the placeholders with credentials for your own authorized training/test account.

> **Azure DevOps note:** The pipeline YAML retains the training project's environment-specific organization, project, team, and pool values so the listings reflect the accepted project. Readers recreating the exercise in another environment must change those values and configure `AZURE_PAT` as a secret variable in each pipeline; never place the PAT in source code.

## Master source-code index

| # | File | Lines | Purpose |
|---:|---|---:|---|
| 1 | `.gitignore` | 47 | Excludes generated build output, IDE metadata, screenshots, TestNG output, and local environment files from source control. |
| 2 | `pom.xml` | 53 | Defines the Maven project, Java 17 compiler settings, and Selenium, TestNG, Jackson, and SLF4J dependencies. |
| 3 | `mvnw` | 295 | Maven Wrapper launcher for Unix-like environments. |
| 4 | `mvnw.cmd` | 189 | Maven Wrapper launcher used on Windows and by the Azure Pipelines jobs. |
| 5 | `.mvn/wrapper/maven-wrapper.properties` | 3 | Configures Maven Wrapper 3.3.4 to download Maven 3.9.9 using the script-only distribution mode. |
| 6 | `azure-pipelines.yml` | 320 | Orchestrates the complete seven-Test-Case Regression pipeline. |
| 7 | `azure-retest-pipeline.yml` | 335 | Orchestrates dynamic Resolved-Bug discovery and selective defect retesting. |
| 8 | `src/test/java/FSWEP_LoginP/BaseTest.java` | 49 | Creates and cleans up the Chrome WebDriver environment for each TestNG test method. |
| 9 | `src/test/java/FSWEP_LoginP/LoggerUtility.java` | 122 | Provides consistent logging and test execution summaries. |
| 10 | `src/test/java/FSWEP_LoginP/LoginData.java` | 79 | Represents one data-driven login Test Case and retains its stable TCxxx identifier. |
| 11 | `src/test/java/FSWEP_LoginP/LoginDataProvider.java` | 138 | Loads JSON test data and supports runtime data-file and Test Case ID filtering. |
| 12 | `src/test/java/FSWEP_LoginP/LoginPage.java` | 167 | Encapsulates Selenium interactions with the FSWEP login page. |
| 13 | `src/test/java/FSWEP_LoginP/LoginResult.java` | 22 | Stores the actual result and message returned by the application. |
| 14 | `src/test/java/FSWEP_LoginP/LoginValidator.java` | 63 | Performs TestNG assertions comparing expected and actual application behavior. |
| 15 | `src/test/java/FSWEP_LoginP/ScreenshotUtility.java` | 56 | Captures failure screenshots beneath the Screenshots directory. |
| 16 | `src/test/java/FSWEP_LoginP/SeleniumLoginDataDrivenTest.java` | 85 | Coordinates the high-level data-driven Selenium login test workflow. |
| 17 | `src/test/java/FSWEP_LoginP/TestListener.java` | 54 | Responds to TestNG success/failure events and captures evidence when tests fail. |
| 18 | `src/test/resources/testdata/loginData-regression.json` | 65 | Canonical Test Case definitions and full-regression execution data. Credentials are replaced with publication placeholders. |
| 19 | `src/test/resources/testdata/loginData-retest.json` | 65 | Training-only retest fixture used to simulate one successful and one unsuccessful developer fix. Credentials are replaced with publication placeholders. |
| 20 | `scripts/azure-devops/Add-ExecutionTraceability.ps1` | 513 | Adds exact Azure Test Run and pipeline-build hyperlinks to participating work items and records evidence. |
| 21 | `scripts/azure-devops/Attach-BugScreenshot.ps1` | 273 | Attaches the matching failure screenshot to each automation Bug. |
| 22 | `scripts/azure-devops/Attach-TestResultScreenshot.ps1` | 329 | Attaches the matching Selenium failure screenshot to the exact Azure Test Result. |
| 23 | `scripts/azure-devops/Attach-TestRunLog.ps1` | 223 | Attaches the Maven execution log to the Azure Test Run. |
| 24 | `scripts/azure-devops/Clean-Screenshots.ps1` | 53 | Deletes screenshots from previous executions to prevent stale evidence. |
| 25 | `scripts/azure-devops/Collect-TestEvidence.ps1` | 202 | Collects JSON maps, Surefire output, screenshots, and logs into the pipeline evidence directory. |
| 26 | `scripts/azure-devops/Create-Or-Reuse-Bugs.ps1` | 879 | Creates or reuses automation Bugs for failed regression Test Cases and preserves relationships. |
| 27 | `scripts/azure-devops/Create-TestRun.ps1` | 612 | Creates a full or selective Azure Test Run from the Test Points associated with the selected Test Cases. |
| 28 | `scripts/azure-devops/Ensure-Iteration.ps1` | 289 | Finds or creates Sprint 001 and exposes the iteration path to later pipeline tasks. |
| 29 | `scripts/azure-devops/Ensure-TestCases.ps1` | 891 | Creates or reuses Azure Test Cases from the canonical regression JSON and preserves existing lifecycle state. |
| 30 | `scripts/azure-devops/Ensure-TestPlan.ps1` | 524 | Finds or creates TP001 and records its Azure mapping. |
| 31 | `scripts/azure-devops/Ensure-TestSuite.ps1` | 592 | Finds or creates TS001 and links it into the training test-management structure. |
| 32 | `scripts/azure-devops/Ensure-UserStory.ps1` | 475 | Finds or creates US001 and establishes the initial Resolved state only when newly created. |
| 33 | `scripts/azure-devops/Find-Resolved-Automation-Bugs.ps1` | 513 | Discovers qualifying Resolved automation Bugs, follows their Related Test Case relationships, and builds the selective retest queue. |
| 34 | `scripts/azure-devops/Link-BugToTestResult.ps1` | 241 | Associates regression Bugs with the exact Azure Test Results that exposed the failures. |
| 35 | `scripts/azure-devops/Link-RetestBugsToTestResults.ps1` | 465 | Associates existing Bugs with the exact RT001 Test Results produced during selective verification. |
| 36 | `scripts/azure-devops/Process-RetestLifecycle.ps1` | 559 | Processes retest outcomes: Passed closes a Resolved Bug; Failed reactivates it, while recording verification comments and evidence. |
| 37 | `scripts/azure-devops/Update-TestRunResults.ps1` | 555 | Parses Surefire/TestNG XML and updates the corresponding Azure Test Results and Test Run. |

**Core framework total:** 37 files.

## Root project and Maven files

### `.gitignore`

**Purpose:** Excludes generated build output, IDE metadata, screenshots, TestNG output, and local environment files from source control.

```gitignore
target/
!.mvn/wrapper/maven-wrapper.jar
!**/src/main/**/target/
!**/src/test/**/target/
.kotlin

### IntelliJ IDEA ###
.idea/
.idea/modules.xml
.idea/jarRepositories.xml
.idea/compiler.xml
.idea/libraries/
*.iws
*.iml
*.ipr

### Eclipse ###
.apt_generated
.classpath
.factorypath
.project
.settings
.springBeans
.sts4-cache

### NetBeans ###
/nbproject/private/
/nbbuild/
/dist/
/nbdist/
/.nb-gradle/
build/
!**/src/main/**/build/
!**/src/test/**/build/

### VS Code ###
.vscode/

### Mac OS ###
.DS_Store

# Automated test output
Screenshots/
test-output/

# Local environment files
.env
```

### `pom.xml`

**Purpose:** Defines the Maven project, Java 17 compiler settings, and Selenium, TestNG, Jackson, and SLF4J dependencies.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>FSWEP_Login</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>

        <selenium.version>4.18.1</selenium.version>
        <testng.version>7.10.2</testng.version>
        <jackson.version>2.19.2</jackson.version>
    </properties>

    <dependencies>
        <!-- Selenium WebDriver Framework -->
        <dependency>
            <groupId>org.seleniumhq.selenium</groupId>
            <artifactId>selenium-java</artifactId>
            <version>${selenium.version}</version>
        </dependency>

        <!-- TestNG Testing Framework -->
        <dependency>
            <groupId>org.testng</groupId>
            <artifactId>testng</artifactId>
            <version>${testng.version}</version>
            <scope>test</scope>
        </dependency>

        <!-- Clears SLF4J Logging Console Warnings by matching the 1.7.x API -->
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-simple</artifactId>
            <version>1.7.36</version>
        </dependency>

        <!-- Add Jackson -->
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
            <version>${jackson.version}</version>
        </dependency>

    </dependencies>

</project>
```

### `mvnw`

**Purpose:** Maven Wrapper launcher for Unix-like environments.

```bash
#!/bin/sh
# ----------------------------------------------------------------------------
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Apache Maven Wrapper startup batch script, version 3.3.4
#
# Optional ENV vars
# -----------------
#   JAVA_HOME - location of a JDK home dir, required when download maven via java source
#   MVNW_REPOURL - repo url base for downloading maven distribution
#   MVNW_USERNAME/MVNW_PASSWORD - user and password for downloading maven
#   MVNW_VERBOSE - true: enable verbose log; debug: trace the mvnw script; others: silence the output
# ----------------------------------------------------------------------------

set -euf
[ "${MVNW_VERBOSE-}" != debug ] || set -x

# OS specific support.
native_path() { printf %s\\n "$1"; }
case "$(uname)" in
CYGWIN* | MINGW*)
  [ -z "${JAVA_HOME-}" ] || JAVA_HOME="$(cygpath --unix "$JAVA_HOME")"
  native_path() { cygpath --path --windows "$1"; }
  ;;
esac

# set JAVACMD and JAVACCMD
set_java_home() {
  # For Cygwin and MinGW, ensure paths are in Unix format before anything is touched
  if [ -n "${JAVA_HOME-}" ]; then
    if [ -x "$JAVA_HOME/jre/sh/java" ]; then
      # IBM's JDK on AIX uses strange locations for the executables
      JAVACMD="$JAVA_HOME/jre/sh/java"
      JAVACCMD="$JAVA_HOME/jre/sh/javac"
    else
      JAVACMD="$JAVA_HOME/bin/java"
      JAVACCMD="$JAVA_HOME/bin/javac"

      if [ ! -x "$JAVACMD" ] || [ ! -x "$JAVACCMD" ]; then
        echo "The JAVA_HOME environment variable is not defined correctly, so mvnw cannot run." >&2
        echo "JAVA_HOME is set to \"$JAVA_HOME\", but \"\$JAVA_HOME/bin/java\" or \"\$JAVA_HOME/bin/javac\" does not exist." >&2
        return 1
      fi
    fi
  else
    JAVACMD="$(
      'set' +e
      'unset' -f command 2>/dev/null
      'command' -v java
    )" || :
    JAVACCMD="$(
      'set' +e
      'unset' -f command 2>/dev/null
      'command' -v javac
    )" || :

    if [ ! -x "${JAVACMD-}" ] || [ ! -x "${JAVACCMD-}" ]; then
      echo "The java/javac command does not exist in PATH nor is JAVA_HOME set, so mvnw cannot run." >&2
      return 1
    fi
  fi
}

# hash string like Java String::hashCode
hash_string() {
  str="${1:-}" h=0
  while [ -n "$str" ]; do
    char="${str%"${str#?}"}"
    h=$(((h * 31 + $(LC_CTYPE=C printf %d "'$char")) % 4294967296))
    str="${str#?}"
  done
  printf %x\\n $h
}

verbose() { :; }
[ "${MVNW_VERBOSE-}" != true ] || verbose() { printf %s\\n "${1-}"; }

die() {
  printf %s\\n "$1" >&2
  exit 1
}

trim() {
  # MWRAPPER-139:
  #   Trims trailing and leading whitespace, carriage returns, tabs, and linefeeds.
  #   Needed for removing poorly interpreted newline sequences when running in more
  #   exotic environments such as mingw bash on Windows.
  printf "%s" "${1}" | tr -d '[:space:]'
}

scriptDir="$(dirname "$0")"
scriptName="$(basename "$0")"

# parse distributionUrl and optional distributionSha256Sum, requires .mvn/wrapper/maven-wrapper.properties
while IFS="=" read -r key value; do
  case "${key-}" in
  distributionUrl) distributionUrl=$(trim "${value-}") ;;
  distributionSha256Sum) distributionSha256Sum=$(trim "${value-}") ;;
  esac
done <"$scriptDir/.mvn/wrapper/maven-wrapper.properties"
[ -n "${distributionUrl-}" ] || die "cannot read distributionUrl property in $scriptDir/.mvn/wrapper/maven-wrapper.properties"

case "${distributionUrl##*/}" in
maven-mvnd-*bin.*)
  MVN_CMD=mvnd.sh _MVNW_REPO_PATTERN=/maven/mvnd/
  case "${PROCESSOR_ARCHITECTURE-}${PROCESSOR_ARCHITEW6432-}:$(uname -a)" in
  *AMD64:CYGWIN* | *AMD64:MINGW*) distributionPlatform=windows-amd64 ;;
  :Darwin*x86_64) distributionPlatform=darwin-amd64 ;;
  :Darwin*arm64) distributionPlatform=darwin-aarch64 ;;
  :Linux*x86_64*) distributionPlatform=linux-amd64 ;;
  *)
    echo "Cannot detect native platform for mvnd on $(uname)-$(uname -m), use pure java version" >&2
    distributionPlatform=linux-amd64
    ;;
  esac
  distributionUrl="${distributionUrl%-bin.*}-$distributionPlatform.zip"
  ;;
maven-mvnd-*) MVN_CMD=mvnd.sh _MVNW_REPO_PATTERN=/maven/mvnd/ ;;
*) MVN_CMD="mvn${scriptName#mvnw}" _MVNW_REPO_PATTERN=/org/apache/maven/ ;;
esac

# apply MVNW_REPOURL and calculate MAVEN_HOME
# maven home pattern: ~/.m2/wrapper/dists/{apache-maven-<version>,maven-mvnd-<version>-<platform>}/<hash>
[ -z "${MVNW_REPOURL-}" ] || distributionUrl="$MVNW_REPOURL$_MVNW_REPO_PATTERN${distributionUrl#*"$_MVNW_REPO_PATTERN"}"
distributionUrlName="${distributionUrl##*/}"
distributionUrlNameMain="${distributionUrlName%.*}"
distributionUrlNameMain="${distributionUrlNameMain%-bin}"
MAVEN_USER_HOME="${MAVEN_USER_HOME:-${HOME}/.m2}"
MAVEN_HOME="${MAVEN_USER_HOME}/wrapper/dists/${distributionUrlNameMain-}/$(hash_string "$distributionUrl")"

exec_maven() {
  unset MVNW_VERBOSE MVNW_USERNAME MVNW_PASSWORD MVNW_REPOURL || :
  exec "$MAVEN_HOME/bin/$MVN_CMD" "$@" || die "cannot exec $MAVEN_HOME/bin/$MVN_CMD"
}

if [ -d "$MAVEN_HOME" ]; then
  verbose "found existing MAVEN_HOME at $MAVEN_HOME"
  exec_maven "$@"
fi

case "${distributionUrl-}" in
*?-bin.zip | *?maven-mvnd-?*-?*.zip) ;;
*) die "distributionUrl is not valid, must match *-bin.zip or maven-mvnd-*.zip, but found '${distributionUrl-}'" ;;
esac

# prepare tmp dir
if TMP_DOWNLOAD_DIR="$(mktemp -d)" && [ -d "$TMP_DOWNLOAD_DIR" ]; then
  clean() { rm -rf -- "$TMP_DOWNLOAD_DIR"; }
  trap clean HUP INT TERM EXIT
else
  die "cannot create temp dir"
fi

mkdir -p -- "${MAVEN_HOME%/*}"

# Download and Install Apache Maven
verbose "Couldn't find MAVEN_HOME, downloading and installing it ..."
verbose "Downloading from: $distributionUrl"
verbose "Downloading to: $TMP_DOWNLOAD_DIR/$distributionUrlName"

# select .zip or .tar.gz
if ! command -v unzip >/dev/null; then
  distributionUrl="${distributionUrl%.zip}.tar.gz"
  distributionUrlName="${distributionUrl##*/}"
fi

# verbose opt
__MVNW_QUIET_WGET=--quiet __MVNW_QUIET_CURL=--silent __MVNW_QUIET_UNZIP=-q __MVNW_QUIET_TAR=''
[ "${MVNW_VERBOSE-}" != true ] || __MVNW_QUIET_WGET='' __MVNW_QUIET_CURL='' __MVNW_QUIET_UNZIP='' __MVNW_QUIET_TAR=v

# normalize http auth
case "${MVNW_PASSWORD:+has-password}" in
'') MVNW_USERNAME='' MVNW_PASSWORD='' ;;
has-password) [ -n "${MVNW_USERNAME-}" ] || MVNW_USERNAME='' MVNW_PASSWORD='' ;;
esac

if [ -z "${MVNW_USERNAME-}" ] && command -v wget >/dev/null; then
  verbose "Found wget ... using wget"
  wget ${__MVNW_QUIET_WGET:+"$__MVNW_QUIET_WGET"} "$distributionUrl" -O "$TMP_DOWNLOAD_DIR/$distributionUrlName" || die "wget: Failed to fetch $distributionUrl"
elif [ -z "${MVNW_USERNAME-}" ] && command -v curl >/dev/null; then
  verbose "Found curl ... using curl"
  curl ${__MVNW_QUIET_CURL:+"$__MVNW_QUIET_CURL"} -f -L -o "$TMP_DOWNLOAD_DIR/$distributionUrlName" "$distributionUrl" || die "curl: Failed to fetch $distributionUrl"
elif set_java_home; then
  verbose "Falling back to use Java to download"
  javaSource="$TMP_DOWNLOAD_DIR/Downloader.java"
  targetZip="$TMP_DOWNLOAD_DIR/$distributionUrlName"
  cat >"$javaSource" <<-END
	public class Downloader extends java.net.Authenticator
	{
	  protected java.net.PasswordAuthentication getPasswordAuthentication()
	  {
	    return new java.net.PasswordAuthentication( System.getenv( "MVNW_USERNAME" ), System.getenv( "MVNW_PASSWORD" ).toCharArray() );
	  }
	  public static void main( String[] args ) throws Exception
	  {
	    setDefault( new Downloader() );
	    java.nio.file.Files.copy( java.net.URI.create( args[0] ).toURL().openStream(), java.nio.file.Paths.get( args[1] ).toAbsolutePath().normalize() );
	  }
	}
	END
  # For Cygwin/MinGW, switch paths to Windows format before running javac and java
  verbose " - Compiling Downloader.java ..."
  "$(native_path "$JAVACCMD")" "$(native_path "$javaSource")" || die "Failed to compile Downloader.java"
  verbose " - Running Downloader.java ..."
  "$(native_path "$JAVACMD")" -cp "$(native_path "$TMP_DOWNLOAD_DIR")" Downloader "$distributionUrl" "$(native_path "$targetZip")"
fi

# If specified, validate the SHA-256 sum of the Maven distribution zip file
if [ -n "${distributionSha256Sum-}" ]; then
  distributionSha256Result=false
  if [ "$MVN_CMD" = mvnd.sh ]; then
    echo "Checksum validation is not supported for maven-mvnd." >&2
    echo "Please disable validation by removing 'distributionSha256Sum' from your maven-wrapper.properties." >&2
    exit 1
  elif command -v sha256sum >/dev/null; then
    if echo "$distributionSha256Sum  $TMP_DOWNLOAD_DIR/$distributionUrlName" | sha256sum -c - >/dev/null 2>&1; then
      distributionSha256Result=true
    fi
  elif command -v shasum >/dev/null; then
    if echo "$distributionSha256Sum  $TMP_DOWNLOAD_DIR/$distributionUrlName" | shasum -a 256 -c >/dev/null 2>&1; then
      distributionSha256Result=true
    fi
  else
    echo "Checksum validation was requested but neither 'sha256sum' or 'shasum' are available." >&2
    echo "Please install either command, or disable validation by removing 'distributionSha256Sum' from your maven-wrapper.properties." >&2
    exit 1
  fi
  if [ $distributionSha256Result = false ]; then
    echo "Error: Failed to validate Maven distribution SHA-256, your Maven distribution might be compromised." >&2
    echo "If you updated your Maven version, you need to update the specified distributionSha256Sum property." >&2
    exit 1
  fi
fi

# unzip and move
if command -v unzip >/dev/null; then
  unzip ${__MVNW_QUIET_UNZIP:+"$__MVNW_QUIET_UNZIP"} "$TMP_DOWNLOAD_DIR/$distributionUrlName" -d "$TMP_DOWNLOAD_DIR" || die "failed to unzip"
else
  tar xzf${__MVNW_QUIET_TAR:+"$__MVNW_QUIET_TAR"} "$TMP_DOWNLOAD_DIR/$distributionUrlName" -C "$TMP_DOWNLOAD_DIR" || die "failed to untar"
fi

# Find the actual extracted directory name (handles snapshots where filename != directory name)
actualDistributionDir=""

# First try the expected directory name (for regular distributions)
if [ -d "$TMP_DOWNLOAD_DIR/$distributionUrlNameMain" ]; then
  if [ -f "$TMP_DOWNLOAD_DIR/$distributionUrlNameMain/bin/$MVN_CMD" ]; then
    actualDistributionDir="$distributionUrlNameMain"
  fi
fi

# If not found, search for any directory with the Maven executable (for snapshots)
if [ -z "$actualDistributionDir" ]; then
  # enable globbing to iterate over items
  set +f
  for dir in "$TMP_DOWNLOAD_DIR"/*; do
    if [ -d "$dir" ]; then
      if [ -f "$dir/bin/$MVN_CMD" ]; then
        actualDistributionDir="$(basename "$dir")"
        break
      fi
    fi
  done
  set -f
fi

if [ -z "$actualDistributionDir" ]; then
  verbose "Contents of $TMP_DOWNLOAD_DIR:"
  verbose "$(ls -la "$TMP_DOWNLOAD_DIR")"
  die "Could not find Maven distribution directory in extracted archive"
fi

verbose "Found extracted Maven distribution directory: $actualDistributionDir"
printf %s\\n "$distributionUrl" >"$TMP_DOWNLOAD_DIR/$actualDistributionDir/mvnw.url"
mv -- "$TMP_DOWNLOAD_DIR/$actualDistributionDir" "$MAVEN_HOME" || [ -d "$MAVEN_HOME" ] || die "fail to move MAVEN_HOME"

clean || :
exec_maven "$@"
```

### `mvnw.cmd`

**Purpose:** Maven Wrapper launcher used on Windows and by the Azure Pipelines jobs.

```batch
<# : batch portion
@REM ----------------------------------------------------------------------------
@REM Licensed to the Apache Software Foundation (ASF) under one
@REM or more contributor license agreements.  See the NOTICE file
@REM distributed with this work for additional information
@REM regarding copyright ownership.  The ASF licenses this file
@REM to you under the Apache License, Version 2.0 (the
@REM "License"); you may not use this file except in compliance
@REM with the License.  You may obtain a copy of the License at
@REM
@REM    http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing,
@REM software distributed under the License is distributed on an
@REM "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
@REM KIND, either express or implied.  See the License for the
@REM specific language governing permissions and limitations
@REM under the License.
@REM ----------------------------------------------------------------------------

@REM ----------------------------------------------------------------------------
@REM Apache Maven Wrapper startup batch script, version 3.3.4
@REM
@REM Optional ENV vars
@REM   MVNW_REPOURL - repo url base for downloading maven distribution
@REM   MVNW_USERNAME/MVNW_PASSWORD - user and password for downloading maven
@REM   MVNW_VERBOSE - true: enable verbose log; others: silence the output
@REM ----------------------------------------------------------------------------

@IF "%__MVNW_ARG0_NAME__%"=="" (SET __MVNW_ARG0_NAME__=%~nx0)
@SET __MVNW_CMD__=
@SET __MVNW_ERROR__=
@SET __MVNW_PSMODULEP_SAVE=%PSModulePath%
@SET PSModulePath=
@FOR /F "usebackq tokens=1* delims==" %%A IN (`powershell -noprofile "& {$scriptDir='%~dp0'; $script='%__MVNW_ARG0_NAME__%'; icm -ScriptBlock ([Scriptblock]::Create((Get-Content -Raw '%~f0'))) -NoNewScope}"`) DO @(
  IF "%%A"=="MVN_CMD" (set __MVNW_CMD__=%%B) ELSE IF "%%B"=="" (echo %%A) ELSE (echo %%A=%%B)
)
@SET PSModulePath=%__MVNW_PSMODULEP_SAVE%
@SET __MVNW_PSMODULEP_SAVE=
@SET __MVNW_ARG0_NAME__=
@SET MVNW_USERNAME=
@SET MVNW_PASSWORD=
@IF NOT "%__MVNW_CMD__%"=="" ("%__MVNW_CMD__%" %*)
@echo Cannot start maven from wrapper >&2 && exit /b 1
@GOTO :EOF
: end batch / begin powershell #>

$ErrorActionPreference = "Stop"
if ($env:MVNW_VERBOSE -eq "true") {
  $VerbosePreference = "Continue"
}

# calculate distributionUrl, requires .mvn/wrapper/maven-wrapper.properties
$distributionUrl = (Get-Content -Raw "$scriptDir/.mvn/wrapper/maven-wrapper.properties" | ConvertFrom-StringData).distributionUrl
if (!$distributionUrl) {
  Write-Error "cannot read distributionUrl property in $scriptDir/.mvn/wrapper/maven-wrapper.properties"
}

switch -wildcard -casesensitive ( $($distributionUrl -replace '^.*/','') ) {
  "maven-mvnd-*" {
    $USE_MVND = $true
    $distributionUrl = $distributionUrl -replace '-bin\.[^.]*$',"-windows-amd64.zip"
    $MVN_CMD = "mvnd.cmd"
    break
  }
  default {
    $USE_MVND = $false
    $MVN_CMD = $script -replace '^mvnw','mvn'
    break
  }
}

# apply MVNW_REPOURL and calculate MAVEN_HOME
# maven home pattern: ~/.m2/wrapper/dists/{apache-maven-<version>,maven-mvnd-<version>-<platform>}/<hash>
if ($env:MVNW_REPOURL) {
  $MVNW_REPO_PATTERN = if ($USE_MVND -eq $False) { "/org/apache/maven/" } else { "/maven/mvnd/" }
  $distributionUrl = "$env:MVNW_REPOURL$MVNW_REPO_PATTERN$($distributionUrl -replace "^.*$MVNW_REPO_PATTERN",'')"
}
$distributionUrlName = $distributionUrl -replace '^.*/',''
$distributionUrlNameMain = $distributionUrlName -replace '\.[^.]*$','' -replace '-bin$',''

$MAVEN_M2_PATH = "$HOME/.m2"
if ($env:MAVEN_USER_HOME) {
  $MAVEN_M2_PATH = "$env:MAVEN_USER_HOME"
}

if (-not (Test-Path -Path $MAVEN_M2_PATH)) {
    New-Item -Path $MAVEN_M2_PATH -ItemType Directory | Out-Null
}

$MAVEN_WRAPPER_DISTS = $null
if ((Get-Item $MAVEN_M2_PATH).Target[0] -eq $null) {
  $MAVEN_WRAPPER_DISTS = "$MAVEN_M2_PATH/wrapper/dists"
} else {
  $MAVEN_WRAPPER_DISTS = (Get-Item $MAVEN_M2_PATH).Target[0] + "/wrapper/dists"
}

$MAVEN_HOME_PARENT = "$MAVEN_WRAPPER_DISTS/$distributionUrlNameMain"
$MAVEN_HOME_NAME = ([System.Security.Cryptography.SHA256]::Create().ComputeHash([byte[]][char[]]$distributionUrl) | ForEach-Object {$_.ToString("x2")}) -join ''
$MAVEN_HOME = "$MAVEN_HOME_PARENT/$MAVEN_HOME_NAME"

if (Test-Path -Path "$MAVEN_HOME" -PathType Container) {
  Write-Verbose "found existing MAVEN_HOME at $MAVEN_HOME"
  Write-Output "MVN_CMD=$MAVEN_HOME/bin/$MVN_CMD"
  exit $?
}

if (! $distributionUrlNameMain -or ($distributionUrlName -eq $distributionUrlNameMain)) {
  Write-Error "distributionUrl is not valid, must end with *-bin.zip, but found $distributionUrl"
}

# prepare tmp dir
$TMP_DOWNLOAD_DIR_HOLDER = New-TemporaryFile
$TMP_DOWNLOAD_DIR = New-Item -Itemtype Directory -Path "$TMP_DOWNLOAD_DIR_HOLDER.dir"
$TMP_DOWNLOAD_DIR_HOLDER.Delete() | Out-Null
trap {
  if ($TMP_DOWNLOAD_DIR.Exists) {
    try { Remove-Item $TMP_DOWNLOAD_DIR -Recurse -Force | Out-Null }
    catch { Write-Warning "Cannot remove $TMP_DOWNLOAD_DIR" }
  }
}

New-Item -Itemtype Directory -Path "$MAVEN_HOME_PARENT" -Force | Out-Null

# Download and Install Apache Maven
Write-Verbose "Couldn't find MAVEN_HOME, downloading and installing it ..."
Write-Verbose "Downloading from: $distributionUrl"
Write-Verbose "Downloading to: $TMP_DOWNLOAD_DIR/$distributionUrlName"

$webclient = New-Object System.Net.WebClient
if ($env:MVNW_USERNAME -and $env:MVNW_PASSWORD) {
  $webclient.Credentials = New-Object System.Net.NetworkCredential($env:MVNW_USERNAME, $env:MVNW_PASSWORD)
}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$webclient.DownloadFile($distributionUrl, "$TMP_DOWNLOAD_DIR/$distributionUrlName") | Out-Null

# If specified, validate the SHA-256 sum of the Maven distribution zip file
$distributionSha256Sum = (Get-Content -Raw "$scriptDir/.mvn/wrapper/maven-wrapper.properties" | ConvertFrom-StringData).distributionSha256Sum
if ($distributionSha256Sum) {
  if ($USE_MVND) {
    Write-Error "Checksum validation is not supported for maven-mvnd. `nPlease disable validation by removing 'distributionSha256Sum' from your maven-wrapper.properties."
  }
  Import-Module $PSHOME\Modules\Microsoft.PowerShell.Utility -Function Get-FileHash
  if ((Get-FileHash "$TMP_DOWNLOAD_DIR/$distributionUrlName" -Algorithm SHA256).Hash.ToLower() -ne $distributionSha256Sum) {
    Write-Error "Error: Failed to validate Maven distribution SHA-256, your Maven distribution might be compromised. If you updated your Maven version, you need to update the specified distributionSha256Sum property."
  }
}

# unzip and move
Expand-Archive "$TMP_DOWNLOAD_DIR/$distributionUrlName" -DestinationPath "$TMP_DOWNLOAD_DIR" | Out-Null

# Find the actual extracted directory name (handles snapshots where filename != directory name)
$actualDistributionDir = ""

# First try the expected directory name (for regular distributions)
$expectedPath = Join-Path "$TMP_DOWNLOAD_DIR" "$distributionUrlNameMain"
$expectedMvnPath = Join-Path "$expectedPath" "bin/$MVN_CMD"
if ((Test-Path -Path $expectedPath -PathType Container) -and (Test-Path -Path $expectedMvnPath -PathType Leaf)) {
  $actualDistributionDir = $distributionUrlNameMain
}

# If not found, search for any directory with the Maven executable (for snapshots)
if (!$actualDistributionDir) {
  Get-ChildItem -Path "$TMP_DOWNLOAD_DIR" -Directory | ForEach-Object {
    $testPath = Join-Path $_.FullName "bin/$MVN_CMD"
    if (Test-Path -Path $testPath -PathType Leaf) {
      $actualDistributionDir = $_.Name
    }
  }
}

if (!$actualDistributionDir) {
  Write-Error "Could not find Maven distribution directory in extracted archive"
}

Write-Verbose "Found extracted Maven distribution directory: $actualDistributionDir"
Rename-Item -Path "$TMP_DOWNLOAD_DIR/$actualDistributionDir" -NewName $MAVEN_HOME_NAME | Out-Null
try {
  Move-Item -Path "$TMP_DOWNLOAD_DIR/$MAVEN_HOME_NAME" -Destination $MAVEN_HOME_PARENT | Out-Null
} catch {
  if (! (Test-Path -Path "$MAVEN_HOME" -PathType Container)) {
    Write-Error "fail to move MAVEN_HOME"
  }
} finally {
  try { Remove-Item $TMP_DOWNLOAD_DIR -Recurse -Force | Out-Null }
  catch { Write-Warning "Cannot remove $TMP_DOWNLOAD_DIR" }
}

Write-Output "MVN_CMD=$MAVEN_HOME/bin/$MVN_CMD"
```

### `.mvn/wrapper/maven-wrapper.properties`

**Purpose:** Configures Maven Wrapper 3.3.4 to download Maven 3.9.9 using the script-only distribution mode.

```properties
wrapperVersion=3.3.4
distributionType=only-script
distributionUrl=https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.9/apache-maven-3.9.9-bin.zip
```

## Azure Pipelines YAML

### `azure-pipelines.yml`

**Purpose:** Orchestrates the complete seven-Test-Case Regression pipeline.

```yaml
trigger:
  - main

pool:
  name: 'Pool_A'

variables:
  azureOrg: 'smac567'
  azureProject: 'FSWEP_567'
  sprintCode: 'SP001'
  sprintName: 'Sprint 001'
  teamName: 'FSWEP_567 Team'
  userStoryCode: 'US001'
  userStoryTitle: 'US001: FSWEP_Login_User_Story'

  testPlanCode: 'TP001'
  testPlanName: 'TP001: FSWEP Login Test Plan'

  testSuiteCode: 'TS001'
  testSuiteName: 'TS001: FSWEP_Login_Test_Suite'

  testRunCode: 'TR001'
  testRunName: 'FSWEP Login Automated Test Run'

  loginDataPath: 'src\test\resources\testdata\loginData-regression.json'
  surefireReportPath: 'target\surefire-reports'

  bugCodePrefix: 'BG'

  screenshotsPath: 'Screenshots'
  mavenLogRelativePath: 'TestEvidence\maven-test-output.log'



steps:

  # Check the software available on Agent_A
  - powershell: |
      Write-Host "Java version:"
      java -version

      Write-Host ""
      Write-Host "Maven Wrapper version:"
      .\mvnw.cmd -version
    displayName: 'Verify Java and Maven'

  - task: PowerShell@2
    displayName: 'Ensure Sprint Iteration Exists'
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Ensure-Iteration.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -TeamName "$(teamName)"
        -SprintName "$(sprintName)"
        -SprintCode "$(sprintCode)"
    env:
      AZURE_PAT: $(AZURE_PAT)

  - task: PowerShell@2
    displayName: 'Ensure Azure DevOps User Story Exists'
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Ensure-UserStory.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -UserStoryCode "$(userStoryCode)"
        -SprintCode "$(sprintCode)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      ITERATION_PATH: $(ITERATION_PATH)
      USER_STORY_TITLE: $(userStoryTitle)

  - task: PowerShell@2
    displayName: 'Ensure Azure DevOps Test Plan Exists'
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Ensure-TestPlan.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -TestPlanCode "$(testPlanCode)"
        -UserStoryCode "$(userStoryCode)"
        -SprintCode "$(sprintCode)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_PLAN_NAME: $(testPlanName)
      ITERATION_PATH: $(ITERATION_PATH)
      USER_STORY_ID: $(USER_STORY_ID)

  - task: PowerShell@2
    displayName: 'Ensure Azure DevOps Test Suite Exists'
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Ensure-TestSuite.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -TestPlanCode "$(testPlanCode)"
        -TestSuiteCode "$(testSuiteCode)"
        -UserStoryCode "$(userStoryCode)"
        -SprintCode "$(sprintCode)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_PLAN_ID: $(TEST_PLAN_ID)
      TEST_SUITE_NAME: $(testSuiteName)
      ITERATION_PATH: $(ITERATION_PATH)
      USER_STORY_ID: $(USER_STORY_ID)

  - task: PowerShell@2
    displayName: 'Ensure Azure DevOps Test Cases Exist'
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Ensure-TestCases.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -TestPlanCode "$(testPlanCode)"
        -TestSuiteCode "$(testSuiteCode)"
        -UserStoryCode "$(userStoryCode)"
        -SprintCode "$(sprintCode)"
        -LoginDataRelativePath "$(loginDataPath)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_PLAN_ID: $(TEST_PLAN_ID)
      TEST_SUITE_ID: $(TEST_SUITE_ID)
      USER_STORY_ID: $(USER_STORY_ID)
      ITERATION_PATH: $(ITERATION_PATH)

  - task: PowerShell@2
    displayName: 'Create Azure DevOps Test Run'
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Create-TestRun.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -TestRunCode "$(testRunCode)"
        -TestRunName "$(testRunName)"
        -TestPlanCode "$(testPlanCode)"
        -TestSuiteCode "$(testSuiteCode)"
        -UserStoryCode "$(userStoryCode)"
        -SprintCode "$(sprintCode)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_PLAN_ID: $(TEST_PLAN_ID)
      TEST_SUITE_ID: $(TEST_SUITE_ID)
      ITERATION_PATH: $(ITERATION_PATH)

  - task: PowerShell@2
    displayName: 'Clean Previous Screenshots'
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Clean-Screenshots.ps1'
      arguments: >
        -ScreenshotsRelativePath "$(screenshotsPath)"

  # Run all Selenium / TestNG test cases
  - powershell: |
      $artifactRoot = "$(Build.ArtifactStagingDirectory)\TestEvidence"

      New-Item `
        -ItemType Directory `
        -Force `
        -Path $artifactRoot | Out-Null

      .\mvnw.cmd clean test -DskipTests=false 2>&1 |
        Tee-Object `
          -FilePath "$artifactRoot\maven-test-output.log"

      $mavenExitCode = $LASTEXITCODE

      Write-Host ""
      Write-Host "Maven exit code: $mavenExitCode"

      exit $mavenExitCode

    displayName: 'Run Selenium TestNG Tests'
    continueOnError: true

  # ---------------------------------------------------------
  # PublishTestResults@2 is intentionally disabled.
  #
  # It creates a second Azure DevOps Test Run from the
  # Surefire XML. Our PowerShell REST API integration now
  # creates and updates the Test Plan-linked Test Run instead.
  # ---------------------------------------------------------

  # - task: PublishTestResults@2
  #   displayName: 'Publish Test Results'
  #   condition: always()
  #   inputs:
  #     testResultsFormat: 'JUnit'
  #     testResultsFiles: '**/surefire-reports/TEST-*.xml'
  #     mergeTestResults: true
  #     failTaskOnFailedTests: false
  #     testRunTitle: 'FSWEP Login Selenium Tests'

  - task: PowerShell@2
    displayName: 'Update Azure DevOps Test Run Results'
    condition: always()
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Update-TestRunResults.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -SurefireRelativePath "$(surefireReportPath)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_RUN_ID: $(TEST_RUN_ID)

  - task: PowerShell@2
    displayName: 'Attach Maven Log to Azure Test Run'
    condition: always()
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Attach-TestRunLog.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -MavenLogRelativePath "$(mavenLogRelativePath)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_RUN_ID: $(TEST_RUN_ID)

  - task: PowerShell@2
    displayName: 'Attach Screenshots to Failed Test Results'
    condition: always()
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Attach-TestResultScreenshot.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -ScreenshotsRelativePath "$(screenshotsPath)"
    env:
      AZURE_PAT: $(AZURE_PAT)

  - task: PowerShell@2
    displayName: 'Create or Reuse Bugs for Failed Tests'
    condition: always()
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Create-Or-Reuse-Bugs.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -BugCodePrefix "$(bugCodePrefix)"
        -TestPlanCode "$(testPlanCode)"
        -TestSuiteCode "$(testSuiteCode)"
        -UserStoryCode "$(userStoryCode)"
        -SprintCode "$(sprintCode)"
        -LoginDataRelativePath "$(loginDataPath)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      ITERATION_PATH: $(ITERATION_PATH)
      USER_STORY_ID: $(USER_STORY_ID)

  - task: PowerShell@2
    displayName: 'Link Bugs to Failed Test Results'
    condition: always()
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Link-BugToTestResult.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
    env:
      AZURE_PAT: $(AZURE_PAT)

  - task: PowerShell@2
    displayName: 'Attach Screenshots to Bugs'
    condition: always()
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Attach-BugScreenshot.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -ScreenshotsRelativePath "$(screenshotsPath)"
    env:
      AZURE_PAT: $(AZURE_PAT)

  - task: PowerShell@2
    displayName: 'Add Regression Execution Traceability'
    condition: always()
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Add-ExecutionTraceability.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -ExecutionType "Regression"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_PLAN_ID: $(TEST_PLAN_ID)
      TEST_SUITE_ID: $(TEST_SUITE_ID)
      TEST_RUN_ID: $(TEST_RUN_ID)

  - task: PowerShell@2
    displayName: 'Collect Test Evidence'
    condition: always()
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Collect-TestEvidence.ps1'
      arguments: >
        -ScreenshotsRelativePath "$(screenshotsPath)"
        -SurefireRelativePath "$(surefireReportPath)"

  # Publish all collected evidence as a Pipeline Artifact
  - task: PublishPipelineArtifact@1
    displayName: 'Publish Test Evidence Artifact'
    condition: always()
    inputs:
      targetPath: '$(Build.ArtifactStagingDirectory)\TestEvidence'
      artifact: 'TestEvidence'
      publishLocation: 'pipeline'
```

### `azure-retest-pipeline.yml`

**Purpose:** Orchestrates dynamic Resolved-Bug discovery and selective defect retesting.

```yaml
trigger: none
pr: none

pool:
  name: 'Pool_A'

variables:
  azureOrg: 'smac567'
  azureProject: 'FSWEP_567'

  sprintCode: 'SP001'
  sprintName: 'Sprint 001'
  teamName: 'FSWEP_567 Team'

  userStoryCode: 'US001'
  userStoryTitle: 'US001: FSWEP_Login_User_Story'

  testPlanCode: 'TP001'
  testPlanName: 'TP001: FSWEP Login Test Plan'

  testSuiteCode: 'TS001'
  testSuiteName: 'TS001: FSWEP_Login_Test_Suite'

  # RT = Retest Run
  testRunCode: 'RT001'
  testRunName: 'FSWEP Login Automated Bug Retest'

  loginDataPath: 'src\test\resources\testdata\loginData-regression.json'
  retestDataResource: 'testdata/loginData-retest.json'

  bugCodePrefix: 'BG'

  surefireReportPath: 'target\surefire-reports'
  screenshotsPath: 'Screenshots'
  mavenLogRelativePath: 'TestEvidence\maven-test-output.log'

steps:

  # ---------------------------------------------------------
  # STEP 1
  # Discover Resolved Automation Bugs awaiting verification
  # ---------------------------------------------------------

  - task: PowerShell@2
    displayName: 'Find Resolved Automation Bugs'
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Find-Resolved-Automation-Bugs.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -BugCodePrefix "$(bugCodePrefix)"
        -TestPlanCode "$(testPlanCode)"
        -TestSuiteCode "$(testSuiteCode)"
    env:
      AZURE_PAT: $(AZURE_PAT)

  # ---------------------------------------------------------
  # Everything below this point runs only when at least one
  # Resolved Automation Bug requires retesting.
  # ---------------------------------------------------------

  - task: PowerShell@2
    displayName: 'Ensure Sprint Iteration Exists'
    condition: eq(variables['RETEST_REQUIRED'], 'true')
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Ensure-Iteration.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -TeamName "$(teamName)"
        -SprintName "$(sprintName)"
        -SprintCode "$(sprintCode)"
    env:
      AZURE_PAT: $(AZURE_PAT)

  - task: PowerShell@2
    displayName: 'Ensure Azure DevOps User Story Exists'
    condition: eq(variables['RETEST_REQUIRED'], 'true')
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Ensure-UserStory.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -UserStoryCode "$(userStoryCode)"
        -SprintCode "$(sprintCode)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      ITERATION_PATH: $(ITERATION_PATH)
      USER_STORY_TITLE: $(userStoryTitle)

  - task: PowerShell@2
    displayName: 'Ensure Azure DevOps Test Plan Exists'
    condition: eq(variables['RETEST_REQUIRED'], 'true')
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Ensure-TestPlan.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -TestPlanCode "$(testPlanCode)"
        -UserStoryCode "$(userStoryCode)"
        -SprintCode "$(sprintCode)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_PLAN_NAME: $(testPlanName)
      ITERATION_PATH: $(ITERATION_PATH)
      USER_STORY_ID: $(USER_STORY_ID)

  - task: PowerShell@2
    displayName: 'Ensure Azure DevOps Test Suite Exists'
    condition: eq(variables['RETEST_REQUIRED'], 'true')
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Ensure-TestSuite.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -TestPlanCode "$(testPlanCode)"
        -TestSuiteCode "$(testSuiteCode)"
        -UserStoryCode "$(userStoryCode)"
        -SprintCode "$(sprintCode)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_PLAN_ID: $(TEST_PLAN_ID)
      TEST_SUITE_NAME: $(testSuiteName)
      ITERATION_PATH: $(ITERATION_PATH)
      USER_STORY_ID: $(USER_STORY_ID)

  - task: PowerShell@2
    displayName: 'Ensure Azure DevOps Test Cases Exist'
    condition: eq(variables['RETEST_REQUIRED'], 'true')
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Ensure-TestCases.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -TestPlanCode "$(testPlanCode)"
        -TestSuiteCode "$(testSuiteCode)"
        -UserStoryCode "$(userStoryCode)"
        -SprintCode "$(sprintCode)"
        -LoginDataRelativePath "$(loginDataPath)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_PLAN_ID: $(TEST_PLAN_ID)
      TEST_SUITE_ID: $(TEST_SUITE_ID)
      USER_STORY_ID: $(USER_STORY_ID)
      ITERATION_PATH: $(ITERATION_PATH)

  # ---------------------------------------------------------
  # STEP 2
  # Create a Retest Run containing only the Test Cases that
  # belong to the Resolved Bugs discovered in Step 1.
  #
  # Example:
  # RETEST_TEST_CASE_IDS = TC006
  # ---------------------------------------------------------

  - task: PowerShell@2
    displayName: 'Create Azure DevOps Retest Run'
    condition: eq(variables['RETEST_REQUIRED'], 'true')
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Create-TestRun.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -TestRunCode "$(testRunCode)"
        -TestRunName "$(testRunName)"
        -TestPlanCode "$(testPlanCode)"
        -TestSuiteCode "$(testSuiteCode)"
        -UserStoryCode "$(userStoryCode)"
        -SprintCode "$(sprintCode)"
        -SelectedTestCaseIds "$(RETEST_TEST_CASE_IDS)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_PLAN_ID: $(TEST_PLAN_ID)
      TEST_SUITE_ID: $(TEST_SUITE_ID)
      ITERATION_PATH: $(ITERATION_PATH)

  # ---------------------------------------------------------
  # STEP 3
  # Clean screenshots from any previous execution
  # ---------------------------------------------------------

  - task: PowerShell@2
    displayName: 'Clean Previous Screenshots'
    condition: eq(variables['RETEST_REQUIRED'], 'true')
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Clean-Screenshots.ps1'
      arguments: >
        -ScreenshotsRelativePath "$(screenshotsPath)"

  # ---------------------------------------------------------
  # STEP 4
  # Execute ONLY the Test Cases selected from Resolved Bugs
  #
  # Example:
  # RETEST_TEST_CASE_IDS = TC006
  #
  # Maven receives:
  # -DtestCaseIds=TC006
  # ---------------------------------------------------------

  - powershell: |
      $artifactRoot = "$(Build.ArtifactStagingDirectory)\TestEvidence"

      New-Item `
        -ItemType Directory `
        -Force `
        -Path $artifactRoot |
      Out-Null

      Write-Host ""
      Write-Host "============================================================"
      Write-Host "RUNNING SELECTED BUG RETESTS"
      Write-Host "============================================================"
      Write-Host "Test Cases: $(RETEST_TEST_CASE_IDS)"
      Write-Host ""

      .\mvnw.cmd clean test -DskipTests=false "-DtestDataFile=$(retestDataResource)" "-DtestCaseIds=$(RETEST_TEST_CASE_IDS)" 2>&1 |
        Tee-Object `
          -FilePath "$artifactRoot\maven-test-output.log"

      $mavenExitCode = $LASTEXITCODE

      Write-Host ""
      Write-Host "Maven exit code: $mavenExitCode"

      exit $mavenExitCode

    displayName: 'Run Selected Selenium TestNG Retests'
    condition: eq(variables['RETEST_REQUIRED'], 'true')
    continueOnError: true

  # ---------------------------------------------------------
  # STEP 5
  # Map the selected Surefire result(s) back to the selected
  # Azure Test Result(s) and complete RT001.
  # ---------------------------------------------------------

  - task: PowerShell@2
    displayName: 'Update Azure DevOps Retest Results'
    condition: and(always(), eq(variables['RETEST_REQUIRED'], 'true'))
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Update-TestRunResults.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -SurefireRelativePath "$(surefireReportPath)"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_RUN_ID: $(TEST_RUN_ID)

  # ---------------------------------------------------------
  # STEP 6
  # Link each existing Resolved Bug to the exact Azure
  # Test Result produced by its retest.
  # ---------------------------------------------------------

  - task: PowerShell@2
    displayName: 'Link Bugs to Retest Results'
    condition: and(always(), eq(variables['RETEST_REQUIRED'], 'true'))
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Link-RetestBugsToTestResults.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
    env:
      AZURE_PAT: $(AZURE_PAT)

  # ---------------------------------------------------------
  # STEP 7
  # A failed verification means the defect is still present.
  #
  # Failed:
  # Resolved -> Active
  #
  # The script also adds traceability comments to both the
  # Bug and its related Test Case.
  # ---------------------------------------------------------

  - task: PowerShell@2
    displayName: 'Process Retest Bug Lifecycle'
    condition: and(always(), eq(variables['RETEST_REQUIRED'], 'true'))
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Process-RetestLifecycle.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
    env:
      AZURE_PAT: $(AZURE_PAT)

  # ---------------------------------------------------------
  # Add clickable execution traceability to:
  # Test Plan
  # Test Suite
  # executed Test Cases
  # Bugs involved in this retest
  # ---------------------------------------------------------

  - task: PowerShell@2
    displayName: 'Add Retest Execution Traceability'
    condition: and(always(), eq(variables['RETEST_REQUIRED'], 'true'))
    inputs:
      targetType: 'filePath'
      filePath: 'scripts/azure-devops/Add-ExecutionTraceability.ps1'
      arguments: >
        -Org "$(azureOrg)"
        -Project "$(azureProject)"
        -ExecutionType "Retest"
    env:
      AZURE_PAT: $(AZURE_PAT)
      TEST_PLAN_ID: $(TEST_PLAN_ID)
      TEST_SUITE_ID: $(TEST_SUITE_ID)
      TEST_RUN_ID: $(TEST_RUN_ID)

  # ---------------------------------------------------------
  # Always publish discovery / mapping evidence.
  # ---------------------------------------------------------

  - task: PublishPipelineArtifact@1
    displayName: 'Publish Retest Evidence'
    condition: always()
    inputs:
      targetPath: '$(Build.ArtifactStagingDirectory)\TestEvidence'
      artifact: 'RetestEvidence'
      publishLocation: 'pipeline'
```

## Java automation framework

### `src/test/java/FSWEP_LoginP/BaseTest.java`

**Purpose:** Creates and cleans up the Chrome WebDriver environment for each TestNG test method.

```java
package FSWEP_LoginP;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import java.time.Duration;

public class BaseTest {

    protected WebDriver driver;
    protected WebDriverWait wait;
    protected long startTime;

    @BeforeMethod
    public void setUp() {

        startTime = System.currentTimeMillis();

        System.setProperty("webdriver.chrome.silentOutput", "true");

        java.util.logging.Logger
                .getLogger("org.openqa.selenium")
                .setLevel(java.util.logging.Level.SEVERE);

        driver = new ChromeDriver();

        driver.manage().window().maximize();

        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    @AfterMethod
    public void tearDown() {

        if (driver != null) {
            driver.quit();
        }
    }

    public WebDriver getDriver() {
        return driver;
    }

    public long getStartTime() {
        return startTime;
    }
}
```

### `src/test/java/FSWEP_LoginP/LoggerUtility.java`

**Purpose:** Provides consistent logging and test execution summaries.

```java
package FSWEP_LoginP;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import static org.openqa.selenium.devtools.v120.animation.Animation.getCurrentTime;

public class LoggerUtility {

    private static int stepNumber = 1;

    public static void resetStepCounter() {
        stepNumber = 1;
    }

    private static String getCurrentTime() {

        DateTimeFormatter formatter =
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        return LocalDateTime.now().format(formatter);
    }

    private static final DateTimeFormatter formatter =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public static void logTestCase(
            String testCaseId,
            String testCase,
            String objective,
            String expected,
            String expectedMessage) {

        resetStepCounter();

        System.out.println("\n============================================================");
        System.out.println("TEST CASE ID     : " + testCaseId);
        System.out.println("TEST CASE        : " + testCase);
        System.out.println("OBJECTIVE        : " + objective);
        System.out.println("EXPECTED RESULT  : " + expected);

        if (!expectedMessage.isBlank()) {
            System.out.println("EXPECTED MESSAGE : " + expectedMessage);
        }

        System.out.println("STARTED          : " + getCurrentTime());
        System.out.println("============================================================");
    }

    public static void logStep(String stepDescription) {

        System.out.println();
        System.out.println("STEP " + stepNumber + " : " + stepDescription);
        System.out.println("----------------------------------------------");

        stepNumber++;
    }

    public static void logPass(String message) {

        System.out.println("[PASS] " + message);
    }

    public static void logFail(String message) {

        System.out.println("[FAIL] " + message);
    }

    public static void logInfo(String message) {

        System.out.println("[INFO] " + message);
    }

    public static void logTestComplete(String message) {

        System.out.println("[PASS] " + message);
        System.out.println();

    }

    public static void logSummary(
            String testCase,
            boolean passed,
            double durationSeconds) {

        System.out.println();
        System.out.println("============================================================");
        System.out.println("TEST EXECUTION SUMMARY");
        System.out.println("============================================================");

        System.out.println("RESULT            : "
                + (passed ? "PASS" : "FAIL"));

        System.out.println("TEST CASE         : " + testCase);

        System.out.printf("DURATION          : %.2f seconds%n",
                durationSeconds);

        System.out.println("FINISHED          : " + getCurrentTime());

        System.out.println("============================================================");
        System.out.println();
    }

    // Log executive summary test case duration
    public static void logExecutionSummary(
            String testCase,
            long startTime) {

        long endTime =
                System.currentTimeMillis();

        double durationSeconds =
                (endTime - startTime) / 1000.0;

        logSummary(
                testCase,
                true,
                durationSeconds);
    }

}
```

### `src/test/java/FSWEP_LoginP/LoginData.java`

**Purpose:** Represents one data-driven login Test Case and retains its stable TCxxx identifier.

```java
package FSWEP_LoginP;

public class LoginData {

    private String testCaseId;
    private String testCase;
    private String objective;
    private String username;
    private String password;
    private String expected;
    private String expectedMessage;

    public LoginData() {
    }

    public String getTestCaseId() {
        return testCaseId;
    }

    public void setTestCaseId(String testCaseId) {
        this.testCaseId = testCaseId;
    }

    public String getTestCase() {
        return testCase;
    }

    public void setTestCase(String testCase) {
        this.testCase = testCase;
    }

    public String getObjective() {
        return objective;
    }

    public void setObjective(String objective) {
        this.objective = objective;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getExpected() {
        return expected;
    }

    public void setExpected(String expected) {
        this.expected = expected;
    }

    public String getExpectedMessage() {
        return expectedMessage;
    }

    public void setExpectedMessage(String expectedMessage) {
        this.expectedMessage = expectedMessage;
    }

    @Override
    public String toString() {

        return testCaseId
                + " - "
                + testCase;
    }
}
```

### `src/test/java/FSWEP_LoginP/LoginDataProvider.java`

**Purpose:** Loads JSON test data and supports runtime data-file and Test Case ID filtering.

```java
package FSWEP_LoginP;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.testng.annotations.DataProvider;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class LoginDataProvider {

    @DataProvider(name = "loginData")
    public Object[][] getLoginData() throws Exception {

        ObjectMapper mapper =
                new ObjectMapper();

        // -------------------------------------------------
        // Select the JSON data source.
        //
        // Default:
        // testdata/loginData-regression.json
        //
        // Retest pipeline can override this with:
        // -DtestDataFile=testdata/loginData-retest.json
        // -------------------------------------------------

        String testDataFile =
                System.getProperty(
                        "testDataFile",
                        "testdata/loginData-regression.json");

        InputStream input =
                getClass()
                        .getClassLoader()
                        .getResourceAsStream(testDataFile);

        if (input == null) {

            throw new IllegalArgumentException(
                    "Test data file was not found: "
                            + testDataFile);
        }

        List<LoginData> allData =
                Arrays.asList(
                        mapper.readValue(
                                input,
                                LoginData[].class));

        // -------------------------------------------------
        // Optional Test Case filter.
        //
        // Full regression:
        // no testCaseIds property
        // → run every row in the selected JSON file.
        //
        // Retest:
        // -DtestCaseIds=TC006
        //
        // Multiple:
        // -DtestCaseIds=TC006,TC007
        // -------------------------------------------------

        String testCaseIds =
                System.getProperty(
                        "testCaseIds",
                        "");

        List<LoginData> selectedData =
                new ArrayList<>();

        if (testCaseIds.isBlank()) {

            selectedData.addAll(allData);
        }
        else {

            List<String> requestedIds =
                    Arrays.asList(
                            testCaseIds.split(","));

            for (LoginData data : allData) {

                boolean selected =
                        requestedIds.stream()
                                .map(String::trim)
                                .anyMatch(
                                        id ->
                                                id.equalsIgnoreCase(
                                                        data.getTestCaseId()));

                if (selected) {
                    selectedData.add(data);
                }
            }
        }

        if (selectedData.isEmpty()) {

            throw new IllegalArgumentException(
                    "No Test Cases matched testCaseIds='"
                            + testCaseIds
                            + "' in "
                            + testDataFile);
        }

        System.out.println();
        System.out.println(
                "Test data file: "
                        + testDataFile);

        System.out.println(
                "Test Cases selected for execution: "
                        + selectedData.size());

        for (LoginData data : selectedData) {

            System.out.println(
                    "  "
                            + data.getTestCaseId()
                            + " - "
                            + data.getTestCase());
        }

        Object[][] result =
                new Object[selectedData.size()][1];

        for (int i = 0; i < selectedData.size(); i++) {

            result[i][0] =
                    selectedData.get(i);
        }

        return result;
    }
}
```

### `src/test/java/FSWEP_LoginP/LoginPage.java`

**Purpose:** Encapsulates Selenium interactions with the FSWEP login page.

```java
package FSWEP_LoginP;

import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class LoginPage {

    private static final String LOGIN_URL =
            "https://emploisfp-psjobs.cfp-psc.gc.ca/psrs-srfp/applicant/page1710";

    private static final String LOGIN_PAGE_TITLE =
            "Login to your account";

    private WebDriver driver;
    private WebDriverWait wait;

    public void open() {

        driver.get(LOGIN_URL);

        wait.until(
                ExpectedConditions.titleIs(
                        LOGIN_PAGE_TITLE));
    }

    public String getPageTitle() {

        return driver.getTitle();
    }



    private By usernameField =
            By.id("UserNumber");

    private By passwordField =
            By.id("Password");

    private By loginButton =
            By.name("LOGIN");

    private static final By INVALID_LOGIN_ERROR =
            By.cssSelector("strong.mandatory");

    private static final By REQUIRED_FIELDS_ERROR =
            By.cssSelector("p.mandatory");



    public LoginPage(WebDriver driver, WebDriverWait wait) {

        this.driver = driver;
        this.wait = wait;
    }


    public void enterUsername(String username) {

        WebElement usernameElement =
                wait.until(
                        ExpectedConditions.visibilityOfElementLocated(
                                usernameField));

        usernameElement.sendKeys(username);
    }


    public void enterPassword(String password) {

        WebElement passwordElement =
                wait.until(
                        ExpectedConditions.visibilityOfElementLocated(
                                passwordField));

        passwordElement.sendKeys(password);
    }


    public void clickLogin() {

        WebElement loginElement =
                wait.until(
                        ExpectedConditions.elementToBeClickable(
                                loginButton));

        loginElement.click();
    }


    public boolean isSuccessfulLogin() {

        return driver.getTitle().equals("My jobs menu")
                || driver.getTitle().equals("Enter access code");
    }


    public boolean hasLoginError() {

        return !driver.findElements(INVALID_LOGIN_ERROR).isEmpty()
                || !driver.findElements(REQUIRED_FIELDS_ERROR).isEmpty();
    }


    public String getDisplayedErrorMessage() {

        List<WebElement> invalidLogin =
                driver.findElements(INVALID_LOGIN_ERROR);

        if (!invalidLogin.isEmpty()) {

            return invalidLogin.get(0)
                    .getText()
                    .trim();
        }

        List<WebElement> requiredFields =
                driver.findElements(REQUIRED_FIELDS_ERROR);

        if (!requiredFields.isEmpty()) {

            return requiredFields.get(0)
                    .getText()
                    .trim();
        }

        return "";
    }


    public LoginResult getLoginResult() {

        wait.until(ExpectedConditions.or(

                ExpectedConditions.titleIs("My jobs menu"),

                ExpectedConditions.titleIs("Enter access code"),

                ExpectedConditions.visibilityOfElementLocated(
                        INVALID_LOGIN_ERROR),

                ExpectedConditions.visibilityOfElementLocated(
                        REQUIRED_FIELDS_ERROR)
        ));

        String pageTitle = driver.getTitle();

        if (pageTitle.equals("My jobs menu")
                || pageTitle.equals("Enter access code")) {

            return new LoginResult(
                    "SUCCESS",
                    "");
        }

        String actualMessage =
                getDisplayedErrorMessage();

        return new LoginResult(
                "FAIL",
                actualMessage);
    }
}
```

### `src/test/java/FSWEP_LoginP/LoginResult.java`

**Purpose:** Stores the actual result and message returned by the application.

```java
package FSWEP_LoginP;

public class LoginResult {

    private final String actualResult;
    private final String actualMessage;

    public LoginResult(String actualResult, String actualMessage) {
        this.actualResult = actualResult;
        this.actualMessage = actualMessage;
    }

    public String getActualResult() {
        return actualResult;
    }

    public String getActualMessage() {
        return actualMessage;
    }


}
```

### `src/test/java/FSWEP_LoginP/LoginValidator.java`

**Purpose:** Performs TestNG assertions comparing expected and actual application behavior.

```java
package FSWEP_LoginP;

import org.testng.Assert;

public class LoginValidator {

    public static void validate(
            LoginData data,
            LoginResult result) {

        LoggerUtility.logStep(
                "Comparing Expected and Actual Results");

        LoggerUtility.logInfo(
                "EXPECTED RESULT: "
                        + data.getExpected());

        LoggerUtility.logInfo(
                "ACTUAL RESULT: "
                        + result.getActualResult());

        if (result.getActualResult()
                .equals(data.getExpected())) {

            LoggerUtility.logPass(
                    "✓ Result matches expected value.");
        }

        Assert.assertEquals(
                result.getActualResult(),
                data.getExpected(),
                "Incorrect login result for "
                        + data.getTestCaseId()
                        + " - "
                        + data.getTestCase());

        if ("FAIL".equals(data.getExpected())) {

            LoggerUtility.logInfo(
                    "EXPECTED MESSAGE: "
                            + data.getExpectedMessage());

            LoggerUtility.logInfo(
                    "ACTUAL MESSAGE: "
                            + result.getActualMessage());

            if (result.getActualMessage()
                    .equals(data.getExpectedMessage())) {

                LoggerUtility.logPass(
                        "✓ Message matches expected value.");
            }

            Assert.assertEquals(
                    result.getActualMessage(),
                    data.getExpectedMessage(),
                    "Incorrect error message for "
                            + data.getTestCaseId()
                            + " - "
                            + data.getTestCase());
        }
    }
}
```

### `src/test/java/FSWEP_LoginP/ScreenshotUtility.java`

**Purpose:** Captures failure screenshots beneath the Screenshots directory.

```java
package FSWEP_LoginP;

import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import java.nio.file.Path;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class ScreenshotUtility {

    public static void captureScreenshot(
            WebDriver driver,
            String testCaseName) {

        try {

            Files.createDirectories(Path.of("Screenshots"));

            File source =
                    ((TakesScreenshot) driver)
                            .getScreenshotAs(OutputType.FILE);

            String timestamp =
                    LocalDateTime.now()
                            .format(DateTimeFormatter.ofPattern(
                                    "yyyy-MM-dd_HH-mm-ss"));

            File destination =
                    new File("Screenshots/"
                            + testCaseName.replace(" ", "_")
                            + "_"
                            + timestamp
                            + ".png");

            Files.copy(source.toPath(), destination.toPath());

            LoggerUtility.logInfo(
                    "Screenshot saved to: "
                            + destination.getAbsolutePath());

        } catch (IOException e) {

            LoggerUtility.logFail(
                    "Unable to save screenshot.");

            e.printStackTrace();
        }

    }
}
```

### `src/test/java/FSWEP_LoginP/SeleniumLoginDataDrivenTest.java`

**Purpose:** Coordinates the high-level data-driven Selenium login test workflow.

```java
package FSWEP_LoginP;

import org.testng.Reporter;
import org.testng.annotations.Listeners;
import org.testng.annotations.Test;

@Listeners(TestListener.class)
public class SeleniumLoginDataDrivenTest extends BaseTest {

    private static final String LOGIN_URL =
            "https://emploisfp-psjobs.cfp-psc.gc.ca/psrs-srfp/applicant/page1710";

    @Test(
            dataProvider = "loginData",
            dataProviderClass = LoginDataProvider.class
    )
    public void testLogin(LoginData data) {

        LoggerUtility.logTestCase(
                data.getTestCaseId(),
                data.getTestCase(),
                data.getObjective(),
                data.getExpected(),
                data.getExpectedMessage());

        Reporter.getCurrentTestResult()
                .getTestContext()
                .setAttribute("testCaseName", data.getTestCase());

        Reporter.getCurrentTestResult()
                .getTestContext()
                .setAttribute("testCaseId", data.getTestCaseId());

        // Create the LoginPage object
        LoginPage loginPage =
                new LoginPage(driver, wait);

        // Open login page
        LoggerUtility.logStep("Opening login page.");

        loginPage.open();

        LoggerUtility.logPass(
                "✓ Successfully navigated to the login page.");

        LoggerUtility.logPass(
                "Page Title: " + loginPage.getPageTitle());

        // Enter username
        LoggerUtility.logStep("Entering username.");

        loginPage.enterUsername(data.getUsername());

        LoggerUtility.logPass("Username entered.");

        // Enter password
        LoggerUtility.logStep("Entering password.");

        loginPage.enterPassword(data.getPassword());

        LoggerUtility.logPass("Password entered.");

        // Click Login button
        LoggerUtility.logStep("Click Login Button");

        loginPage.clickLogin();

        LoggerUtility.logPass("Login button clicked.");

        // Get the actual login result
        LoginResult result =
                loginPage.getLoginResult();

        // Validate expected and actual results
        LoginValidator.validate(data, result);

        // Execution summary
        LoggerUtility.logExecutionSummary(
                data.getTestCase(),
                getStartTime());

    } // testLogin() ends here


} // class ends here
```

### `src/test/java/FSWEP_LoginP/TestListener.java`

**Purpose:** Responds to TestNG success/failure events and captures evidence when tests fail.

```java
package FSWEP_LoginP;

import org.testng.ITestListener;
import org.testng.ITestResult;

public class TestListener implements ITestListener {

    @Override
    public void onTestSuccess(ITestResult result) {

        String testCaseId =
                (String) result.getTestContext()
                        .getAttribute("testCaseId");

        String testCaseName =
                (String) result.getTestContext()
                        .getAttribute("testCaseName");

        LoggerUtility.logPass(
                "TEST CASE PASSED: "
                        + testCaseId
                        + " - "
                        + testCaseName);

        System.out.println();
    }

    @Override
    public void onTestFailure(ITestResult result) {

        String testCaseId =
                (String) result.getTestContext()
                        .getAttribute("testCaseId");

        String testCaseName =
                (String) result.getTestContext()
                        .getAttribute("testCaseName");

        LoggerUtility.logFail(
                "TEST CASE FAILED: "
                        + testCaseId
                        + " - "
                        + testCaseName);

        BaseTest testInstance =
                (BaseTest) result.getInstance();

        ScreenshotUtility.captureScreenshot(
                testInstance.getDriver(),
                testCaseId + " - " + testCaseName);

        System.out.println();
    }
}
```

## JSON test data

### `src/test/resources/testdata/loginData-regression.json`

**Purpose:** Canonical Test Case definitions and full-regression execution data. Credentials are replaced with publication placeholders.

```json
[
  {
    "testCaseId": "TC001",
    "testCase": "Valid FSWEP Login",
    "objective": "Verify that the application allows a successful login when the username and password are valid",
    "username": "YOUR_TEST_USERNAME",
    "password": "YOUR_VALID_TEST_PASSWORD",
    "expected": "SUCCESS",
    "expectedMessage": ""
  },
  {
    "testCaseId": "TC002",
    "testCase": "Invalid Password",
    "objective": "Verify that the application prevents login and displays the correct error message when the password is invalid.",
    "username": "YOUR_TEST_USERNAME",
    "password": "YOUR_INVALID_TEST_PASSWORD",
    "expected": "FAIL",
    "expectedMessage": "Error 1: The e-mail address and password combination is invalid."
  },
  {
    "testCaseId": "TC003",
    "testCase": "Blank Username",
    "objective": "Verify that the application prevents login when the username field is blank.",
    "username": "",
    "password": "YOUR_VALID_TEST_PASSWORD",
    "expected": "FAIL",
    "expectedMessage": "Required fields are marked with an asterisk (*)."
  },
  {
    "testCaseId": "TC004",
    "testCase": "Blank Password",
    "username": "YOUR_TEST_USERNAME",
    "objective": "Verify that the application prevents login when the password field is blank.",
    "password": "",
    "expected": "FAIL",
    "expectedMessage": "Required fields are marked with an asterisk (*)."
  },
  {
    "testCaseId": "TC005",
    "testCase": "Blank Username and Password",
    "objective": "Verify that the application prevents login when the username and password field are blank.",
    "username": "",
    "password": "",
    "expected": "FAIL",
    "expectedMessage": "Required fields are marked with an asterisk (*)."
  },
  {
    "testCaseId": "TC006",
    "testCase": "Invalid Password Error Message",
    "objective": "Verify that the automation framework detects a failure when the actual invalid-password error message does not match the expected error message.",
    "username": "YOUR_TEST_USERNAME",
    "password": "YOUR_INVALID_TEST_PASSWORD",
    "expected": "FAIL",
    "expectedMessage": "INTENTIONAL FAILURE: This expected error message is deliberately incorrect."
  },
  {
    "testCaseId": "TC007",
    "testCase": "Blank Password Error Message",
    "objective": "Verify that the automation framework detects a failure when the actual blank-password validation message does not match the expected error message.",
    "username": "YOUR_TEST_USERNAME",
    "password": "",
    "expected": "FAIL",
    "expectedMessage": "INTENTIONAL FAILURE: This expected blank-password validation message is deliberately incorrect."
  }
]
```

### `src/test/resources/testdata/loginData-retest.json`

**Purpose:** Training-only retest fixture used to simulate one successful and one unsuccessful developer fix. Credentials are replaced with publication placeholders.

```json
[
  {
    "testCaseId": "TC001",
    "testCase": "Valid FSWEP Login",
    "objective": "Verify that the application allows a successful login when the username and password are valid",
    "username": "YOUR_TEST_USERNAME",
    "password": "YOUR_VALID_TEST_PASSWORD",
    "expected": "SUCCESS",
    "expectedMessage": ""
  },
  {
    "testCaseId": "TC002",
    "testCase": "Invalid Password",
    "objective": "Verify that the application prevents login and displays the correct error message when the password is invalid.",
    "username": "YOUR_TEST_USERNAME",
    "password": "YOUR_INVALID_TEST_PASSWORD",
    "expected": "FAIL",
    "expectedMessage": "Error 1: The e-mail address and password combination is invalid."
  },
  {
    "testCaseId": "TC003",
    "testCase": "Blank Username",
    "objective": "Verify that the application prevents login when the username field is blank.",
    "username": "",
    "password": "YOUR_VALID_TEST_PASSWORD",
    "expected": "FAIL",
    "expectedMessage": "Required fields are marked with an asterisk (*)."
  },
  {
    "testCaseId": "TC004",
    "testCase": "Blank Password",
    "username": "YOUR_TEST_USERNAME",
    "objective": "Verify that the application prevents login when the password field is blank.",
    "password": "",
    "expected": "FAIL",
    "expectedMessage": "Required fields are marked with an asterisk (*)."
  },
  {
    "testCaseId": "TC005",
    "testCase": "Blank Username and Password",
    "objective": "Verify that the application prevents login when the username and password field are blank.",
    "username": "",
    "password": "",
    "expected": "FAIL",
    "expectedMessage": "Required fields are marked with an asterisk (*)."
  },
  {
    "testCaseId": "TC006",
    "testCase": "Invalid Password Error Message",
    "objective": "Verify that the automation framework detects a failure when the actual invalid-password error message does not match the expected error message.",
    "username": "YOUR_TEST_USERNAME",
    "password": "YOUR_INVALID_TEST_PASSWORD",
    "expected": "FAIL",
    "expectedMessage": "Error 1: The e-mail address and password combination is invalid."
  },
  {
    "testCaseId": "TC007",
    "testCase": "Blank Password Error Message",
    "objective": "Verify that the automation framework detects a failure when the actual blank-password validation message does not match the expected error message.",
    "username": "YOUR_TEST_USERNAME",
    "password": "",
    "expected": "FAIL",
    "expectedMessage": "INTENTIONAL FAILURE: This expected blank-password validation message is deliberately incorrect."
  }
]
```

## Azure DevOps PowerShell integration

### `scripts/azure-devops/Add-ExecutionTraceability.ps1`

**Purpose:** Adds exact Azure Test Run and pipeline-build hyperlinks to participating work items and records evidence.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [ValidateSet("Regression", "Retest")]
    [string]$ExecutionType
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Environment validation
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if (
    $token -eq '$(AZURE_PAT)' -or
    $token -match '^\$\([^)]+\)$'
) {
    throw "AZURE_PAT was not expanded."
}

if ([string]::IsNullOrWhiteSpace($env:TEST_PLAN_ID)) {
    throw "TEST_PLAN_ID is empty."
}

if ([string]::IsNullOrWhiteSpace($env:TEST_SUITE_ID)) {
    throw "TEST_SUITE_ID is empty."
}

if ([string]::IsNullOrWhiteSpace($env:TEST_RUN_ID)) {
    throw "TEST_RUN_ID is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_BUILDID)) {
    throw "BUILD_BUILDID is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_BUILDNUMBER)) {
    throw "BUILD_BUILDNUMBER is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

# ---------------------------------------------------------
# Authentication
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$jsonHeaders = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

$patchHeaders = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json-patch+json"
}

$testPlanId =
    [int]$env:TEST_PLAN_ID

$testSuiteId =
    [int]$env:TEST_SUITE_ID

$testRunId =
    [int]$env:TEST_RUN_ID

$buildId =
    [int]$env:BUILD_BUILDID

$buildNumber =
    [string]$env:BUILD_BUILDNUMBER

# ---------------------------------------------------------
# Evidence files
# ---------------------------------------------------------

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

$testResultMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-result-map.json"

if ($ExecutionType -eq "Regression") {

    $bugMapPath =
        Join-Path `
            $artifactRoot `
            "azure-bug-map.json"
}
else {

    $bugMapPath =
        Join-Path `
            $artifactRoot `
            "azure-retest-queue-map.json"
}

$traceabilityMapPath =
    Join-Path `
        $artifactRoot `
        "azure-execution-traceability-map.json"

if (-not (Test-Path $testResultMapPath)) {
    throw "Test Result mapping was not found: $testResultMapPath"
}

# ---------------------------------------------------------
# Retrieve clickable Test Run URL
# ---------------------------------------------------------

$testRunUri =
    "https://dev.azure.com/$Org/$Project/_apis/test/runs/${testRunId}?api-version=7.1"

$testRun =
    Invoke-RestMethod `
        -Uri $testRunUri `
        -Method Get `
        -Headers $jsonHeaders

$webAccessProperty =
    $testRun.PSObject.Properties["webAccessUrl"]

if (
    $null -eq $webAccessProperty -or
    [string]::IsNullOrWhiteSpace([string]$webAccessProperty.Value)
) {
    throw "Azure DevOps did not return webAccessUrl for Test Run $testRunId."
}

$testRunWebUrl =
    [string]$webAccessProperty.Value

# ---------------------------------------------------------
# Retrieve Build and its clickable web URL
# ---------------------------------------------------------

$buildUri =
    "https://dev.azure.com/$Org/$Project/_apis/build/builds/${buildId}?api-version=7.1"

$build =
    Invoke-RestMethod `
        -Uri $buildUri `
        -Method Get `
        -Headers $jsonHeaders

$buildWebUrl =
    $null

$linksProperty =
    $build.PSObject.Properties["_links"]

if ($null -ne $linksProperty) {

    $webProperty =
        $linksProperty.Value.PSObject.Properties["web"]

    if ($null -ne $webProperty) {

        $hrefProperty =
            $webProperty.Value.PSObject.Properties["href"]

        if ($null -ne $hrefProperty) {

            $buildWebUrl =
                [string]$hrefProperty.Value
        }
    }
}

# Fallback if the Build response does not expose _links.web.
if ([string]::IsNullOrWhiteSpace($buildWebUrl)) {

    $buildWebUrl =
        "https://dev.azure.com/$Org/$Project/_build/results?buildId=$buildId"
}

Write-Host ""
Write-Host "============================================================"
Write-Host "EXECUTION TRACEABILITY"
Write-Host "============================================================"
Write-Host "Execution Type : $ExecutionType"
Write-Host "Test Run ID    : $testRunId"
Write-Host "Build Number   : $buildNumber"
Write-Host "Build ID       : $buildId"
Write-Host "Test Run URL   : $testRunWebUrl"
Write-Host "Build URL      : $buildWebUrl"
Write-Host ""

# ---------------------------------------------------------
# Build target list
# ---------------------------------------------------------

$targets =
    @()

$targets +=
    [PSCustomObject]@{
        workItemId =
            $testPlanId

        label =
            "Test Plan"
    }

$targets +=
    [PSCustomObject]@{
        workItemId =
            $testSuiteId

        label =
            "Test Suite"
    }

# ---------------------------------------------------------
# Add every Test Case actually executed in this Test Run.
#
# This includes both Passed and Failed Test Cases.
# ---------------------------------------------------------

$testResultMap =
    Get-Content `
        -Path $testResultMapPath `
        -Raw |
    ConvertFrom-Json

$testResultMap =
    @($testResultMap)

$executedTestCases =
    @(
        $testResultMap |
            Sort-Object azureTestCaseId -Unique
    )

foreach ($testResult in $executedTestCases) {

    $targets +=
        [PSCustomObject]@{
            workItemId =
                [int]$testResult.azureTestCaseId

            label =
                [string]$testResult.testCaseId
        }
}

# ---------------------------------------------------------
# Add Bugs involved in this execution.
# ---------------------------------------------------------

if (Test-Path $bugMapPath) {

    $bugMap =
        Get-Content `
            -Path $bugMapPath `
            -Raw |
        ConvertFrom-Json

    $bugMap =
        @($bugMap)

    foreach ($bug in $bugMap) {

        $bugIdProperty =
            $bug.PSObject.Properties["azureBugId"]

        if ($null -eq $bugIdProperty) {
            continue
        }

        $bugCode =
            "Bug"

        $bugCodeProperty =
            $bug.PSObject.Properties["bugCode"]

        if ($null -ne $bugCodeProperty) {

            $bugCode =
                [string]$bugCodeProperty.Value
        }

        $targets +=
            [PSCustomObject]@{
                workItemId =
                    [int]$bugIdProperty.Value

                label =
                    $bugCode
            }
    }
}

# ---------------------------------------------------------
# Remove duplicate target Work Item IDs
# ---------------------------------------------------------

$targets =
    @(
        $targets |
            Sort-Object workItemId -Unique
    )

# ---------------------------------------------------------
# Helper:
# Add a hyperlink only if that exact URL does not already
# exist on the Work Item.
# ---------------------------------------------------------

function Add-TraceabilityHyperlink {

    param (
        [Parameter(Mandatory = $true)]
        [int]$WorkItemId,

        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter(Mandatory = $true)]
        [string]$Comment
    )

    $workItemUri =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/${WorkItemId}?`$expand=Relations&api-version=7.1"

    $workItem =
        Invoke-RestMethod `
            -Uri $workItemUri `
            -Method Get `
            -Headers $jsonHeaders

    $relations =
        @()

    $relationsProperty =
        $workItem.PSObject.Properties["relations"]

    if ($null -ne $relationsProperty) {

        $relations =
            @($relationsProperty.Value)
    }

    $existing =
        @(
            $relations |
                Where-Object {
                    $_.rel -eq "Hyperlink" -and
                    [string]$_.url -eq $Url
                }
        )

    if ($existing.Count -gt 0) {

        Write-Host "Link already exists on Work Item $WorkItemId."
        return $false
    }

    $operations =
        @(
            @{
                op =
                    "add"

                path =
                    "/relations/-"

                value =
                    @{
                        rel =
                            "Hyperlink"

                        url =
                            $Url

                        attributes =
                            @{
                                comment =
                                    $Comment
                            }
                    }
            }
        )

    $body =
        ConvertTo-Json `
            -InputObject $operations `
            -Depth 20

    Invoke-RestMethod `
        -Uri $workItemUri `
        -Method Patch `
        -Headers $patchHeaders `
        -Body $body |
    Out-Null

    return $true
}

# ---------------------------------------------------------
# Add Test Run + Build links to each target Work Item
# ---------------------------------------------------------

$traceabilityMap =
    @()

foreach ($target in $targets) {

    $workItemId =
        [int]$target.workItemId

    $label =
        [string]$target.label

    Write-Host "------------------------------------------------------------"
    Write-Host "$label - Work Item $workItemId"

    $runLinkAdded =
        Add-TraceabilityHyperlink `
            -WorkItemId $workItemId `
            -Url $testRunWebUrl `
            -Comment "Automated $ExecutionType Test Run $testRunId - Build $buildNumber."

    $buildLinkAdded =
        Add-TraceabilityHyperlink `
            -WorkItemId $workItemId `
            -Url $buildWebUrl `
            -Comment "Azure Pipeline Build $buildNumber - Build ID $buildId."

    $traceabilityMap +=
        [PSCustomObject]@{
            workItemId =
                $workItemId

            label =
                $label

            executionType =
                $ExecutionType

            testRunId =
                $testRunId

            testRunUrl =
                $testRunWebUrl

            buildNumber =
                $buildNumber

            buildId =
                $buildId

            buildUrl =
                $buildWebUrl

            testRunLinkAdded =
                [bool]$runLinkAdded

            buildLinkAdded =
                [bool]$buildLinkAdded
        }

    Write-Host "Test Run link added : $runLinkAdded"
    Write-Host "Build link added    : $buildLinkAdded"
}

# ---------------------------------------------------------
# Save evidence
# ---------------------------------------------------------

ConvertTo-Json `
    -InputObject @($traceabilityMap) `
    -Depth 20 |
Set-Content `
    -Path $traceabilityMapPath `
    -Encoding UTF8

Write-Host ""
Write-Host "============================================================"
Write-Host "EXECUTION TRACEABILITY COMPLETE"
Write-Host "============================================================"
Write-Host "Work Items linked : $($targets.Count)"
Write-Host "Evidence Map      : $traceabilityMapPath"
Write-Host "============================================================"
```

### `scripts/azure-devops/Attach-BugScreenshot.ps1`

**Purpose:** Attaches the matching failure screenshot to each automation Bug.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$ScreenshotsRelativePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$token =
    $env:AZURE_PAT

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_SOURCESDIRECTORY)) {
    throw "BUILD_SOURCESDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_BUILDNUMBER)) {
    throw "BUILD_BUILDNUMBER is empty."
}

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$authHeaders = @{
    Authorization =
        "Basic $base64AuthInfo"
}

$patchHeaders = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json-patch+json"
}

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

$bugMapPath =
    Join-Path `
        $artifactRoot `
        "azure-bug-map.json"

if (-not (Test-Path $bugMapPath)) {
    throw "Bug mapping was not found: $bugMapPath"
}

$parsedBugMap =
    Get-Content `
        -Path $bugMapPath `
        -Raw |
    ConvertFrom-Json

$bugMaps =
    @($parsedBugMap)

if ($bugMaps.Count -eq 0) {

    Write-Host ""
    Write-Host "No Bug mappings exist."
    Write-Host "No Bug screenshots are required."

    return
}

$screenshotsPath =
    Join-Path `
        $env:BUILD_SOURCESDIRECTORY `
        $ScreenshotsRelativePath

if (-not (Test-Path $screenshotsPath)) {
    throw "Screenshots directory was not found: $screenshotsPath"
}

$attachmentMaps =
    @()

Write-Host ""
Write-Host "============================================================"
Write-Host "ATTACHING FAILURE SCREENSHOTS TO BUGS"
Write-Host "============================================================"
Write-Host "Bugs to process: $($bugMaps.Count)"

foreach ($bugMap in $bugMaps) {

    $bugId =
        [int]$bugMap.bugId

    $bugCode =
        [string]$bugMap.bugCode

    $testCaseId =
        [string]$bugMap.testCaseId

    Write-Host ""
    Write-Host "------------------------------------------------------------"
    Write-Host "PROCESSING BUG SCREENSHOT"
    Write-Host "------------------------------------------------------------"
    Write-Host "Bug       : $bugCode ($bugId)"
    Write-Host "Test Case : $testCaseId"

    $matchingScreenshots =
        @(
            Get-ChildItem `
                -Path $screenshotsPath `
                -Filter "*$testCaseId*.png" `
                -File |
            Sort-Object `
                -Property LastWriteTime `
                -Descending
        )

    if ($matchingScreenshots.Count -eq 0) {

        throw "No screenshot was found for failed Test Case $testCaseId."
    }

    $screenshot =
        $matchingScreenshots[0]

    if ($matchingScreenshots.Count -gt 1) {

        Write-Host "Multiple screenshots found."
        Write-Host "Using the newest screenshot."
    }

    Write-Host "Screenshot: $($screenshot.FullName)"

    $attachmentFileName =
        "${bugCode}_${testCaseId}_Build_$env:BUILD_BUILDNUMBER.png"

    $encodedFileName =
        [System.Uri]::EscapeDataString(
            $attachmentFileName
        )

    # -----------------------------------------------------
    # First upload the binary file into Azure DevOps WIT
    # attachment storage.
    # -----------------------------------------------------

    $uploadUri =
        "https://dev.azure.com/$Org/$Project/_apis/wit/attachments?fileName=${encodedFileName}&api-version=7.1"

    $attachmentResponse =
        Invoke-RestMethod `
            -Uri $uploadUri `
            -Method Post `
            -Headers $authHeaders `
            -ContentType "application/octet-stream" `
            -InFile $screenshot.FullName

    if ([string]::IsNullOrWhiteSpace([string]$attachmentResponse.url)) {
        throw "Azure DevOps did not return an attachment URL for $testCaseId."
    }

    $attachmentId =
        [string]$attachmentResponse.id

    $attachmentUrl =
        [string]$attachmentResponse.url

    # -----------------------------------------------------
    # Then add that uploaded file as an AttachedFile
    # relation on the specific Bug.
    # -----------------------------------------------------

    $bugUri =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/${bugId}?api-version=7.1"

    $attachmentOperations =
        @(
            @{
                op =
                    "add"

                path =
                    "/relations/-"

                value =
                    @{
                        rel =
                            "AttachedFile"

                        url =
                            $attachmentUrl

                        attributes =
                            @{
                                comment =
                                    "Failure screenshot for $testCaseId from build $env:BUILD_BUILDNUMBER."
                            }
                    }
            }
        )

    $attachmentBody =
        ConvertTo-Json `
            -InputObject $attachmentOperations `
            -Depth 20

    Invoke-RestMethod `
        -Uri $bugUri `
        -Method Patch `
        -Headers $patchHeaders `
        -Body $attachmentBody |
    Out-Null

    Write-Host "Screenshot successfully attached to $bugCode."

    $attachmentMaps +=
        [PSCustomObject]@{
            bugCode =
                $bugCode

            bugId =
                $bugId

            testCaseId =
                $testCaseId

            attachmentId =
                $attachmentId

            fileName =
                $attachmentFileName

            sourceScreenshot =
                $screenshot.FullName
        }
}

$attachmentMapPath =
    Join-Path `
        $artifactRoot `
        "azure-bug-attachment-map.json"

ConvertTo-Json `
    -InputObject @($attachmentMaps) `
    -Depth 20 |
Set-Content `
    -Path $attachmentMapPath `
    -Encoding UTF8

Write-Host ""
Write-Host "============================================================"
Write-Host "BUG SCREENSHOTS ATTACHED"
Write-Host "============================================================"

foreach ($attachment in $attachmentMaps) {

    Write-Host "$($attachment.testCaseId) -> $($attachment.bugCode) -> $($attachment.fileName)"
}

Write-Host "============================================================"
```

### `scripts/azure-devops/Attach-TestResultScreenshot.ps1`

**Purpose:** Attaches the matching Selenium failure screenshot to the exact Azure Test Result.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$ScreenshotsRelativePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Retrieve required pipeline values
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_SOURCESDIRECTORY)) {
    throw "BUILD_SOURCESDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_BUILDNUMBER)) {
    throw "BUILD_BUILDNUMBER is empty."
}

# ---------------------------------------------------------
# Authentication
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

Write-Host ""
Write-Host "============================================================"
Write-Host "ATTACHING SCREENSHOTS TO FAILED TEST RESULTS"
Write-Host "============================================================"
Write-Host "Organization : $Org"
Write-Host "Project      : $Project"
Write-Host ""

# ---------------------------------------------------------
# Locate Test Result mapping
# ---------------------------------------------------------

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

$testResultMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-result-map.json"

if (-not (Test-Path $testResultMapPath)) {
    throw "Test Result mapping file was not found: $testResultMapPath"
}

$testResultMap =
    Get-Content `
        -Path $testResultMapPath `
        -Raw |
    ConvertFrom-Json

$testResultMap =
    @($testResultMap)

if ($testResultMap.Count -eq 0) {
    throw "No Test Result mappings were found."
}

# ---------------------------------------------------------
# Discover all failed automated Test Results
# ---------------------------------------------------------

$failedResults =
    @(
        $testResultMap |
            Where-Object {
                $_.outcome -eq "Failed"
            }
    )

Write-Host "Total Test Results : $($testResultMap.Count)"
Write-Host "Failed Results     : $($failedResults.Count)"
Write-Host ""

# ---------------------------------------------------------
# No failures means there is no screenshot evidence to add.
# ---------------------------------------------------------

if ($failedResults.Count -eq 0) {

    Write-Host "No failed automated Test Results were found."
    Write-Host "No screenshot attachments are required."

    Write-Host ""
    Write-Host "============================================================"
    Write-Host "FAILED TEST SCREENSHOT ATTACHMENT SKIPPED"
    Write-Host "============================================================"

    return
}

# ---------------------------------------------------------
# Locate Screenshots directory
# ---------------------------------------------------------

$screenshotsPath =
    Join-Path `
        $env:BUILD_SOURCESDIRECTORY `
        $ScreenshotsRelativePath

if (-not (Test-Path $screenshotsPath)) {
    throw "Screenshots directory was not found: $screenshotsPath"
}

# ---------------------------------------------------------
# Store attachment mappings for ALL failed tests
# ---------------------------------------------------------

$attachmentMaps =
    @()

# ---------------------------------------------------------
# Process every failed Test Result
# ---------------------------------------------------------

foreach ($failedResult in $failedResults) {

    $testCaseId =
        [string]$failedResult.testCaseId

    $testRunId =
        [int]$failedResult.testRunId

    $azureResultId =
        [int]$failedResult.azureResultId

    Write-Host ""
    Write-Host "------------------------------------------------------------"
    Write-Host "PROCESSING FAILED TEST RESULT"
    Write-Host "------------------------------------------------------------"
    Write-Host "Test Case ID   : $testCaseId"
    Write-Host "Test Run ID    : $testRunId"
    Write-Host "Test Result ID : $azureResultId"

    # -----------------------------------------------------
    # Find screenshot belonging to this Test Case
    #
    # Clean-Screenshots.ps1 already removes evidence from
    # previous pipeline executions.
    # -----------------------------------------------------

    $matchingScreenshots =
        @(
            Get-ChildItem `
                -Path $screenshotsPath `
                -Filter "*$testCaseId*.png" `
                -File |
            Sort-Object `
                -Property LastWriteTime `
                -Descending
        )

    if ($matchingScreenshots.Count -eq 0) {

        throw "No screenshot was found for failed Test Case $testCaseId."
    }

    $screenshot =
        $matchingScreenshots[0]

    if ($matchingScreenshots.Count -gt 1) {

        Write-Host ""
        Write-Host "More than one screenshot was found for $testCaseId."
        Write-Host "The newest screenshot will be used."
    }

    Write-Host ""
    Write-Host "Screenshot:"
    Write-Host $screenshot.FullName

    # -----------------------------------------------------
    # Build attachment filename
    # -----------------------------------------------------

    $attachmentFileName =
        "${testCaseId}_Build_$env:BUILD_BUILDNUMBER.png"

    # -----------------------------------------------------
    # Azure Test Result attachments use Base64 file content
    # inside the JSON request.
    # -----------------------------------------------------

    $screenshotBytes =
        [System.IO.File]::ReadAllBytes(
            $screenshot.FullName
        )

    $base64Screenshot =
        [Convert]::ToBase64String(
            $screenshotBytes
        )

    $attachmentBody = @{
        stream =
            $base64Screenshot

        fileName =
            $attachmentFileName

        comment =
            "Failure screenshot for $testCaseId from pipeline build $env:BUILD_BUILDNUMBER."

        attachmentType =
            "GeneralAttachment"
    } | ConvertTo-Json -Depth 10

    $attachmentUri =
        "https://dev.azure.com/$Org/$Project/_apis/test/Runs/${testRunId}/Results/${azureResultId}/attachments?api-version=7.1"

    Write-Host ""
    Write-Host "Uploading screenshot to Azure Test Result..."

    $attachmentResponse =
        Invoke-RestMethod `
            -Uri $attachmentUri `
            -Method Post `
            -Headers $headers `
            -Body $attachmentBody

    $attachmentIdProperty =
        $attachmentResponse.PSObject.Properties["id"]

    if ($null -eq $attachmentIdProperty) {

        throw "Azure DevOps did not return an attachment ID for $testCaseId."
    }

    $attachmentId =
        [int]$attachmentResponse.id

    Write-Host "Screenshot successfully attached."
    Write-Host "Attachment ID   : $attachmentId"
    Write-Host "Attachment Name : $attachmentFileName"

    # -----------------------------------------------------
    # Add this failed-test attachment to the mapping array
    # -----------------------------------------------------

    $attachmentMaps +=
        [PSCustomObject]@{
            testCaseId =
                $testCaseId

            testRunId =
                $testRunId

            azureResultId =
                $azureResultId

            attachmentId =
                $attachmentId

            fileName =
                $attachmentFileName

            sourceScreenshot =
                $screenshot.FullName
        }
}

# ---------------------------------------------------------
# Save mappings for ALL failed Test Result attachments
# ---------------------------------------------------------

$attachmentMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-result-attachment-map.json"

$attachmentMaps |
    ConvertTo-Json -Depth 10 |
    Set-Content `
        -Path $attachmentMapPath `
        -Encoding UTF8

# ---------------------------------------------------------
# Final summary
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host "FAILED TEST RESULT SCREENSHOTS ATTACHED"
Write-Host "============================================================"
Write-Host "Failed Results Processed : $($failedResults.Count)"
Write-Host "Attachments Created      : $($attachmentMaps.Count)"
Write-Host ""

foreach ($attachment in $attachmentMaps) {

    Write-Host "$($attachment.testCaseId) -> Attachment ID $($attachment.attachmentId)"
}

Write-Host "============================================================"
```

### `scripts/azure-devops/Attach-TestRunLog.ps1`

**Purpose:** Attaches the Maven execution log to the Azure Test Run.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$MavenLogRelativePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Retrieve required pipeline values
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if ([string]::IsNullOrWhiteSpace($env:TEST_RUN_ID)) {
    throw "TEST_RUN_ID is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_BUILDNUMBER)) {
    throw "BUILD_BUILDNUMBER is empty."
}

$testRunId =
    [int]$env:TEST_RUN_ID

# ---------------------------------------------------------
# Build REST API authorization header
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

Write-Host ""
Write-Host "============================================================"
Write-Host "ATTACHING MAVEN LOG TO AZURE TEST RUN"
Write-Host "============================================================"
Write-Host "Organization : $Org"
Write-Host "Project      : $Project"
Write-Host "Test Run ID  : $testRunId"
Write-Host ""

# ---------------------------------------------------------
# Locate Maven log
# ---------------------------------------------------------

$mavenLogPath =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        $MavenLogRelativePath

if (-not (Test-Path $mavenLogPath)) {
    throw "Maven test output log was not found: $mavenLogPath"
}

$mavenLogFile =
    Get-Item `
        -Path $mavenLogPath

Write-Host "Maven log found:"
Write-Host $mavenLogFile.FullName
Write-Host ""
Write-Host "Log size: $($mavenLogFile.Length) bytes"

# ---------------------------------------------------------
# Build a build-specific Azure attachment filename
# ---------------------------------------------------------

$attachmentFileName =
    "maven-test-output_Build_$env:BUILD_BUILDNUMBER.log"

# ---------------------------------------------------------
# Azure Test Run attachment API expects the file content
# inside JSON as a Base64 encoded string.
# ---------------------------------------------------------

$logBytes =
    [System.IO.File]::ReadAllBytes(
        $mavenLogFile.FullName
    )

$base64Log =
    [Convert]::ToBase64String(
        $logBytes
    )

# ---------------------------------------------------------
# Build attachment request
# ---------------------------------------------------------

$attachmentBody = @{
    stream =
        $base64Log

    fileName =
        $attachmentFileName

    comment =
        "Maven Selenium/TestNG execution log from pipeline build $env:BUILD_BUILDNUMBER."

    attachmentType =
        "GeneralAttachment"
} | ConvertTo-Json -Depth 10

$attachmentUri =
    "https://dev.azure.com/$Org/$Project/_apis/test/Runs/${testRunId}/attachments?api-version=7.1"

Write-Host ""
Write-Host "Uploading Maven log to Azure Test Run..."

$attachmentResponse =
    Invoke-RestMethod `
        -Uri $attachmentUri `
        -Method Post `
        -Headers $headers `
        -Body $attachmentBody

# ---------------------------------------------------------
# Validate Azure response
# ---------------------------------------------------------

$attachmentIdProperty =
    $attachmentResponse.PSObject.Properties["id"]

if ($null -eq $attachmentIdProperty) {
    throw "Azure DevOps did not return a Test Run attachment ID."
}

$attachmentId =
    [int]$attachmentResponse.id

Write-Host ""
Write-Host "Maven log successfully attached."
Write-Host "Attachment ID   : $attachmentId"
Write-Host "Attachment Name : $attachmentFileName"

# ---------------------------------------------------------
# Save attachment mapping to TestEvidence
# ---------------------------------------------------------

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

if (-not (Test-Path $artifactRoot)) {

    New-Item `
        -ItemType Directory `
        -Force `
        -Path $artifactRoot |
    Out-Null
}

$attachmentMap =
    [PSCustomObject]@{
        testRunId =
            $testRunId

        attachmentId =
            $attachmentId

        fileName =
            $attachmentFileName

        sourceLog =
            $mavenLogFile.FullName

        buildNumber =
            $env:BUILD_BUILDNUMBER
    }

$attachmentMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-run-attachment-map.json"

$attachmentMap |
    ConvertTo-Json -Depth 10 |
    Set-Content `
        -Path $attachmentMapPath `
        -Encoding UTF8

Write-Host ""
Write-Host "Test Run attachment mapping saved:"
Write-Host $attachmentMapPath

# ---------------------------------------------------------
# Final summary
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host "MAVEN LOG ATTACHED TO TEST RUN"
Write-Host "============================================================"
Write-Host "Test Run ID   : $testRunId"
Write-Host "Attachment ID : $attachmentId"
Write-Host "File Name     : $attachmentFileName"
Write-Host "============================================================"
```

### `scripts/azure-devops/Clean-Screenshots.ps1`

**Purpose:** Deletes screenshots from previous executions to prevent stale evidence.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$ScreenshotsRelativePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($env:BUILD_SOURCESDIRECTORY)) {
    throw "BUILD_SOURCESDIRECTORY is empty."
}

$screenshotsPath =
    Join-Path `
        $env:BUILD_SOURCESDIRECTORY `
        $ScreenshotsRelativePath

Write-Host ""
Write-Host "============================================================"
Write-Host "CLEANING SCREENSHOTS DIRECTORY"
Write-Host "============================================================"
Write-Host "Path: $screenshotsPath"
Write-Host ""

if (Test-Path $screenshotsPath) {

    Write-Host "Previous Screenshots directory found."
    Write-Host "Removing previous screenshots..."

    Remove-Item `
        -Path $screenshotsPath `
        -Recurse `
        -Force

    Write-Host "Previous screenshots removed."
}
else {

    Write-Host "No previous Screenshots directory was found."
}

New-Item `
    -ItemType Directory `
    -Force `
    -Path $screenshotsPath |
Out-Null

Write-Host "Clean Screenshots directory created."

Write-Host ""
Write-Host "============================================================"
Write-Host "SCREENSHOTS DIRECTORY READY"
Write-Host "============================================================"
```

### `scripts/azure-devops/Collect-TestEvidence.ps1`

**Purpose:** Collects JSON maps, Surefire output, screenshots, and logs into the pipeline evidence directory.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$ScreenshotsRelativePath,

    [Parameter(Mandatory = $true)]
    [string]$SurefireRelativePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Validate Azure predefined environment variables
# ---------------------------------------------------------

if ([string]::IsNullOrWhiteSpace($env:BUILD_SOURCESDIRECTORY)) {
    throw "BUILD_SOURCESDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

# ---------------------------------------------------------
# TestEvidence destination
# ---------------------------------------------------------

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

New-Item `
    -ItemType Directory `
    -Force `
    -Path $artifactRoot |
Out-Null

Write-Host ""
Write-Host "============================================================"
Write-Host "COLLECTING TEST EVIDENCE"
Write-Host "============================================================"
Write-Host "Destination: $artifactRoot"
Write-Host ""

# ---------------------------------------------------------
# Copy Screenshots
# ---------------------------------------------------------

$screenshotsSource =
    Join-Path `
        $env:BUILD_SOURCESDIRECTORY `
        $ScreenshotsRelativePath

$screenshotsDestination =
    Join-Path `
        $artifactRoot `
        "Screenshots"

if (Test-Path $screenshotsSource) {

    Write-Host "Copying Screenshots..."

    if (Test-Path $screenshotsDestination) {
        Remove-Item `
            -Path $screenshotsDestination `
            -Recurse `
            -Force
    }

    Copy-Item `
        -Path $screenshotsSource `
        -Destination $screenshotsDestination `
        -Recurse `
        -Force

    Write-Host "Screenshots copied."
}
else {

    Write-Host "No Screenshots directory was found."
}

# ---------------------------------------------------------
# Copy Surefire reports
# ---------------------------------------------------------

$surefireSource =
    Join-Path `
        $env:BUILD_SOURCESDIRECTORY `
        $SurefireRelativePath

$surefireDestination =
    Join-Path `
        $artifactRoot `
        "SurefireReports"

if (Test-Path $surefireSource) {

    Write-Host "Copying Surefire reports..."

    if (Test-Path $surefireDestination) {
        Remove-Item `
            -Path $surefireDestination `
            -Recurse `
            -Force
    }

    Copy-Item `
        -Path $surefireSource `
        -Destination $surefireDestination `
        -Recurse `
        -Force

    Write-Host "Surefire reports copied."
}
else {

    Write-Host "No Surefire report directory was found."
}

# ---------------------------------------------------------
# Copy pom.xml
# ---------------------------------------------------------

$pomSource =
    Join-Path `
        $env:BUILD_SOURCESDIRECTORY `
        "pom.xml"

if (Test-Path $pomSource) {

    Copy-Item `
        -Path $pomSource `
        -Destination $artifactRoot `
        -Force

    Write-Host "pom.xml copied."
}

# ---------------------------------------------------------
# Copy azure-pipelines.yml
# ---------------------------------------------------------

$pipelineSource =
    Join-Path `
        $env:BUILD_SOURCESDIRECTORY `
        "azure-pipelines.yml"

if (Test-Path $pipelineSource) {

    Copy-Item `
        -Path $pipelineSource `
        -Destination $artifactRoot `
        -Force

    Write-Host "azure-pipelines.yml copied."
}

# ---------------------------------------------------------
# Existing mapping files are already in TestEvidence.
#
# Examples:
#
# azure-test-case-map.json
# azure-test-point-map.json
# azure-test-result-map.json
# azure-bug-map.json
# azure-bug-attachment-map.json
# azure-test-result-attachment-map.json
# azure-test-run-attachment-map.json
#
# Do not delete or recreate them here.
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host "TEST EVIDENCE COLLECTION COMPLETE"
Write-Host "============================================================"

$evidenceItems =
    @(
        Get-ChildItem `
            -Path $artifactRoot `
            -Recurse `
            -File
    )

Write-Host "Evidence files found: $($evidenceItems.Count)"
Write-Host ""

foreach ($item in $evidenceItems) {

    $relativeName =
        $item.FullName.Substring(
            $artifactRoot.Length
        ).TrimStart('\')

    Write-Host $relativeName
}

Write-Host "============================================================"
```

### `scripts/azure-devops/Create-Or-Reuse-Bugs.ps1`

**Purpose:** Creates or reuses automation Bugs for failed regression Test Cases and preserves relationships.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$BugCodePrefix,

    [Parameter(Mandatory = $true)]
    [string]$TestPlanCode,

    [Parameter(Mandatory = $true)]
    [string]$TestSuiteCode,

    [Parameter(Mandatory = $true)]
    [string]$UserStoryCode,

    [Parameter(Mandatory = $true)]
    [string]$SprintCode,

    [Parameter(Mandatory = $true)]
    [string]$LoginDataRelativePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Required pipeline/environment values
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

$iterationPath =
    $env:ITERATION_PATH

$userStoryIdText =
    $env:USER_STORY_ID

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if ([string]::IsNullOrWhiteSpace($iterationPath)) {
    throw "ITERATION_PATH is empty."
}

if ([string]::IsNullOrWhiteSpace($userStoryIdText)) {
    throw "USER_STORY_ID is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_SOURCESDIRECTORY)) {
    throw "BUILD_SOURCESDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_BUILDNUMBER)) {
    throw "BUILD_BUILDNUMBER is empty."
}

$userStoryId =
    [int]$userStoryIdText

# ---------------------------------------------------------
# Authentication
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

$patchHeaders = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json-patch+json"
}

# ---------------------------------------------------------
# Paths
# ---------------------------------------------------------

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

$testResultMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-result-map.json"

$bugMapPath =
    Join-Path `
        $artifactRoot `
        "azure-bug-map.json"

# ---------------------------------------------------------
# Read Azure Test Result mapping
# ---------------------------------------------------------

if (-not (Test-Path $testResultMapPath)) {
    throw "Test Result mapping was not found: $testResultMapPath"
}

$testResultMap =
    Get-Content `
        -Path $testResultMapPath `
        -Raw |
    ConvertFrom-Json

$testResultMap =
    @($testResultMap)

$failedResults =
    @(
        $testResultMap |
            Where-Object {
                $_.outcome -eq "Failed"
            }
    )

Write-Host ""
Write-Host "============================================================"
Write-Host "PROCESSING BUGS FOR FAILED AUTOMATED TESTS"
Write-Host "============================================================"
Write-Host "Test Results : $($testResultMap.Count)"
Write-Host "Failures     : $($failedResults.Count)"
Write-Host "Iteration    : $iterationPath"
Write-Host ""

# ---------------------------------------------------------
# If nothing failed, create an empty Bug map.
#
# This allows downstream scripts to skip Bug processing
# cleanly instead of treating "no Bug" as an error.
# ---------------------------------------------------------

if ($failedResults.Count -eq 0) {

    "[]" |
        Set-Content `
            -Path $bugMapPath `
            -Encoding UTF8

    Write-Host "No failed Test Results were found."
    Write-Host "No Bugs are required."

    Write-Host ""
    Write-Host "============================================================"
    Write-Host "BUG PROCESSING SKIPPED"
    Write-Host "============================================================"

    return
}

# ---------------------------------------------------------
# Read loginData.json
# ---------------------------------------------------------

$loginDataPath =
    Join-Path `
        $env:BUILD_SOURCESDIRECTORY `
        $LoginDataRelativePath

if (-not (Test-Path $loginDataPath)) {
    throw "loginData.json was not found: $loginDataPath"
}

$loginTests =
    Get-Content `
        -Path $loginDataPath `
        -Raw |
    ConvertFrom-Json

$loginTests =
    @($loginTests)

# ---------------------------------------------------------
# Retrieve all existing Bugs.
#
# We use these to:
#
# 1. locate an existing Automation Bug for a Test Case
# 2. determine the next available BGxxx code
# ---------------------------------------------------------

$escapedProject =
    $Project.Replace(
        "'",
        "''"
    )

$allBugsWiql =
    "SELECT [System.Id] " +
    "FROM WorkItems " +
    "WHERE [System.TeamProject] = '$escapedProject' " +
    "AND [System.WorkItemType] = 'Bug'"

$wiqlBody = @{
    query =
        $allBugsWiql
} | ConvertTo-Json -Depth 10

$wiqlUri =
    "https://dev.azure.com/$Org/$Project/_apis/wit/wiql?api-version=7.1"

$wiqlResponse =
    Invoke-RestMethod `
        -Uri $wiqlUri `
        -Method Post `
        -Headers $headers `
        -Body $wiqlBody

$bugReferences =
    @($wiqlResponse.workItems)

$existingBugs =
    @()

$highestBugNumber =
    0

$escapedPrefix =
    [regex]::Escape(
        $BugCodePrefix
    )

foreach ($bugReference in $bugReferences) {

    $existingBugId =
        [int]$bugReference.id

    $existingBugUri =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/${existingBugId}?api-version=7.1"

    $existingBug =
        Invoke-RestMethod `
            -Uri $existingBugUri `
            -Method Get `
            -Headers $headers

    $existingTitle =
        [string]$existingBug.fields.'System.Title'

    $existingState =
        [string]$existingBug.fields.'System.State'

    $existingTagsText =
        ""

    $tagsProperty =
        $existingBug.fields.PSObject.Properties["System.Tags"]

    if ($null -ne $tagsProperty) {
        $existingTagsText =
            [string]$tagsProperty.Value
    }

    $existingTags =
        @(
            $existingTagsText.Split(";") |
                ForEach-Object {
                    $_.Trim()
                } |
                Where-Object {
                    -not [string]::IsNullOrWhiteSpace($_)
                }
        )

    if (
        $existingTitle -match
        "^${escapedPrefix}(\d{3}):"
    ) {

        $bugNumber =
            [int]$Matches[1]

        if ($bugNumber -gt $highestBugNumber) {
            $highestBugNumber =
                $bugNumber
        }
    }

    $existingBugs +=
        [PSCustomObject]@{
            bugId =
                $existingBugId

            title =
                $existingTitle

            state =
                $existingState

            tags =
                $existingTags
        }
}

$nextBugNumber =
    $highestBugNumber + 1

Write-Host "Existing Bugs       : $($existingBugs.Count)"
Write-Host "Highest BG Number   : $highestBugNumber"
Write-Host "Next Available Code : $BugCodePrefix$($nextBugNumber.ToString('000'))"

# ---------------------------------------------------------
# Bug mappings for this Test Run
# ---------------------------------------------------------

$bugMaps =
    @()

# ---------------------------------------------------------
# Process every failed Test Result
# ---------------------------------------------------------

foreach ($failedResult in $failedResults) {

    $testCaseId =
        [string]$failedResult.testCaseId

    $testRunId =
        [int]$failedResult.testRunId

    $azureResultId =
        [int]$failedResult.azureResultId

    $azureTestCaseId =
        [int]$failedResult.azureTestCaseId

    $errorText =
        [string]$failedResult.errorMessage

    Write-Host ""
    Write-Host "------------------------------------------------------------"
    Write-Host "PROCESSING FAILED TEST"
    Write-Host "------------------------------------------------------------"
    Write-Host "Test Case ID       : $testCaseId"
    Write-Host "Azure Test Case ID : $azureTestCaseId"
    Write-Host "Test Run ID        : $testRunId"
    Write-Host "Test Result ID     : $azureResultId"

    # -----------------------------------------------------
    # Find corresponding test data
    # -----------------------------------------------------

    $matchingLoginTests =
        @(
            $loginTests |
                Where-Object {
                    $_.testCaseId -eq $testCaseId
                }
        )

    if ($matchingLoginTests.Count -ne 1) {
        throw "Could not uniquely find $testCaseId in loginData.json."
    }

    $loginTest =
        $matchingLoginTests[0]

    $testCaseName =
        [string]$loginTest.testCase

    $objective =
        [string]$loginTest.objective

    $expectedMessage =
        [string]$loginTest.expectedMessage

    # -----------------------------------------------------
    # Look for an EXISTING non-Closed Automation Bug
    # carrying this exact Test Case tag.
    #
    # Example:
    #
    # BG001 tags include:
    # TC006
    # Automation
    # -----------------------------------------------------

    $existingBugMatches =
        @(
            $existingBugs |
                Where-Object {

                    $_.state -ne "Closed" -and
                    $_.tags -contains $testCaseId -and
                    $_.tags -contains "Automation"
                }
        )

    if ($existingBugMatches.Count -gt 1) {

        Write-Host ""
        Write-Host "More than one active Automation Bug was found for $testCaseId."

        foreach ($duplicateBug in $existingBugMatches) {
            Write-Host "Bug ID: $($duplicateBug.bugId) - $($duplicateBug.title)"
        }

        throw "Bug processing stopped because $testCaseId has multiple active Automation Bugs."
    }

    # -----------------------------------------------------
    # Reuse existing Bug
    # -----------------------------------------------------

    if ($existingBugMatches.Count -eq 1) {

        $matchedBug =
            $existingBugMatches[0]

        $bugId =
            [int]$matchedBug.bugId

        $bugTitle =
            [string]$matchedBug.title

        if (
            $bugTitle -match
            "^(${escapedPrefix}\d{3}):"
        ) {

            $bugCode =
                [string]$Matches[1]
        }
        else {

            $bugCode =
                "{0}{1}" -f `
                    $BugCodePrefix,
                    $nextBugNumber.ToString("000")

            $nextBugNumber++

            $bugTitle =
                "{0}: Automated Test Failure for {1} - {2}" -f `
                    $bugCode,
                    $testCaseId,
                    $testCaseName
        }

        Write-Host ""
        Write-Host "Existing Automation Bug found."
        Write-Host "Bug Code : $bugCode"
        Write-Host "Bug ID   : $bugId"
        Write-Host "Title    : $bugTitle"
    }

    # -----------------------------------------------------
    # Otherwise create a new Bug code and Bug
    # -----------------------------------------------------

    else {

        if ($nextBugNumber -gt 999) {
            throw "No BGxxx codes remain using the three-digit convention."
        }

        $bugCode =
            "{0}{1}" -f `
                $BugCodePrefix,
                $nextBugNumber.ToString("000")

        $nextBugNumber++

        $bugTitle =
            "{0}: Automated Test Failure for {1} - {2}" -f `
                $bugCode,
                $testCaseId,
                $testCaseName

        Write-Host ""
        Write-Host "No active Automation Bug exists for $testCaseId."
        Write-Host "Creating new Bug:"
        Write-Host "Bug Code : $bugCode"
        Write-Host "Title    : $bugTitle"

        $createOperations =
            @(
                @{
                    op = "add"
                    path = "/fields/System.Title"
                    value = $bugTitle
                },
                @{
                    op = "add"
                    path = "/fields/System.AreaPath"
                    value = $Project
                },
                @{
                    op = "add"
                    path = "/fields/System.IterationPath"
                    value = $iterationPath
                }
            )

        $createBody =
            ConvertTo-Json `
                -InputObject $createOperations `
                -Depth 20

        $createBugUri =
            "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/`$Bug?api-version=7.1"

        $bugResponse =
            Invoke-RestMethod `
                -Uri $createBugUri `
                -Method Post `
                -Headers $patchHeaders `
                -Body $createBody

        if (-not $bugResponse.id) {
            throw "Azure DevOps did not return a Bug ID for $testCaseId."
        }

        $bugId =
            [int]$bugResponse.id

        Write-Host "Bug successfully created."
        Write-Host "Azure Bug ID: $bugId"
    }

    # -----------------------------------------------------
    # Extract actual error message when possible
    # -----------------------------------------------------

    $actualMessage =
        ""

    if ($errorText -match "but found \[(.*?)\]") {

        $actualMessage =
            $Matches[1]
    }
    else {

        $actualMessage =
            "See assertion details below."
    }

    $encodedObjective =
        [System.Net.WebUtility]::HtmlEncode(
            $objective
        )

    $encodedExpectedMessage =
        [System.Net.WebUtility]::HtmlEncode(
            $expectedMessage
        )

    $encodedActualMessage =
        [System.Net.WebUtility]::HtmlEncode(
            $actualMessage
        )

    $encodedErrorText =
        [System.Net.WebUtility]::HtmlEncode(
            $errorText
        )

    $tags =
        "$bugCode; $testCaseId; $TestPlanCode; $TestSuiteCode; $UserStoryCode; $SprintCode; Automation"

    $reproSteps =
        @"
<p><strong>AUTOMATED TEST FAILURE</strong></p>

<p>
This Bug was created or updated automatically from an Azure DevOps
automated Test Result. The failure should still be triaged to determine
whether the cause is an application defect, automation issue, test-data
issue, or environment issue.
</p>

<p><strong>Traceability</strong></p>

<p>
Bug: $bugCode<br/>
Test Case: $testCaseId<br/>
Test Plan: $TestPlanCode<br/>
Test Suite: $TestSuiteCode<br/>
User Story: $UserStoryCode<br/>
Sprint: $SprintCode<br/>
Iteration: $iterationPath
</p>

<p><strong>Test Objective</strong></p>
<p>$encodedObjective</p>

<p><strong>Pipeline Build</strong></p>
<p>$env:BUILD_BUILDNUMBER</p>

<p><strong>Azure Test Run ID</strong></p>
<p>$testRunId</p>

<p><strong>Azure Test Result ID</strong></p>
<p>$azureResultId</p>

<p><strong>Expected Result</strong></p>
<p>$encodedExpectedMessage</p>

<p><strong>Actual Result</strong></p>
<p>$encodedActualMessage</p>

<p><strong>Assertion Details</strong></p>
<p>$encodedErrorText</p>
"@

    # -----------------------------------------------------
    # Retrieve current Bug including relations
    # -----------------------------------------------------

    $bugUri =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/${bugId}?`$expand=Relations&api-version=7.1"

    $bugWorkItem =
        Invoke-RestMethod `
            -Uri $bugUri `
            -Method Get `
            -Headers $headers

    $updateOperations =
        @(
            @{
                op = "add"
                path = "/fields/System.Title"
                value = $bugTitle
            },
            @{
                op = "add"
                path = "/fields/System.AreaPath"
                value = $Project
            },
            @{
                op = "add"
                path = "/fields/System.IterationPath"
                value = $iterationPath
            },
            @{
                op = "add"
                path = "/fields/System.Tags"
                value = $tags
            },
            @{
                op = "add"
                path = "/fields/Microsoft.VSTS.TCM.ReproSteps"
                value = $reproSteps
            },
            @{
                op = "add"
                path = "/fields/System.History"
                value = "Automation failure reproduced by build $env:BUILD_BUILDNUMBER. Test Run $testRunId, Test Result $azureResultId."
            }
        )

    $relations =
        @()

    $relationsProperty =
        $bugWorkItem.PSObject.Properties["relations"]

    if ($null -ne $relationsProperty) {
        $relations =
            @($relationsProperty.Value)
    }

    # -----------------------------------------------------
    # Ensure Bug -> Test Case link
    # -----------------------------------------------------

    $existingTestCaseLinks =
        @(
            $relations |
                Where-Object {

                    $_.rel -eq "System.LinkTypes.Related" -and
                    [string]$_.url -match "/workItems/$azureTestCaseId$"
                }
        )

    if ($existingTestCaseLinks.Count -eq 0) {

        Write-Host "Adding Related link to $testCaseId..."

        $testCaseUrl =
            "https://dev.azure.com/$Org/$Project/_apis/wit/workItems/$azureTestCaseId"

        $updateOperations +=
            @{
                op = "add"
                path = "/relations/-"

                value = @{
                    rel =
                        "System.LinkTypes.Related"

                    url =
                        $testCaseUrl

                    attributes = @{
                        comment =
                            "Traceability link from $bugCode to $testCaseId."
                    }
                }
            }
    }
    else {

        Write-Host "$bugCode is already related to $testCaseId."
    }

    # -----------------------------------------------------
    # Ensure Bug -> User Story link
    # -----------------------------------------------------

    $existingUserStoryLinks =
        @(
            $relations |
                Where-Object {

                    $_.rel -eq "System.LinkTypes.Related" -and
                    [string]$_.url -match "/workItems/$userStoryId$"
                }
        )

    if ($existingUserStoryLinks.Count -eq 0) {

        Write-Host "Adding Related link to $UserStoryCode..."

        $userStoryUrl =
            "https://dev.azure.com/$Org/$Project/_apis/wit/workItems/$userStoryId"

        $updateOperations +=
            @{
                op = "add"
                path = "/relations/-"

                value = @{
                    rel =
                        "System.LinkTypes.Related"

                    url =
                        $userStoryUrl

                    attributes = @{
                        comment =
                            "Traceability link from $bugCode to $UserStoryCode."
                    }
                }
            }
    }
    else {

        Write-Host "$bugCode is already related to $UserStoryCode."
    }

    # -----------------------------------------------------
    # Apply Bug update
    # -----------------------------------------------------

    $updateBody =
        ConvertTo-Json `
            -InputObject $updateOperations `
            -Depth 20

    Invoke-RestMethod `
        -Uri $bugUri `
        -Method Patch `
        -Headers $patchHeaders `
        -Body $updateBody |
    Out-Null

    Write-Host "Bug metadata updated."

    # -----------------------------------------------------
    # Add Bug to this run's Bug mapping
    # -----------------------------------------------------

    $bugMaps +=
        [PSCustomObject]@{
            bugCode =
                $bugCode

            bugId =
                $bugId

            bugTitle =
                $bugTitle

            testCaseId =
                $testCaseId

            azureTestCaseId =
                $azureTestCaseId

            testRunId =
                $testRunId

            azureResultId =
                $azureResultId

            testPlanCode =
                $TestPlanCode

            testSuiteCode =
                $TestSuiteCode

            userStoryCode =
                $UserStoryCode

            azureUserStoryId =
                $userStoryId

            sprintCode =
                $SprintCode

            iterationPath =
                $iterationPath

            outcome =
                "Failed"

            tags =
                $tags
        }
}

# ---------------------------------------------------------
# Save ARRAY of Bug mappings.
#
# -InputObject is intentional for Windows PowerShell 5.1.
# It prevents a one-element array from being unwrapped.
# ---------------------------------------------------------

ConvertTo-Json `
    -InputObject @($bugMaps) `
    -Depth 20 |
Set-Content `
    -Path $bugMapPath `
    -Encoding UTF8

# ---------------------------------------------------------
# Final summary
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host "FAILED TEST BUG PROCESSING COMPLETE"
Write-Host "============================================================"
Write-Host "Failed Tests : $($failedResults.Count)"
Write-Host "Bug Mappings : $($bugMaps.Count)"
Write-Host ""

foreach ($mapping in $bugMaps) {

    Write-Host "$($mapping.testCaseId) -> $($mapping.bugCode) -> Azure Bug $($mapping.bugId)"
}

Write-Host "============================================================"
```

### `scripts/azure-devops/Create-TestRun.ps1`

**Purpose:** Creates a full or selective Azure Test Run from the Test Points associated with the selected Test Cases.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$TestRunCode,

    [Parameter(Mandatory = $true)]
    [string]$TestRunName,

    [Parameter(Mandatory = $true)]
    [string]$TestPlanCode,

    [Parameter(Mandatory = $true)]
    [string]$TestSuiteCode,

    [Parameter(Mandatory = $true)]
    [string]$UserStoryCode,

    [Parameter(Mandatory = $true)]
    [string]$SprintCode,

    [Parameter(Mandatory = $false)]
    [string]$SelectedTestCaseIds = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Retrieve required pipeline values
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

$testPlanIdText =
    $env:TEST_PLAN_ID

$testSuiteIdText =
    $env:TEST_SUITE_ID

$iterationPath =
    $env:ITERATION_PATH

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if ([string]::IsNullOrWhiteSpace($testPlanIdText)) {
    throw "TEST_PLAN_ID is empty."
}

if ([string]::IsNullOrWhiteSpace($testSuiteIdText)) {
    throw "TEST_SUITE_ID is empty."
}

if ([string]::IsNullOrWhiteSpace($iterationPath)) {
    throw "ITERATION_PATH is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_BUILDNUMBER)) {
    throw "BUILD_BUILDNUMBER is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_BUILDID)) {
    throw "BUILD_BUILDID is empty."
}

$testPlanId =
    [int]$testPlanIdText

$testSuiteId =
    [int]$testSuiteIdText

# ---------------------------------------------------------
# Authentication
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

# ---------------------------------------------------------
# Locate Test Case mapping
# ---------------------------------------------------------

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

$testCaseMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-case-map.json"

if (-not (Test-Path $testCaseMapPath)) {
    throw "Test Case mapping file was not found: $testCaseMapPath"
}

$testCaseMap =
    Get-Content `
        -Path $testCaseMapPath `
        -Raw |
    ConvertFrom-Json

$testCaseMap =
    @($testCaseMap)

if ($testCaseMap.Count -eq 0) {
    throw "No Test Cases were found in the Test Case mapping."
}

# ---------------------------------------------------------
# Optional Test Case selection
#
# Full regression:
# SelectedTestCaseIds is blank, so all Test Cases remain.
#
# Bug retest:
# Example:
# SelectedTestCaseIds = "TC006"
#
# Multiple Test Cases are supported:
# SelectedTestCaseIds = "TC003,TC006"
# ---------------------------------------------------------

if (-not [string]::IsNullOrWhiteSpace($SelectedTestCaseIds)) {

    $requestedTestCaseIds =
        @(
            $SelectedTestCaseIds.Split(",") |
                ForEach-Object {
                    $_.Trim().ToUpperInvariant()
                } |
                Where-Object {
                    -not [string]::IsNullOrWhiteSpace($_)
                } |
                Sort-Object -Unique
        )

    if ($requestedTestCaseIds.Count -eq 0) {
        throw "SelectedTestCaseIds was supplied but contained no valid Test Case IDs."
    }

    Write-Host ""
    Write-Host "Selected Test Cases requested:"

    foreach ($requestedId in $requestedTestCaseIds) {
        Write-Host "  $requestedId"
    }

    # -----------------------------------------------------
    # Validate every requested Test Case exists in the
    # complete Azure Test Case mapping.
    # -----------------------------------------------------

    $availableTestCaseIds =
        @(
            $testCaseMap |
                ForEach-Object {
                    ([string]$_.testCaseId).ToUpperInvariant()
                }
        )

    $missingTestCaseIds =
        @(
            $requestedTestCaseIds |
                Where-Object {
                    $availableTestCaseIds -notcontains $_
                }
        )

    if ($missingTestCaseIds.Count -gt 0) {

        $missingText =
            $missingTestCaseIds -join ", "

        throw "The following selected Test Cases were not found in the Azure Test Case mapping: $missingText"
    }

    # -----------------------------------------------------
    # Keep only the requested Test Cases.
    # -----------------------------------------------------

    $testCaseMap =
        @(
            $testCaseMap |
                Where-Object {

                    $mappedTestCaseId =
                        ([string]$_.testCaseId).ToUpperInvariant()

                    $requestedTestCaseIds -contains $mappedTestCaseId
                }
        )

    if ($testCaseMap.Count -ne $requestedTestCaseIds.Count) {
        throw "The selected Test Case mapping count does not match the requested Test Case count."
    }

    Write-Host ""
    Write-Host "Retest Test Cases selected: $($testCaseMap.Count)"
}
else {

    Write-Host ""
    Write-Host "No Test Case filter supplied."
    Write-Host "Full Test Case mapping will be used."
}

Write-Host ""
Write-Host "============================================================"
Write-Host "RETRIEVING AZURE DEVOPS TEST POINTS"
Write-Host "============================================================"
Write-Host "Organization    : $Org"
Write-Host "Project         : $Project"
Write-Host "Test Plan       : $TestPlanCode ($testPlanId)"
Write-Host "Test Suite      : $TestSuiteCode ($testSuiteId)"
Write-Host "User Story      : $UserStoryCode"
Write-Host "Sprint          : $SprintCode"
Write-Host "Iteration       : $iterationPath"
Write-Host "Test Cases      : $($testCaseMap.Count)"
Write-Host ""

# ---------------------------------------------------------
# Retrieve one Test Point for every Test Case
# ---------------------------------------------------------

$testPointMap =
    @()

foreach ($mapping in $testCaseMap) {

    $localTestCaseId =
        [string]$mapping.testCaseId

    $testCaseName =
        [string]$mapping.testCaseName

    $azureTestCaseId =
        [int]$mapping.azureTestCaseId

    Write-Host "------------------------------------------------------------"
    Write-Host "Retrieving Test Point:"
    Write-Host "Test Case          : $localTestCaseId"
    Write-Host "Name               : $testCaseName"
    Write-Host "Azure Test Case ID : $azureTestCaseId"

    $testPointsUri =
        "https://dev.azure.com/$Org/$Project/_apis/test/Plans/${testPlanId}/Suites/${testSuiteId}/points?testCaseId=${azureTestCaseId}&includePointDetails=true&api-version=7.1"

    $testPoint =
        $null

    # -----------------------------------------------------
    # Test Points may take a few seconds to appear after
    # Test Case/Suite changes.
    # -----------------------------------------------------

    for ($attempt = 1; $attempt -le 5; $attempt++) {

        Write-Host "Attempt $attempt of 5..."

        $testPointsResponse =
            Invoke-RestMethod `
                -Uri $testPointsUri `
                -Method Get `
                -Headers $headers

        $availablePoints =
            @($testPointsResponse.value)

        if ($availablePoints.Count -gt 0) {

            $testPoint =
                $availablePoints[0]

            break
        }

        if ($attempt -lt 5) {

            Write-Host "Test Point not available yet."
            Write-Host "Waiting 3 seconds..."

            Start-Sleep -Seconds 3
        }
    }

    if ($null -eq $testPoint) {

        throw "No Test Point was found for Azure Test Case $azureTestCaseId."
    }

    $testPointId =
        [int]$testPoint.id

    Write-Host "Test Point ID: $testPointId"

    $testPointMap +=
        [PSCustomObject]@{
            testCaseId =
                $localTestCaseId

            testCaseName =
                $testCaseName

            azureTestCaseId =
                $azureTestCaseId

            testPointId =
                $testPointId
        }

    Write-Host ""
}

# ---------------------------------------------------------
# Validate Test Point mapping
# ---------------------------------------------------------

if ($testPointMap.Count -ne $testCaseMap.Count) {

    throw "Not every Test Case was mapped to a Test Point."
}

$pointIds =
    @(
        $testPointMap |
            ForEach-Object {
                [int]$_.testPointId
            }
    )

Write-Host "============================================================"
Write-Host "TEST POINTS READY"
Write-Host "============================================================"

foreach ($mapping in $testPointMap) {

    Write-Host "$($mapping.testCaseId) -> Test Point ID $($mapping.testPointId)"
}

Write-Host ""
Write-Host "Total Test Points: $($pointIds.Count)"

# ---------------------------------------------------------
# Save Test Point mapping
# ---------------------------------------------------------

$testPointMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-point-map.json"

ConvertTo-Json `
    -InputObject $testPointMap `
    -Depth 10 |
Set-Content `
    -Path $testPointMapPath `
    -Encoding UTF8

# ---------------------------------------------------------
# Build Test Run traceability
#
# Azure currently allows a maximum of five Test Run tags.
# These five codes give us the complete Agile traceability
# chain without needing an additional Automation tag.
# ---------------------------------------------------------

$runTagNames =
    @(
        $TestRunCode,
        $TestPlanCode,
        $TestSuiteCode,
        $UserStoryCode,
        $SprintCode
    )

if ($runTagNames.Count -gt 5) {
    throw "Azure DevOps allows a maximum of five Test Run tags."
}

$runTags =
    @(
        $runTagNames |
            ForEach-Object {
                @{
                    name =
                        $_
                }
            }
    )

# ---------------------------------------------------------
# Build a unique execution name
#
# TR001 is the logical Test Run code.
# Build Number distinguishes each actual execution.
# ---------------------------------------------------------

$runName =
    "{0}: {1} - Build {2}" -f `
        $TestRunCode,
        $TestRunName,
        $env:BUILD_BUILDNUMBER

# ---------------------------------------------------------
# Create NEW Azure Test Run
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host "CREATING AZURE DEVOPS TEST RUN"
Write-Host "============================================================"
Write-Host "Test Run Code : $TestRunCode"
Write-Host "Name          : $runName"
Write-Host "Test Plan     : $TestPlanCode ($testPlanId)"
Write-Host "Test Suite    : $TestSuiteCode ($testSuiteId)"
Write-Host "User Story    : $UserStoryCode"
Write-Host "Sprint        : $SprintCode"
Write-Host "Iteration     : $iterationPath"
Write-Host "Build         : $env:BUILD_BUILDNUMBER"
Write-Host "Test Points   : $($pointIds.Count)"
Write-Host ""
Write-Host "Tags:"

foreach ($tag in $runTagNames) {
    Write-Host "  $tag"
}

$createRunUri =
    "https://dev.azure.com/$Org/$Project/_apis/test/runs?api-version=7.1"

$runComment =
    @"
Automated FSWEP login Test Run.

Traceability:
Test Run: $TestRunCode
Test Plan: $TestPlanCode
Test Suite: $TestSuiteCode
User Story: $UserStoryCode
Sprint: $SprintCode
Iteration: $iterationPath
Pipeline Build: $env:BUILD_BUILDNUMBER
"@

$runBody = @{
    name =
        $runName

    plan =
        @{
            id =
                "$testPlanId"
        }

    pointIds =
        $pointIds

    automated =
        $true

    state =
        "InProgress"

    iteration =
        $iterationPath

    tags =
        $runTags

    comment =
        $runComment

    build =
        @{
            id =
                "$env:BUILD_BUILDID"
        }
} | ConvertTo-Json -Depth 20

$runResponse =
    Invoke-RestMethod `
        -Uri $createRunUri `
        -Method Post `
        -Headers $headers `
        -Body $runBody

if (-not $runResponse.id) {
    throw "Azure DevOps did not return a Test Run ID."
}

$testRunId =
    [int]$runResponse.id

Write-Host ""
Write-Host "Azure DevOps Test Run successfully created."
Write-Host "Test Run ID : $testRunId"
Write-Host "State       : $($runResponse.state)"

# ---------------------------------------------------------
# Make Test Run ID available to downstream tasks
# ---------------------------------------------------------

Write-Host ""
Write-Host "Saving Test Run ID for later pipeline tasks..."

Write-Host "##vso[task.setvariable variable=TEST_RUN_ID]$testRunId"

# ---------------------------------------------------------
# Save Test Run traceability mapping
# ---------------------------------------------------------

$testRunMap =
    [PSCustomObject]@{
        testRunCode =
            $TestRunCode

        testRunName =
            $runName

        azureTestRunId =
            $testRunId

        testPlanCode =
            $TestPlanCode

        azureTestPlanId =
            $testPlanId

        testSuiteCode =
            $TestSuiteCode

        azureTestSuiteId =
            $testSuiteId

        userStoryCode =
            $UserStoryCode

        sprintCode =
            $SprintCode

        iterationPath =
            $iterationPath

        buildNumber =
            $env:BUILD_BUILDNUMBER

        buildId =
            $env:BUILD_BUILDID

        automated =
            $true

        tags =
            $runTagNames
    }

$testRunMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-run-map.json"

$testRunMap |
    ConvertTo-Json -Depth 10 |
    Set-Content `
        -Path $testRunMapPath `
        -Encoding UTF8

Write-Host ""
Write-Host "Test Run mapping saved:"
Write-Host $testRunMapPath

# ---------------------------------------------------------
# Final summary
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host "TEST RUN READY"
Write-Host "============================================================"
Write-Host "Run Code       : $TestRunCode"
Write-Host "Run ID         : $testRunId"
Write-Host "Name           : $runName"
Write-Host "Test Plan      : $TestPlanCode ($testPlanId)"
Write-Host "Test Suite     : $TestSuiteCode ($testSuiteId)"
Write-Host "User Story     : $UserStoryCode"
Write-Host "Sprint         : $SprintCode"
Write-Host "Iteration      : $iterationPath"
Write-Host "Build          : $env:BUILD_BUILDNUMBER"
Write-Host "Test Points    : $($pointIds.Count)"
Write-Host "============================================================"
```

### `scripts/azure-devops/Ensure-Iteration.ps1`

**Purpose:** Finds or creates Sprint 001 and exposes the iteration path to later pipeline tasks.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$TeamName,

    [Parameter(Mandatory = $true)]
    [string]$SprintName,

    [Parameter(Mandatory = $true)]
    [string]$SprintCode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Retrieve PAT
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

# ---------------------------------------------------------
# Authentication
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

Write-Host ""
Write-Host "============================================================"
Write-Host "CHECKING AZURE DEVOPS SPRINT ITERATION"
Write-Host "============================================================"
Write-Host "Organization : $Org"
Write-Host "Project      : $Project"
Write-Host "Sprint Code  : $SprintCode"
Write-Host "Sprint Name  : $SprintName"
Write-Host ""

# ---------------------------------------------------------
# Retrieve the project's iteration tree
# ---------------------------------------------------------

$iterationsUri =
    "https://dev.azure.com/$Org/$Project/_apis/wit/classificationnodes/Iterations?`$depth=1&api-version=7.1"

$iterationsResponse =
    Invoke-RestMethod `
        -Uri $iterationsUri `
        -Method Get `
        -Headers $headers

$childrenProperty =
    $iterationsResponse.PSObject.Properties["children"]

$existingIterations =
    @()

if ($null -ne $childrenProperty) {

    $existingIterations =
        @($childrenProperty.Value)
}

# ---------------------------------------------------------
# Find Sprint 001 by exact name
# ---------------------------------------------------------

$matchingIterations =
    @(
        $existingIterations |
            Where-Object {
                $_.name -eq $SprintName
            }
    )

if ($matchingIterations.Count -gt 1) {

    throw "More than one iteration named '$SprintName' was found."
}

# ---------------------------------------------------------
# Reuse existing iteration
# ---------------------------------------------------------

if ($matchingIterations.Count -eq 1) {

    $iteration =
        $matchingIterations[0]

    Write-Host "Existing sprint iteration found."
    Write-Host "No new iteration will be created."
}

# ---------------------------------------------------------
# Otherwise create Sprint 001
# ---------------------------------------------------------

else {

    Write-Host "Sprint iteration does not exist."
    Write-Host "Creating '$SprintName'..."

    $createIterationBody = @{
        name =
            $SprintName
    } | ConvertTo-Json -Depth 10

    $iteration =
        Invoke-RestMethod `
            -Uri $iterationsUri `
            -Method Post `
            -Headers $headers `
            -Body $createIterationBody

    Write-Host "Sprint iteration successfully created."
}

# ---------------------------------------------------------
# Validate returned project iteration
#
# Azure classification nodes have:
#
# id         = integer node ID
# identifier = GUID used by Team Iteration API
# ---------------------------------------------------------

if (-not $iteration.id) {
    throw "Azure DevOps did not return an iteration node ID."
}

$identifierProperty =
    $iteration.PSObject.Properties["identifier"]

if ($null -eq $identifierProperty) {
    throw "Azure DevOps did not return an iteration GUID identifier."
}

$iterationNodeId =
    [int]$iteration.id

$iterationIdentifier =
    [string]$iteration.identifier

$iterationPath =
    "$Project\$SprintName"

Write-Host ""
Write-Host "Iteration Node ID : $iterationNodeId"
Write-Host "Iteration GUID    : $iterationIdentifier"
Write-Host "Iteration Path    : $iterationPath"

# ---------------------------------------------------------
# Ensure Sprint 001 is selected for the Azure DevOps team
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host "CHECKING TEAM SPRINT ASSIGNMENT"
Write-Host "============================================================"
Write-Host "Team       : $TeamName"
Write-Host "Sprint     : $SprintName"
Write-Host "Sprint GUID: $iterationIdentifier"
Write-Host ""

$encodedTeamName =
    [System.Uri]::EscapeDataString(
        $TeamName
    )

$teamIterationsUri =
    "https://dev.azure.com/$Org/$Project/$encodedTeamName/_apis/work/teamsettings/iterations?api-version=7.1"

$teamIterationsResponse =
    Invoke-RestMethod `
        -Uri $teamIterationsUri `
        -Method Get `
        -Headers $headers

# Azure API responses may expose the collection as
# either value or values depending on the endpoint response.
$teamIterations =
    @()

$valueProperty =
    $teamIterationsResponse.PSObject.Properties["value"]

$valuesProperty =
    $teamIterationsResponse.PSObject.Properties["values"]

if ($null -ne $valueProperty) {

    $teamIterations =
        @($valueProperty.Value)
}
elseif ($null -ne $valuesProperty) {

    $teamIterations =
        @($valuesProperty.Value)
}

$matchingTeamIterations =
    @(
        $teamIterations |
            Where-Object {
                [string]$_.id -eq $iterationIdentifier
            }
    )

if ($matchingTeamIterations.Count -gt 1) {

    throw "Sprint '$SprintName' appears more than once in the team iteration list."
}

if ($matchingTeamIterations.Count -eq 1) {

    Write-Host "Sprint is already selected for team '$TeamName'."
    Write-Host "No team iteration change is required."
}
else {

    Write-Host "Sprint exists at the project level but is not selected for the team."
    Write-Host "Adding '$SprintName' to team '$TeamName'..."

    $teamIterationBody = @{
        id =
            $iterationIdentifier
    } | ConvertTo-Json -Depth 10

    $teamIterationResponse =
        Invoke-RestMethod `
            -Uri $teamIterationsUri `
            -Method Post `
            -Headers $headers `
            -Body $teamIterationBody

    if (-not $teamIterationResponse.id) {
        throw "Azure DevOps did not return the newly assigned team iteration."
    }

    Write-Host "Sprint successfully added to team '$TeamName'."
}

# ---------------------------------------------------------
# Make the iteration available to later pipeline tasks
# ---------------------------------------------------------

Write-Host ""
Write-Host "Saving Sprint iteration values for later pipeline tasks..."

Write-Host "##vso[task.setvariable variable=ITERATION_PATH]$iterationPath"
Write-Host "##vso[task.setvariable variable=ITERATION_ID]$iterationNodeId"
Write-Host "##vso[task.setvariable variable=ITERATION_IDENTIFIER]$iterationIdentifier"

# ---------------------------------------------------------
# Final summary
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host "SPRINT ITERATION READY"
Write-Host "============================================================"
Write-Host "Sprint Code       : $SprintCode"
Write-Host "Sprint Name       : $SprintName"
Write-Host "Iteration Path    : $iterationPath"
Write-Host "Iteration Node ID : $iterationNodeId"
Write-Host "Iteration GUID    : $iterationIdentifier"
Write-Host "Team              : $TeamName"
Write-Host "============================================================"
```

### `scripts/azure-devops/Ensure-TestCases.ps1`

**Purpose:** Creates or reuses Azure Test Cases from the canonical regression JSON and preserves existing lifecycle state.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$TestPlanCode,

    [Parameter(Mandatory = $true)]
    [string]$TestSuiteCode,

    [Parameter(Mandatory = $true)]
    [string]$UserStoryCode,

    [Parameter(Mandatory = $true)]
    [string]$SprintCode,

    [Parameter(Mandatory = $true)]
    [string]$LoginDataRelativePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Required environment values
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

$testPlanIdText =
    $env:TEST_PLAN_ID

$testSuiteIdText =
    $env:TEST_SUITE_ID

$userStoryIdText =
    $env:USER_STORY_ID

$iterationPath =
    $env:ITERATION_PATH

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if (
    $token -eq '$(AZURE_PAT)' -or
    $token -match '^\$\([^)]+\)$'
) {
    throw "AZURE_PAT was not expanded."
}

if ([string]::IsNullOrWhiteSpace($testPlanIdText)) {
    throw "TEST_PLAN_ID is empty."
}

if ([string]::IsNullOrWhiteSpace($testSuiteIdText)) {
    throw "TEST_SUITE_ID is empty."
}

if ([string]::IsNullOrWhiteSpace($userStoryIdText)) {
    throw "USER_STORY_ID is empty."
}

if ([string]::IsNullOrWhiteSpace($iterationPath)) {
    throw "ITERATION_PATH is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_SOURCESDIRECTORY)) {
    throw "BUILD_SOURCESDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

$testPlanId =
    [int]$testPlanIdText

$testSuiteId =
    [int]$testSuiteIdText

$userStoryId =
    [int]$userStoryIdText

# ---------------------------------------------------------
# Authentication
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

$patchHeaders = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json-patch+json"
}

# ---------------------------------------------------------
# Helper: escape WIQL text
# ---------------------------------------------------------

function Escape-WiqlText {

    param (
        [string]$Text
    )

    return $Text.Replace("'", "''")
}

# ---------------------------------------------------------
# Helper: build Azure manual Test Step XML
# ---------------------------------------------------------

function Add-TestStep {

    param (
        [System.Xml.XmlDocument]$Document,
        [System.Xml.XmlElement]$Steps,
        [string]$StepId,
        [string]$ActionText,
        [string]$ExpectedText
    )

    $stepElement =
        $Document.CreateElement("step")

    $stepElement.SetAttribute(
        "id",
        $StepId
    )

    $stepElement.SetAttribute(
        "type",
        "ValidateStep"
    )

    $actionElement =
        $Document.CreateElement(
            "parameterizedString"
        )

    $actionElement.SetAttribute(
        "isformatted",
        "true"
    )

    $actionElement.InnerText =
        "<DIV>$ActionText</DIV>"

    $expectedElement =
        $Document.CreateElement(
            "parameterizedString"
        )

    $expectedElement.SetAttribute(
        "isformatted",
        "true"
    )

    $expectedElement.InnerText =
        "<DIV>$ExpectedText</DIV>"

    $descriptionElement =
        $Document.CreateElement(
            "description"
        )

    $stepElement.AppendChild(
        $actionElement
    ) | Out-Null

    $stepElement.AppendChild(
        $expectedElement
    ) | Out-Null

    $stepElement.AppendChild(
        $descriptionElement
    ) | Out-Null

    $Steps.AppendChild(
        $stepElement
    ) | Out-Null
}

# ---------------------------------------------------------
# Load the canonical Test Case data file
# ---------------------------------------------------------

$loginDataPath =
    Join-Path `
        $env:BUILD_SOURCESDIRECTORY `
        $LoginDataRelativePath

if (-not (Test-Path $loginDataPath)) {
    throw "Test Case data file was not found at: $loginDataPath"
}

$loginTests =
    Get-Content `
        -Path $loginDataPath `
        -Raw |
    ConvertFrom-Json

$loginTests =
    @($loginTests)

if ($loginTests.Count -eq 0) {
    throw "No Test Cases were found in: $loginDataPath"
}

Write-Host ""
Write-Host "============================================================"
Write-Host "PROCESSING AZURE DEVOPS TEST CASES"
Write-Host "============================================================"
Write-Host "Test Plan       : $TestPlanCode ($testPlanId)"
Write-Host "Test Suite      : $TestSuiteCode ($testSuiteId)"
Write-Host "User Story      : $UserStoryCode ($userStoryId)"
Write-Host "Sprint          : $SprintCode"
Write-Host "Iteration       : $iterationPath"
Write-Host "Data File       : $LoginDataRelativePath"
Write-Host "Test Cases      : $($loginTests.Count)"
Write-Host "============================================================"

# ---------------------------------------------------------
# Retrieve Test Cases already associated with TS001
# ---------------------------------------------------------

$suiteCasesUri =
    "https://dev.azure.com/$Org/$Project/_apis/test/Plans/${testPlanId}/suites/${testSuiteId}/testcases?api-version=7.1"

$suiteCasesResponse =
    Invoke-RestMethod `
        -Uri $suiteCasesUri `
        -Method Get `
        -Headers $headers

$existingSuiteTestCaseIds =
    @(
        $suiteCasesResponse.value |
            ForEach-Object {
                [int]$_.testCase.id
            }
    )

Write-Host ""
Write-Host "Existing Test Cases associated with TS001: $($existingSuiteTestCaseIds.Count)"

$testCaseMap =
    @()

# ---------------------------------------------------------
# Process each Test Case
# ---------------------------------------------------------

foreach ($loginTest in $loginTests) {

    $localTestCaseId =
        [string]$loginTest.testCaseId

    $localTestCaseName =
        [string]$loginTest.testCase

    $objective =
        [string]$loginTest.objective

    $expectedResult =
        [string]$loginTest.expected

    $expectedMessage =
        [string]$loginTest.expectedMessage

    # PowerShell can interpret a colon directly after a
    # variable name specially, so use the format operator.
    $azureTitle =
        "{0}: {1}" -f `
            $localTestCaseId,
            $localTestCaseName


    $tags =
        "$localTestCaseId; $TestPlanCode; $TestSuiteCode; $UserStoryCode; $SprintCode; Automation"

    $description =
        @"
<p><strong>FSWEP Automated Test Case</strong></p>

<p>
<strong>Test Case Code:</strong> $localTestCaseId<br/>
<strong>Objective:</strong> $objective
</p>

<p><strong>Traceability</strong></p>

<p>
Test Plan: $TestPlanCode<br/>
Test Suite: $TestSuiteCode<br/>
User Story: $UserStoryCode<br/>
Sprint: $SprintCode<br/>
Iteration: $iterationPath
</p>
"@

    Write-Host ""
    Write-Host "------------------------------------------------------------"
    Write-Host "PROCESSING TEST CASE"
    Write-Host "------------------------------------------------------------"
    Write-Host "Code         : $localTestCaseId"
    Write-Host "Target Title : $azureTitle"

    # -----------------------------------------------------
    # Generic manual instructions.
    #
    # Actual credentials are deliberately not copied into
    # Azure Test Case work items.
    # -----------------------------------------------------

    $usernameIsBlank =
        [string]::IsNullOrEmpty(
            [string]$loginTest.username
        )

    $passwordIsBlank =
        [string]::IsNullOrEmpty(
            [string]$loginTest.password
        )

    if ($usernameIsBlank -and $passwordIsBlank) {

        $credentialAction =
            "Leave both the username and password fields blank."
    }
    elseif ($usernameIsBlank) {

        $credentialAction =
            "Leave the username field blank and enter a password."
    }
    elseif ($passwordIsBlank) {

        $credentialAction =
            "Enter a username and leave the password field blank."
    }
    elseif ($localTestCaseId -eq "TC002" -or $localTestCaseId -eq "TC006") {

        $credentialAction =
            "Enter a valid username and an invalid password."
    }
    else {

        $credentialAction =
            "Enter a valid username and valid password."
    }

    if ($expectedResult -eq "SUCCESS") {

        $loginExpectedText =
            "The user is successfully signed in."
    }
    elseif ([string]::IsNullOrWhiteSpace($expectedMessage)) {

        $loginExpectedText =
            "The login attempt is rejected."
    }
    else {

        $loginExpectedText =
            "The login attempt is rejected and the expected validation message is displayed: $expectedMessage"
    }

   # ---------------------------------------------------------
   # Search for existing Test Case by its final coded title
   # ---------------------------------------------------------

   $escapedProject =
       Escape-WiqlText $Project

   $escapedAzureTitle =
       Escape-WiqlText $azureTitle

   $wiql =
       "SELECT [System.Id], [System.Title] " +
       "FROM WorkItems " +
       "WHERE [System.TeamProject] = '$escapedProject' " +
       "AND [System.WorkItemType] = 'Test Case' " +
       "AND [System.Title] = '$escapedAzureTitle'"

   $wiqlBody = @{
       query =
           $wiql
   } | ConvertTo-Json -Depth 10

   $wiqlUri =
       "https://dev.azure.com/$Org/$Project/_apis/wit/wiql?api-version=7.1"

   $wiqlResponse =
       Invoke-RestMethod `
           -Uri $wiqlUri `
           -Method Post `
           -Headers $headers `
           -Body $wiqlBody

   $matchingWorkItems =
       @($wiqlResponse.workItems)

    if ($matchingWorkItems.Count -gt 1) {

        Write-Host ""
        Write-Host "Multiple matching Test Cases were found."

        foreach ($duplicate in $matchingWorkItems) {
            Write-Host "Azure Work Item ID: $($duplicate.id)"
        }

        throw "More than one Test Case exists for $localTestCaseId."
    }

    # -----------------------------------------------------
    # Track whether this Test Case was created during this
    # pipeline execution.
    #
    # New Test Cases will be promoted from Design to Ready.
    # Existing Test Cases keep their current lifecycle state.
    # -----------------------------------------------------

    $testCaseWasCreated =
        $false

    # -----------------------------------------------------
    # Reuse existing Test Case
    # -----------------------------------------------------

    if ($matchingWorkItems.Count -eq 1) {

        $azureTestCaseId =
            [int]$matchingWorkItems[0].id

        Write-Host "Existing Test Case found."
        Write-Host "Azure Test Case ID: $azureTestCaseId"
        Write-Host "Existing Test Case will be updated."
    }

    # -----------------------------------------------------
    # Otherwise create a brand-new Test Case
    # -----------------------------------------------------

    else {

        $testCaseWasCreated =
                $true

        Write-Host "No existing Test Case found."
        Write-Host "Creating $localTestCaseId..."

        $xmlDocument =
            New-Object System.Xml.XmlDocument

        $stepsElement =
            $xmlDocument.CreateElement("steps")

        $stepsElement.SetAttribute(
            "id",
            "0"
        )

        $stepsElement.SetAttribute(
            "last",
            "5"
        )

        Add-TestStep `
            -Document $xmlDocument `
            -Steps $stepsElement `
            -StepId "2" `
            -ActionText "Open the application login page in Google Chrome." `
            -ExpectedText "The login page is displayed successfully."

        Add-TestStep `
            -Document $xmlDocument `
            -Steps $stepsElement `
            -StepId "3" `
            -ActionText $credentialAction `
            -ExpectedText "The specified login test data is entered."

        Add-TestStep `
            -Document $xmlDocument `
            -Steps $stepsElement `
            -StepId "4" `
            -ActionText "Select the Login button." `
            -ExpectedText "The application processes the login attempt."

        Add-TestStep `
            -Document $xmlDocument `
            -Steps $stepsElement `
            -StepId "5" `
            -ActionText "Compare the actual login result with the expected result." `
            -ExpectedText $loginExpectedText

        $xmlDocument.AppendChild(
            $stepsElement
        ) | Out-Null

        $testStepsXml =
            $xmlDocument.OuterXml

        $createOperations =
            @(
                @{
                    op = "add"
                    path = "/fields/System.Title"
                    value = $azureTitle
                },
                @{
                    op = "add"
                    path = "/fields/System.AreaPath"
                    value = $Project
                },
                @{
                    op = "add"
                    path = "/fields/Microsoft.VSTS.TCM.Steps"
                    value = $testStepsXml
                }
            )

        $createBody =
            ConvertTo-Json `
                -InputObject $createOperations `
                -Depth 20

        $createUri =
            "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/`$Test%20Case?api-version=7.1"

        $createResponse =
            Invoke-RestMethod `
                -Uri $createUri `
                -Method Post `
                -Headers $patchHeaders `
                -Body $createBody

        if (-not $createResponse.id) {
            throw "Azure DevOps did not return a Test Case Work Item ID."
        }

        $azureTestCaseId =
            [int]$createResponse.id

        Write-Host "New Test Case created."
        Write-Host "Azure Test Case ID: $azureTestCaseId"
    }

    # -----------------------------------------------------
    # Retrieve Test Case Work Item including relationships
    # -----------------------------------------------------

    $workItemUri =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/${azureTestCaseId}?`$expand=Relations&api-version=7.1"

    $testCaseWorkItem =
        Invoke-RestMethod `
            -Uri $workItemUri `
            -Method Get `
            -Headers $headers

    $workItemType =
        [string]$testCaseWorkItem.fields.'System.WorkItemType'

    if ($workItemType -ne "Test Case") {
        throw "Work Item $azureTestCaseId is '$workItemType', not 'Test Case'."
    }

    $currentTestCaseState =
        [string]$testCaseWorkItem.fields.'System.State'

    Write-Host "Current Test Case state: $currentTestCaseState"

    # -----------------------------------------------------
    # Update title, Sprint, tags and traceability metadata
    # -----------------------------------------------------

    $updateOperations =
        @(
            @{
                op = "add"
                path = "/fields/System.Title"
                value = $azureTitle
            },
            @{
                op = "add"
                path = "/fields/System.AreaPath"
                value = $Project
            },
            @{
                op = "add"
                path = "/fields/System.IterationPath"
                value = $iterationPath
            },
            @{
                op = "add"
                path = "/fields/System.Tags"
                value = $tags
            },
            @{
                op = "add"
                path = "/fields/System.Description"
                value = $description
            }
        )

    # -----------------------------------------------------
    # Newly created Test Cases begin in Design.
    #
    # For this training project, the JSON source represents
    # reviewed and approved automated Test Cases, so newly
    # created cases are immediately promoted to Ready.
    #
    # Existing Test Cases keep their current state so the
    # pipeline cannot accidentally reopen a Closed case or
    # override a tester's lifecycle decision.
    # -----------------------------------------------------

    if ($testCaseWasCreated) {

        if ($currentTestCaseState -eq "Design") {

            Write-Host "New Test Case $localTestCaseId will be moved from Design to Ready."

            $updateOperations +=
                @{
                    op =
                        "replace"

                    path =
                        "/fields/System.State"

                    value =
                        "Ready"
                }
        }
        elseif ($currentTestCaseState -ne "Ready") {

            throw "New Test Case $localTestCaseId was created in unexpected state '$currentTestCaseState'."
        }
    }
    else {

        Write-Host "Existing Test Case state will be preserved: $currentTestCaseState"
    }

    # -----------------------------------------------------
    # Test Case -> User Story relationship
    #
    # From the Test Case side, Azure calls this relation
    # "Tests". On the User Story side it appears as
    # "Tested By".
    # -----------------------------------------------------

    $relations =
        @()

    $relationsProperty =
        $testCaseWorkItem.PSObject.Properties["relations"]

    if ($null -ne $relationsProperty) {

        $relations =
            @($relationsProperty.Value)
    }

    $existingUserStoryLinks =
        @(
            $relations |
                Where-Object {

                    $_.rel -eq "Microsoft.VSTS.Common.TestedBy-Reverse" -and
                    [string]$_.url -match "/workItems/$userStoryId$"
                }
        )

    if ($existingUserStoryLinks.Count -eq 0) {

        Write-Host "Adding Tests/Tested By link to $UserStoryCode..."

        $userStoryUrl =
            "https://dev.azure.com/$Org/$Project/_apis/wit/workItems/$userStoryId"

        $updateOperations +=
            @{
                op =
                    "add"

                path =
                    "/relations/-"

                value =
                    @{
                        rel =
                            "Microsoft.VSTS.Common.TestedBy-Reverse"

                        url =
                            $userStoryUrl

                        attributes =
                            @{
                                comment =
                                    "$localTestCaseId tests $UserStoryCode."
                            }
                    }
            }
    }
    else {

        Write-Host "$localTestCaseId is already linked to $UserStoryCode."
    }

    $updateBody =
        ConvertTo-Json `
            -InputObject $updateOperations `
            -Depth 20

    $updatedTestCase =
        Invoke-RestMethod `
            -Uri $workItemUri `
            -Method Patch `
            -Headers $patchHeaders `
            -Body $updateBody

    $finalTestCaseState =
        [string]$updatedTestCase.fields.'System.State'

    if (
        $testCaseWasCreated -and
        $finalTestCaseState -ne "Ready"
    ) {

        throw "New Test Case $localTestCaseId did not change to Ready."
    }

    Write-Host "Test Case metadata updated."
    Write-Host "State    : $finalTestCaseState"
    Write-Host "Iteration: $iterationPath"
    Write-Host "Tags     : $tags"

    # -----------------------------------------------------
    # Ensure the Test Case remains associated with TS001
    # -----------------------------------------------------

    if ($existingSuiteTestCaseIds -contains $azureTestCaseId) {

        Write-Host "Test Case is already associated with $TestSuiteCode."
    }
    else {

        Write-Host "Adding Test Case to $TestSuiteCode..."

        $addTestCaseUri =
            "https://dev.azure.com/$Org/$Project/_apis/test/Plans/${testPlanId}/suites/${testSuiteId}/testcases/${azureTestCaseId}?api-version=7.1"

        Invoke-RestMethod `
            -Uri $addTestCaseUri `
            -Method Post `
            -Headers $headers |
        Out-Null

        $existingSuiteTestCaseIds +=
            $azureTestCaseId

        Write-Host "Test Case successfully associated with $TestSuiteCode."
    }

    # -----------------------------------------------------
    # Save mapping for later pipeline tasks
    # -----------------------------------------------------

    $testCaseMap +=
        [PSCustomObject]@{
            testCaseId =
                $localTestCaseId

            testCaseName =
                $localTestCaseName

            azureTestCaseId =
                $azureTestCaseId

            state =
                $finalTestCaseState

            azureTitle =
                $azureTitle

            testPlanCode =
                $TestPlanCode

            testSuiteCode =
                $TestSuiteCode

            userStoryCode =
                $UserStoryCode

            azureUserStoryId =
                $userStoryId

            sprintCode =
                $SprintCode

            iterationPath =
                $iterationPath

            tags =
                $tags
        }

    Write-Host ""
    Write-Host "Mapping:"
    Write-Host "$localTestCaseId -> Azure Test Case $azureTestCaseId"
}

# ---------------------------------------------------------
# Validate final mapping
# ---------------------------------------------------------

if ($testCaseMap.Count -ne $loginTests.Count) {

    throw "Expected $($loginTests.Count) Test Case mappings but found $($testCaseMap.Count)."
}

# ---------------------------------------------------------
# Save mapping
# ---------------------------------------------------------

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

New-Item `
    -ItemType Directory `
    -Force `
    -Path $artifactRoot |
Out-Null

$mappingPath =
    Join-Path `
        $artifactRoot `
        "azure-test-case-map.json"

ConvertTo-Json `
    -InputObject @($testCaseMap) `
    -Depth 10 |
Set-Content `
    -Path $mappingPath `
    -Encoding UTF8

# ---------------------------------------------------------
# Final summary
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host "AZURE DEVOPS TEST CASES READY"
Write-Host "============================================================"

foreach ($mapping in $testCaseMap) {

    Write-Host "$($mapping.testCaseId) -> Azure Test Case ID $($mapping.azureTestCaseId)"
}

Write-Host ""
Write-Host "Test Plan  : $TestPlanCode"
Write-Host "Test Suite : $TestSuiteCode"
Write-Host "User Story : $UserStoryCode"
Write-Host "Sprint     : $SprintCode"
Write-Host "Iteration  : $iterationPath"
Write-Host "Total      : $($testCaseMap.Count)"
Write-Host "============================================================"
```

### `scripts/azure-devops/Ensure-TestPlan.ps1`

**Purpose:** Finds or creates TP001 and records its Azure mapping.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$TestPlanCode,

    [Parameter(Mandatory = $true)]
    [string]$UserStoryCode,

    [Parameter(Mandatory = $true)]
    [string]$SprintCode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Retrieve required pipeline/environment values
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

$testPlanName =
    $env:TEST_PLAN_NAME

$iterationPath =
    $env:ITERATION_PATH

$userStoryIdText =
    $env:USER_STORY_ID

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if ([string]::IsNullOrWhiteSpace($testPlanName)) {
    throw "TEST_PLAN_NAME is empty."
}

if ([string]::IsNullOrWhiteSpace($iterationPath)) {
    throw "ITERATION_PATH is empty."
}

if ([string]::IsNullOrWhiteSpace($userStoryIdText)) {
    throw "USER_STORY_ID is empty."
}

$userStoryId =
    [int]$userStoryIdText

# ---------------------------------------------------------
# Authentication
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

$patchHeaders = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json-patch+json"
}

# ---------------------------------------------------------
# Desired Test Plan metadata
# ---------------------------------------------------------

$tags =
    "$TestPlanCode; $UserStoryCode; $SprintCode; Automation"

$description =
    @"
<p><strong>FSWEP Login Test Plan</strong></p>

<p>
Automated regression Test Plan for the FSWEP Selenium/TestNG
login testing training project.
</p>

<p><strong>Traceability</strong></p>
<p>
Test Plan Code: $TestPlanCode<br/>
User Story: $UserStoryCode<br/>
Sprint Code: $SprintCode<br/>
Iteration: $iterationPath
</p>
"@

Write-Host ""
Write-Host "============================================================"
Write-Host "CHECKING AZURE DEVOPS TEST PLAN"
Write-Host "============================================================"
Write-Host "Organization     : $Org"
Write-Host "Project          : $Project"
Write-Host "Test Plan Code   : $TestPlanCode"
Write-Host "Target Name      : $testPlanName"
Write-Host "Iteration        : $iterationPath"
Write-Host "User Story Code  : $UserStoryCode"
Write-Host "User Story ID    : $userStoryId"
Write-Host "Tags             : $tags"
Write-Host ""

# ---------------------------------------------------------
# Retrieve existing Test Plans
# ---------------------------------------------------------

$plansUri =
    "https://dev.azure.com/$Org/$Project/_apis/testplan/plans?api-version=7.1"

$plansResponse =
    Invoke-RestMethod `
        -Uri $plansUri `
        -Method Get `
        -Headers $headers

$plans =
    @($plansResponse.value)

Write-Host "Existing Test Plans found: $($plans.Count)"

# ---------------------------------------------------------
# Look for our new coded title
# ---------------------------------------------------------

$targetMatches =
    @(
        $plans |
            Where-Object {
                $_.name -eq $testPlanName
            }
    )

if ($targetMatches.Count -gt 1) {
    throw "More than one Test Plan named '$testPlanName' exists."
}

# ---------------------------------------------------------
# Reuse existing TP001 Test Plan
# ---------------------------------------------------------

if ($targetMatches.Count -eq 1) {

    $testPlan =
        $targetMatches[0]

    Write-Host ""
    Write-Host "Existing TP001 Test Plan found."
    Write-Host "No new Test Plan will be created."
}

# ---------------------------------------------------------
# Otherwise create TP001
# ---------------------------------------------------------

else {

    Write-Host ""
    Write-Host "Test Plan does not exist."
    Write-Host "Creating TP001..."

    $createPlanBody = @{
        name =
            $testPlanName

        areaPath =
            $Project

        iteration =
            $iterationPath

        description =
            $description
    } | ConvertTo-Json -Depth 10

    $testPlan =
        Invoke-RestMethod `
            -Uri $plansUri `
            -Method Post `
            -Headers $headers `
            -Body $createPlanBody

    if (-not $testPlan.id) {
        throw "Azure DevOps did not return a Test Plan ID."
    }

    Write-Host "Test Plan created."
}

$testPlanId =
    [int]$testPlan.id

Write-Host ""
Write-Host "Test Plan ID: $testPlanId"

# ---------------------------------------------------------
# Retrieve current Test Plan details.
#
# We use the current revision when updating the Test Plan.
# ---------------------------------------------------------

$planUri =
    "https://dev.azure.com/$Org/$Project/_apis/testplan/plans/${testPlanId}?api-version=7.1"

$currentPlan =
    Invoke-RestMethod `
        -Uri $planUri `
        -Method Get `
        -Headers $headers

if (-not $currentPlan.revision) {
    throw "Azure DevOps did not return the Test Plan revision."
}

$currentRevision =
    [int]$currentPlan.revision

# ---------------------------------------------------------
# Update Test Plan object:
#
# - coded title
# - Sprint 001
# - description
#
# Most importantly, this updates the EXISTING plan ID rather
# than creating another Test Plan.
# ---------------------------------------------------------

$updatePlanBody = @{
    revision =
        $currentRevision

    name =
        $testPlanName

    areaPath =
        $Project

    iteration =
        $iterationPath

    description =
        $description
} | ConvertTo-Json -Depth 10

$updatedPlan =
    Invoke-RestMethod `
        -Uri $planUri `
        -Method Patch `
        -Headers $headers `
        -Body $updatePlanBody

Write-Host ""
Write-Host "Test Plan metadata updated."
Write-Host "Name      : $($updatedPlan.name)"
Write-Host "Iteration : $($updatedPlan.iteration)"

# ---------------------------------------------------------
# Retrieve the Test Plan work item.
#
# Your Azure DevOps environment exposes Test Plans through
# the work item form. We validate the type before changing
# tags or relations.
# ---------------------------------------------------------

$workItemUri =
    "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/${testPlanId}?`$expand=Relations&api-version=7.1"

$testPlanWorkItem =
    Invoke-RestMethod `
        -Uri $workItemUri `
        -Method Get `
        -Headers $headers

$workItemTypeProperty =
    $testPlanWorkItem.fields.PSObject.Properties["System.WorkItemType"]

if ($null -eq $workItemTypeProperty) {
    throw "Azure DevOps did not return System.WorkItemType for Test Plan $testPlanId."
}

$workItemType =
    [string]$workItemTypeProperty.Value

if ($workItemType -ne "Test Plan") {

    throw "Work item $testPlanId is '$workItemType' instead of 'Test Plan'."
}

Write-Host ""
Write-Host "Verified Test Plan work item."
Write-Host "Work Item ID   : $testPlanId"
Write-Host "Work Item Type : $workItemType"

# ---------------------------------------------------------
# Build work item updates
# ---------------------------------------------------------

$workItemOperations =
    @(
        @{
            op =
                "add"

            path =
                "/fields/System.Title"

            value =
                $testPlanName
        },

        @{
            op =
                "add"

            path =
                "/fields/System.IterationPath"

            value =
                $iterationPath
        },

        @{
            op =
                "add"

            path =
                "/fields/System.Tags"

            value =
                $tags
        },

        @{
            op =
                "add"

            path =
                "/fields/System.Description"

            value =
                $description
        }
    )

# ---------------------------------------------------------
# Check whether TP001 is already related to US001
# ---------------------------------------------------------

$relations =
    @()

$relationsProperty =
    $testPlanWorkItem.PSObject.Properties["relations"]

if ($null -ne $relationsProperty) {

    $relations =
        @($relationsProperty.Value)
}

$existingUserStoryLinks =
    @(
        $relations |
            Where-Object {

                $_.rel -eq "System.LinkTypes.Related" -and
                [string]$_.url -match "/workItems/$userStoryId$"
            }
    )

if ($existingUserStoryLinks.Count -eq 0) {

    Write-Host ""
    Write-Host "US001 relationship does not exist."
    Write-Host "Adding Related link to User Story $userStoryId..."

    $userStoryUrl =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workItems/$userStoryId"

    $workItemOperations +=
        @{
            op =
                "add"

            path =
                "/relations/-"

            value =
                @{
                    rel =
                        "System.LinkTypes.Related"

                    url =
                        $userStoryUrl

                    attributes =
                        @{
                            comment =
                                "Traceability link from $TestPlanCode to $UserStoryCode."
                        }
                }
        }
}
else {

    Write-Host ""
    Write-Host "TP001 is already related to US001."
    Write-Host "No duplicate User Story link will be created."
}

# ---------------------------------------------------------
# Apply Work Item fields, tags, and relation
# ---------------------------------------------------------

$workItemBody =
    ConvertTo-Json `
        -InputObject $workItemOperations `
        -Depth 20

Invoke-RestMethod `
    -Uri $workItemUri `
    -Method Patch `
    -Headers $patchHeaders `
    -Body $workItemBody |
Out-Null

Write-Host ""
Write-Host "Test Plan work item metadata updated."

# ---------------------------------------------------------
# Preserve Test Plan ID for downstream tasks
# ---------------------------------------------------------

Write-Host "##vso[task.setvariable variable=TEST_PLAN_ID]$testPlanId"

# ---------------------------------------------------------
# Save traceability map
# ---------------------------------------------------------

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

New-Item `
    -ItemType Directory `
    -Force `
    -Path $artifactRoot |
Out-Null

$testPlanMap =
    [PSCustomObject]@{
        testPlanCode =
            $TestPlanCode

        testPlanName =
            $testPlanName

        azureTestPlanId =
            $testPlanId

        userStoryCode =
            $UserStoryCode

        azureUserStoryId =
            $userStoryId

        sprintCode =
            $SprintCode

        iterationPath =
            $iterationPath

        tags =
            $tags
    }

$testPlanMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-plan-map.json"

$testPlanMap |
    ConvertTo-Json -Depth 10 |
    Set-Content `
        -Path $testPlanMapPath `
        -Encoding UTF8

# ---------------------------------------------------------
# Final summary
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host "TEST PLAN READY"
Write-Host "============================================================"
Write-Host "Code          : $TestPlanCode"
Write-Host "Test Plan ID  : $testPlanId"
Write-Host "Title         : $testPlanName"
Write-Host "Iteration     : $iterationPath"
Write-Host "Tags          : $tags"
Write-Host "User Story    : $UserStoryCode ($userStoryId)"
Write-Host "============================================================"
```

### `scripts/azure-devops/Ensure-TestSuite.ps1`

**Purpose:** Finds or creates TS001 and links it into the training test-management structure.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$TestPlanCode,

    [Parameter(Mandatory = $true)]
    [string]$TestSuiteCode,

    [Parameter(Mandatory = $true)]
    [string]$UserStoryCode,

    [Parameter(Mandatory = $true)]
    [string]$SprintCode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Retrieve required environment values
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

$testPlanIdText =
    $env:TEST_PLAN_ID

$testSuiteName =
    $env:TEST_SUITE_NAME

$iterationPath =
    $env:ITERATION_PATH

$userStoryIdText =
    $env:USER_STORY_ID

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if ([string]::IsNullOrWhiteSpace($testPlanIdText)) {
    throw "TEST_PLAN_ID is empty."
}

if ([string]::IsNullOrWhiteSpace($testSuiteName)) {
    throw "TEST_SUITE_NAME is empty."
}

if ([string]::IsNullOrWhiteSpace($iterationPath)) {
    throw "ITERATION_PATH is empty."
}

if ([string]::IsNullOrWhiteSpace($userStoryIdText)) {
    throw "USER_STORY_ID is empty."
}

$testPlanId =
    [int]$testPlanIdText

$userStoryId =
    [int]$userStoryIdText

# ---------------------------------------------------------
# Authentication
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

$patchHeaders = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json-patch+json"
}

# ---------------------------------------------------------
# Desired metadata
# ---------------------------------------------------------

$tags =
    "$TestPlanCode; $TestSuiteCode; $UserStoryCode; $SprintCode; Automation"

$description =
    @"
<p><strong>FSWEP Login Test Suite</strong></p>

<p>
Automated regression Test Suite for the FSWEP Selenium/TestNG
login testing training project.
</p>

<p><strong>Traceability</strong></p>

<p>
Test Plan: $TestPlanCode<br/>
Test Suite: $TestSuiteCode<br/>
User Story: $UserStoryCode<br/>
Sprint Code: $SprintCode<br/>
Iteration: $iterationPath
</p>
"@

Write-Host ""
Write-Host "============================================================"
Write-Host "CHECKING AZURE DEVOPS TEST SUITE"
Write-Host "============================================================"
Write-Host "Organization      : $Org"
Write-Host "Project           : $Project"
Write-Host "Test Plan         : $TestPlanCode ($testPlanId)"
Write-Host "Test Suite Code   : $TestSuiteCode"
Write-Host "Target Name       : $testSuiteName"
Write-Host "Iteration         : $iterationPath"
Write-Host "User Story        : $UserStoryCode ($userStoryId)"
Write-Host "Tags              : $tags"
Write-Host ""

# ---------------------------------------------------------
# Retrieve Test Plan and Root Suite
# ---------------------------------------------------------

$planUri =
    "https://dev.azure.com/$Org/$Project/_apis/testplan/plans/${testPlanId}?api-version=7.1"

$planResponse =
    Invoke-RestMethod `
        -Uri $planUri `
        -Method Get `
        -Headers $headers

$rootSuiteProperty =
    $planResponse.PSObject.Properties["rootSuite"]

if ($null -eq $rootSuiteProperty) {
    throw "Azure DevOps did not return the Test Plan Root Suite."
}

if (-not $planResponse.rootSuite.id) {
    throw "Azure DevOps did not return the Root Suite ID."
}

$rootSuiteId =
    [int]$planResponse.rootSuite.id

Write-Host "Root Suite ID: $rootSuiteId"

# ---------------------------------------------------------
# Retrieve Test Suites belonging to the Test Plan
# ---------------------------------------------------------

$suitesUri =
    "https://dev.azure.com/$Org/$Project/_apis/testplan/plans/${testPlanId}/suites?api-version=7.1"

$suitesResponse =
    Invoke-RestMethod `
        -Uri $suitesUri `
        -Method Get `
        -Headers $headers

$suites =
    @($suitesResponse.value)

Write-Host "Suites found in Test Plan: $($suites.Count)"

# ---------------------------------------------------------
# Look for the NEW coded child Suite
# ---------------------------------------------------------

$targetMatches =
    @(
        $suites |
            Where-Object {

                $parentProperty =
                    $_.PSObject.Properties["parentSuite"]

                if ($null -eq $parentProperty) {
                    return $false
                }

                $_.name -eq $testSuiteName -and
                [int]$_.parentSuite.id -eq $rootSuiteId
            }
    )

if ($targetMatches.Count -gt 1) {
    throw "More than one child Test Suite named '$testSuiteName' exists."
}

# ---------------------------------------------------------
# Reuse existing TS001 Test Suite
# ---------------------------------------------------------

if ($targetMatches.Count -eq 1) {

    $testSuite =
        $targetMatches[0]

    Write-Host ""
    Write-Host "Existing TS001 Test Suite found."
    Write-Host "No new Test Suite will be created."
}

# ---------------------------------------------------------
# Otherwise create a new child Suite
# ---------------------------------------------------------

else {

    Write-Host ""
    Write-Host "Test Suite does not exist."
    Write-Host "Creating TS001..."

    $createSuiteBody = @{
        suiteType =
            "staticTestSuite"

        name =
            $testSuiteName

        parentSuite =
            @{
                id =
                    $rootSuiteId
            }

        inheritDefaultConfigurations =
            $true
    } | ConvertTo-Json -Depth 10

    $testSuite =
        Invoke-RestMethod `
            -Uri $suitesUri `
            -Method Post `
            -Headers $headers `
            -Body $createSuiteBody

    if (-not $testSuite.id) {
        throw "Azure DevOps did not return a Test Suite ID."
    }

    Write-Host "New Test Suite created."
}

$testSuiteId =
    [int]$testSuite.id

Write-Host ""
Write-Host "Test Suite ID: $testSuiteId"

# ---------------------------------------------------------
# Retrieve current Suite details
#
# We need the current revision when updating the Suite.
# ---------------------------------------------------------

$suiteUri =
    "https://dev.azure.com/$Org/$Project/_apis/testplan/Plans/${testPlanId}/suites/${testSuiteId}?api-version=7.1"

$currentSuite =
    Invoke-RestMethod `
        -Uri $suiteUri `
        -Method Get `
        -Headers $headers

if (-not $currentSuite.revision) {
    throw "Azure DevOps did not return the Test Suite revision."
}

$currentRevision =
    [int]$currentSuite.revision

# ---------------------------------------------------------
# Update Test Suite through Test Plan API
#
# This changes the child Suite name while preserving:
#
# - Suite ID
# - Parent Suite
# - Test Cases
# - Test Points
# ---------------------------------------------------------

$updateSuiteBody = @{
    revision =
        $currentRevision

    name =
        $testSuiteName
} | ConvertTo-Json -Depth 10

$updatedSuite =
    Invoke-RestMethod `
        -Uri $suiteUri `
        -Method Patch `
        -Headers $headers `
        -Body $updateSuiteBody

Write-Host ""
Write-Host "Test Suite metadata updated."
Write-Host "Suite ID : $($updatedSuite.id)"
Write-Host "Name     : $($updatedSuite.name)"

# ---------------------------------------------------------
# Retrieve corresponding Test Suite work item
#
# Your Azure environment exposes Test Suites through Boards,
# so we validate the work-item type before changing fields.
# ---------------------------------------------------------

$workItemUri =
    "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/${testSuiteId}?`$expand=Relations&api-version=7.1"

$testSuiteWorkItem =
    Invoke-RestMethod `
        -Uri $workItemUri `
        -Method Get `
        -Headers $headers

$workItemTypeProperty =
    $testSuiteWorkItem.fields.PSObject.Properties["System.WorkItemType"]

if ($null -eq $workItemTypeProperty) {
    throw "Azure DevOps did not return System.WorkItemType for Test Suite $testSuiteId."
}

$workItemType =
    [string]$workItemTypeProperty.Value

if ($workItemType -ne "Test Suite") {

    throw "Work item $testSuiteId is '$workItemType' instead of 'Test Suite'."
}

Write-Host ""
Write-Host "Verified Test Suite work item."
Write-Host "Work Item ID   : $testSuiteId"
Write-Host "Work Item Type : $workItemType"

# ---------------------------------------------------------
# Work Item metadata
# ---------------------------------------------------------

$workItemOperations =
    @(
        @{
            op =
                "add"

            path =
                "/fields/System.Title"

            value =
                $testSuiteName
        },

        @{
            op =
                "add"

            path =
                "/fields/System.AreaPath"

            value =
                $Project
        },

        @{
            op =
                "add"

            path =
                "/fields/System.IterationPath"

            value =
                $iterationPath
        },

        @{
            op =
                "add"

            path =
                "/fields/System.Tags"

            value =
                $tags
        },

        @{
            op =
                "add"

            path =
                "/fields/System.Description"

            value =
                $description
        }
    )

# ---------------------------------------------------------
# Determine whether TS001 is already Related to US001
# ---------------------------------------------------------

$relations =
    @()

$relationsProperty =
    $testSuiteWorkItem.PSObject.Properties["relations"]

if ($null -ne $relationsProperty) {

    $relations =
        @($relationsProperty.Value)
}

$existingUserStoryLinks =
    @(
        $relations |
            Where-Object {

                $_.rel -eq "System.LinkTypes.Related" -and
                [string]$_.url -match "/workItems/$userStoryId$"
            }
    )

if ($existingUserStoryLinks.Count -eq 0) {

    Write-Host ""
    Write-Host "US001 relationship does not exist."
    Write-Host "Adding Related link to User Story $userStoryId..."

    $userStoryUrl =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workItems/$userStoryId"

    $workItemOperations +=
        @{
            op =
                "add"

            path =
                "/relations/-"

            value =
                @{
                    rel =
                        "System.LinkTypes.Related"

                    url =
                        $userStoryUrl

                    attributes =
                        @{
                            comment =
                                "Traceability link from $TestSuiteCode to $UserStoryCode."
                        }
                }
        }
}
else {

    Write-Host ""
    Write-Host "TS001 is already related to US001."
    Write-Host "No duplicate User Story link will be created."
}

# ---------------------------------------------------------
# Apply Work Item changes
# ---------------------------------------------------------

$workItemBody =
    ConvertTo-Json `
        -InputObject $workItemOperations `
        -Depth 20

Invoke-RestMethod `
    -Uri $workItemUri `
    -Method Patch `
    -Headers $patchHeaders `
    -Body $workItemBody |
Out-Null

Write-Host ""
Write-Host "Test Suite work item metadata updated."

# ---------------------------------------------------------
# Preserve Test Suite ID for downstream pipeline tasks
# ---------------------------------------------------------

Write-Host "##vso[task.setvariable variable=TEST_SUITE_ID]$testSuiteId"

# ---------------------------------------------------------
# Save traceability mapping
# ---------------------------------------------------------

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

New-Item `
    -ItemType Directory `
    -Force `
    -Path $artifactRoot |
Out-Null

$testSuiteMap =
    [PSCustomObject]@{
        testPlanCode =
            $TestPlanCode

        azureTestPlanId =
            $testPlanId

        testSuiteCode =
            $TestSuiteCode

        testSuiteName =
            $testSuiteName

        azureTestSuiteId =
            $testSuiteId

        rootSuiteId =
            $rootSuiteId

        userStoryCode =
            $UserStoryCode

        azureUserStoryId =
            $userStoryId

        sprintCode =
            $SprintCode

        iterationPath =
            $iterationPath

        tags =
            $tags
    }

$testSuiteMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-suite-map.json"

$testSuiteMap |
    ConvertTo-Json -Depth 10 |
    Set-Content `
        -Path $testSuiteMapPath `
        -Encoding UTF8

# ---------------------------------------------------------
# Final summary
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host "TEST SUITE READY"
Write-Host "============================================================"
Write-Host "Test Plan       : $TestPlanCode ($testPlanId)"
Write-Host "Suite Code      : $TestSuiteCode"
Write-Host "Suite ID        : $testSuiteId"
Write-Host "Title           : $testSuiteName"
Write-Host "Iteration       : $iterationPath"
Write-Host "Tags            : $tags"
Write-Host "User Story      : $UserStoryCode ($userStoryId)"
Write-Host "Root Suite ID   : $rootSuiteId"
Write-Host "============================================================"
```

### `scripts/azure-devops/Ensure-UserStory.ps1`

**Purpose:** Finds or creates US001 and establishes the initial Resolved state only when newly created.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$UserStoryCode,

    [Parameter(Mandatory = $true)]
    [string]$SprintCode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Retrieve pipeline/environment values
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

$userStoryTitle =
    $env:USER_STORY_TITLE

$iterationPath =
    $env:ITERATION_PATH

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if (
    $token -eq '$(AZURE_PAT)' -or
    $token -match '^\$\([^)]+\)$'
) {
    throw "AZURE_PAT was not expanded."
}

if ([string]::IsNullOrWhiteSpace($userStoryTitle)) {
    throw "USER_STORY_TITLE is empty."
}

if ([string]::IsNullOrWhiteSpace($iterationPath)) {
    throw "ITERATION_PATH is empty."
}

# ---------------------------------------------------------
# Authentication
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

$patchHeaders = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json-patch+json"
}

Write-Host ""
Write-Host "============================================================"
Write-Host "CHECKING AZURE DEVOPS USER STORY"
Write-Host "============================================================"
Write-Host "Organization   : $Org"
Write-Host "Project        : $Project"
Write-Host "User Story Code: $UserStoryCode"
Write-Host "Title          : $userStoryTitle"
Write-Host "Sprint Code    : $SprintCode"
Write-Host "Iteration      : $iterationPath"
Write-Host ""

# ---------------------------------------------------------
# User Story content
#
# TRAINING NOTE:
# The pipeline creates this User Story only so the training
# project can demonstrate full Agile traceability.
# ---------------------------------------------------------

$description =
    @"
<p>
<strong>Training User Story</strong>
</p>

<p>
As an authorized FSWEP user,
I want to log in using my credentials,
so that I can access the FSWEP application.
</p>

<p>
This User Story is created automatically for this training
project so that Azure DevOps requirements-to-test traceability
can be demonstrated.
</p>
"@

$acceptanceCriteria =
    @"
<ul>
<li>Valid credentials allow the authorized user to log in successfully.</li>
<li>An invalid password prevents login and displays the expected validation message.</li>
<li>A blank username prevents login and displays the appropriate validation response.</li>
<li>A blank password prevents login and displays the appropriate validation response.</li>
<li>A blank username and password prevent login and display the appropriate validation response.</li>
</ul>
"@

$tags =
    "$UserStoryCode; $SprintCode; Automation"

# ---------------------------------------------------------
# Search for the User Story by exact title
# ---------------------------------------------------------

$escapedProject =
    $Project.Replace(
        "'",
        "''"
    )

$escapedTitle =
    $userStoryTitle.Replace(
        "'",
        "''"
    )

$wiql =
    "SELECT [System.Id], [System.Title] " +
    "FROM WorkItems " +
    "WHERE [System.TeamProject] = '$escapedProject' " +
    "AND [System.WorkItemType] = 'User Story' " +
    "AND [System.Title] = '$escapedTitle'"

$wiqlBody = @{
    query =
        $wiql
} | ConvertTo-Json -Depth 10

$wiqlUri =
    "https://dev.azure.com/$Org/$Project/_apis/wit/wiql?api-version=7.1"

$wiqlResponse =
    Invoke-RestMethod `
        -Uri $wiqlUri `
        -Method Post `
        -Headers $headers `
        -Body $wiqlBody

$matchingStories =
    @($wiqlResponse.workItems)

# ---------------------------------------------------------
# Protect against accidental duplicates
# ---------------------------------------------------------

if ($matchingStories.Count -gt 1) {

    Write-Host "Duplicate User Stories were found."

    foreach ($duplicateStory in $matchingStories) {
        Write-Host "User Story ID: $($duplicateStory.id)"
    }

    throw "More than one User Story named '$userStoryTitle' exists."
}

# ---------------------------------------------------------
# Existing User Story:
# reuse it and ensure metadata remains correct.
# ---------------------------------------------------------

# ---------------------------------------------------------
# Track whether this pipeline created the User Story.
#
# Existing User Stories keep their current lifecycle state.
# A newly created training User Story will be moved to
# Resolved because this project begins at the active
# acceptance-testing stage.
# ---------------------------------------------------------

$userStoryWasCreated =
    $false

if ($matchingStories.Count -eq 1) {

    $userStoryId =
        [int]$matchingStories[0].id

    Write-Host "Existing User Story found."
    Write-Host "User Story ID: $userStoryId"
    Write-Host "No duplicate User Story will be created."

    $updateOperations =
        @(
            @{
                op = "add"
                path = "/fields/System.IterationPath"
                value = $iterationPath
            },
            @{
                op = "add"
                path = "/fields/System.Tags"
                value = $tags
            },
            @{
                op = "add"
                path = "/fields/System.Description"
                value = $description
            },
            @{
                op = "add"
                path = "/fields/Microsoft.VSTS.Common.AcceptanceCriteria"
                value = $acceptanceCriteria
            }
        )

    $updateBody =
        ConvertTo-Json `
            -InputObject $updateOperations `
            -Depth 20

    $updateUri =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/${userStoryId}?api-version=7.1"

    Invoke-RestMethod `
        -Uri $updateUri `
        -Method Patch `
        -Headers $patchHeaders `
        -Body $updateBody |
    Out-Null

    Write-Host "Existing User Story metadata updated."
}

# ---------------------------------------------------------
# Otherwise create US001
# ---------------------------------------------------------

else {

    $userStoryWasCreated =
            $true

    Write-Host "User Story does not exist."
    Write-Host "Creating User Story..."

    $createOperations =
        @(
            @{
                op = "add"
                path = "/fields/System.Title"
                value = $userStoryTitle
            },
            @{
                op = "add"
                path = "/fields/System.AreaPath"
                value = $Project
            },
            @{
                op = "add"
                path = "/fields/System.IterationPath"
                value = $iterationPath
            },
            @{
                op = "add"
                path = "/fields/System.Tags"
                value = $tags
            },
            @{
                op = "add"
                path = "/fields/System.Description"
                value = $description
            },
            @{
                op = "add"
                path = "/fields/Microsoft.VSTS.Common.AcceptanceCriteria"
                value = $acceptanceCriteria
            }
        )

    $createBody =
        ConvertTo-Json `
            -InputObject $createOperations `
            -Depth 20

    $createUri =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/`$User%20Story?api-version=7.1"

    $userStoryResponse =
        Invoke-RestMethod `
            -Uri $createUri `
            -Method Post `
            -Headers $patchHeaders `
            -Body $createBody

    if (-not $userStoryResponse.id) {
        throw "Azure DevOps did not return a User Story Work Item ID."
    }

    $userStoryId =
        [int]$userStoryResponse.id

    Write-Host "New User Story successfully created."
    Write-Host "User Story ID: $userStoryId"
}

# ---------------------------------------------------------
# Establish the initial active-testing state.
#
# Training workflow:
#
# New User Story
#       ↓
# Resolved
#
# Resolved means implementation is complete and the
# User Story is awaiting acceptance / verification.
#
# IMPORTANT:
# Existing User Stories keep their current state.
# This prevents a later pipeline from changing a Closed
# User Story back to Resolved.
# ---------------------------------------------------------

$userStoryStateUri =
    "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/${userStoryId}?api-version=7.1"

$userStoryWorkItem =
    Invoke-RestMethod `
        -Uri $userStoryStateUri `
        -Method Get `
        -Headers $headers

$currentUserStoryState =
    [string]$userStoryWorkItem.fields.'System.State'

Write-Host ""
Write-Host "User Story current state: $currentUserStoryState"

if ($userStoryWasCreated) {

    if ($currentUserStoryState -ne "Resolved") {

        Write-Host "New training User Story will be moved to Resolved."

        $stateOperations =
            @(
                @{
                    op =
                        "replace"

                    path =
                        "/fields/System.State"

                    value =
                        "Resolved"
                }
            )

        $stateBody =
            ConvertTo-Json `
                -InputObject $stateOperations `
                -Depth 20

        $stateResponse =
            Invoke-RestMethod `
                -Uri $userStoryStateUri `
                -Method Patch `
                -Headers $patchHeaders `
                -Body $stateBody

        $currentUserStoryState =
            [string]$stateResponse.fields.'System.State'

        if ($currentUserStoryState -ne "Resolved") {

            throw "New User Story $UserStoryCode did not change to Resolved."
        }

        Write-Host "User Story state changed: New -> Resolved"
    }
}
else {

    Write-Host "Existing User Story state preserved: $currentUserStoryState"
}

# ---------------------------------------------------------
# Store ID for later pipeline tasks
# ---------------------------------------------------------

Write-Host "##vso[task.setvariable variable=USER_STORY_ID]$userStoryId"

# ---------------------------------------------------------
# Save mapping information
# ---------------------------------------------------------

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

New-Item `
    -ItemType Directory `
    -Force `
    -Path $artifactRoot |
Out-Null

$userStoryMap =
    [PSCustomObject]@{
        userStoryCode =
            $UserStoryCode

        userStoryTitle =
            $userStoryTitle

        azureUserStoryId =
            $userStoryId

        state =
            $currentUserStoryState

        sprintCode =
            $SprintCode

        iterationPath =
            $iterationPath

        tags =
            $tags
    }

$userStoryMapPath =
    Join-Path `
        $artifactRoot `
        "azure-user-story-map.json"

$userStoryMap |
    ConvertTo-Json -Depth 10 |
    Set-Content `
        -Path $userStoryMapPath `
        -Encoding UTF8

Write-Host ""
Write-Host "============================================================"
Write-Host "USER STORY READY"
Write-Host "============================================================"
Write-Host "Code          : $UserStoryCode"
Write-Host "User Story ID : $userStoryId"
Write-Host "Title         : $userStoryTitle"
Write-Host "State         : $currentUserStoryState"
Write-Host "Iteration     : $iterationPath"
Write-Host "Tags          : $tags"
Write-Host "============================================================"
```

### `scripts/azure-devops/Find-Resolved-Automation-Bugs.ps1`

**Purpose:** Discovers qualifying Resolved automation Bugs, follows their Related Test Case relationships, and builds the selective retest queue.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$BugCodePrefix,

    [Parameter(Mandatory = $true)]
    [string]$TestPlanCode,

    [Parameter(Mandatory = $true)]
    [string]$TestSuiteCode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Required pipeline/environment values
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if (
    $token -eq '$(AZURE_PAT)' -or
    $token -match '^\$\([^)]+\)$'
) {
    throw "AZURE_PAT was not expanded. Configure the AZURE_PAT secret variable for this pipeline."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

# ---------------------------------------------------------
# Authentication
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

# ---------------------------------------------------------
# Evidence path
# ---------------------------------------------------------

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

New-Item `
    -ItemType Directory `
    -Force `
    -Path $artifactRoot |
Out-Null

$retestQueueMapPath =
    Join-Path `
        $artifactRoot `
        "azure-retest-queue-map.json"

# ---------------------------------------------------------
# Find Resolved Automation Bugs belonging to TP001 / TS001
# ---------------------------------------------------------

$escapedProject =
    $Project.Replace(
        "'",
        "''"
    )

$escapedTestPlanCode =
    $TestPlanCode.Replace(
        "'",
        "''"
    )

$escapedTestSuiteCode =
    $TestSuiteCode.Replace(
        "'",
        "''"
    )

$wiql =
    "SELECT [System.Id] " +
    "FROM WorkItems " +
    "WHERE [System.TeamProject] = '$escapedProject' " +
    "AND [System.WorkItemType] = 'Bug'"

$wiqlBody = @{
    query =
        $wiql
} | ConvertTo-Json -Depth 10

$wiqlUri =
    "https://dev.azure.com/$Org/$Project/_apis/wit/wiql?api-version=7.1"

$wiqlResponse =
    Invoke-RestMethod `
        -Uri $wiqlUri `
        -Method Post `
        -Headers $headers `
        -Body $wiqlBody

$workItemsProperty =
    $wiqlResponse.PSObject.Properties["workItems"]

if ($null -eq $workItemsProperty) {
    throw "Azure DevOps WIQL did not return the expected workItems collection."
}

$bugReferences =
    @($workItemsProperty.Value)

Write-Host ""
Write-Host "============================================================"
Write-Host "SEARCHING FOR RESOLVED AUTOMATION BUGS"
Write-Host "============================================================"
Write-Host "Project          : $Project"
Write-Host "Test Plan        : $TestPlanCode"
Write-Host "Test Suite       : $TestSuiteCode"
Write-Host "Bug Work Items   : $($bugReferences.Count)"
Write-Host ""

# ---------------------------------------------------------
# Resolve each Bug to its related Test Case
# ---------------------------------------------------------

$retestQueue =
    @()

$escapedBugPrefix =
    [regex]::Escape(
        $BugCodePrefix
    )

foreach ($bugReference in $bugReferences) {

    $bugId =
        [int]$bugReference.id

    $bugUri =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/${bugId}?`$expand=Relations&api-version=7.1"

    $bug =
        Invoke-RestMethod `
            -Uri $bugUri `
            -Method Get `
            -Headers $headers

    $bugTitle =
        [string]$bug.fields.'System.Title'

    $bugState =
        [string]$bug.fields.'System.State'

    Write-Host ""
    Write-Host "Inspecting Bug $bugId - State: $bugState"

    # -----------------------------------------------------
    # Only Resolved Bugs are eligible for retesting.
    # -----------------------------------------------------

    if ($bugState -ne "Resolved") {

        Write-Host "Skipping Bug $bugId because its state is '$bugState'."

        continue
    }

    # -----------------------------------------------------
    # Read Bug tags
    # -----------------------------------------------------

    $bugTagsText =
        ""

    $tagsProperty =
        $bug.fields.PSObject.Properties["System.Tags"]

    if ($null -ne $tagsProperty) {

        $bugTagsText =
            [string]$tagsProperty.Value
    }

    $bugTags =
        @(
            $bugTagsText.Split(";") |
                ForEach-Object {
                    $_.Trim()
                } |
                Where-Object {
                    -not [string]::IsNullOrWhiteSpace($_)
                }
        )

    # -----------------------------------------------------
    # First determine whether this Resolved Bug belongs
    # to our automated Test Plan / Test Suite workflow.
    #
    # Unrelated Resolved Bugs must be ignored rather than
    # forced to follow this project's BGxxx convention.
    # -----------------------------------------------------

    if (
        $bugTags -notcontains "Automation" -or
        $bugTags -notcontains $TestPlanCode -or
        $bugTags -notcontains $TestSuiteCode
    ) {

        Write-Host ""
        Write-Host "Skipping Resolved Bug $bugId."
        Write-Host "It does not belong to the $TestPlanCode / $TestSuiteCode automation workflow."

        continue
    }

    # -----------------------------------------------------
    # This Bug belongs to our automation workflow.
    # It must therefore follow the BGxxx naming convention.
    # -----------------------------------------------------

    if (
        $bugTitle -notmatch
        "^(${escapedBugPrefix}\d{3}):"
    ) {

        throw "Resolved Automation Bug $bugId does not use the expected ${BugCodePrefix}xxx naming convention."
    }

    $bugCode =
        [string]$Matches[1]

    # -----------------------------------------------------
    # Capture Assigned To for logging/evidence only.
    # Assignment does NOT control eligibility.
    # -----------------------------------------------------

    $assignedTo =
        ""

    $assignedToProperty =
        $bug.fields.PSObject.Properties["System.AssignedTo"]

    if ($null -ne $assignedToProperty) {

        $assignedValue =
            $assignedToProperty.Value

        if ($assignedValue -is [string]) {
            $assignedTo =
                [string]$assignedValue
        }
        elseif ($null -ne $assignedValue) {

            $displayNameProperty =
                $assignedValue.PSObject.Properties["displayName"]

            if ($null -ne $displayNameProperty) {
                $assignedTo =
                    [string]$displayNameProperty.Value
            }
        }
    }

    # -----------------------------------------------------
    # Retrieve Related work-item links.
    # The Bug -> Test Case relationship is authoritative.
    # -----------------------------------------------------

    $relations =
        @()

    $relationsProperty =
        $bug.PSObject.Properties["relations"]

    if ($null -ne $relationsProperty) {
        $relations =
            @($relationsProperty.Value)
    }

    $relatedWorkItemLinks =
        @(
            $relations |
                Where-Object {
                    $_.rel -eq "System.LinkTypes.Related" -and
                    [string]$_.url -match "/workItems/(\d+)$"
                }
        )

    $relatedTestCases =
        @()

    foreach ($relatedLink in $relatedWorkItemLinks) {

        if (
            [string]$relatedLink.url -notmatch
            "/workItems/(\d+)$"
        ) {
            continue
        }

        $relatedWorkItemId =
            [int]$Matches[1]

        $relatedUri =
            "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/${relatedWorkItemId}?api-version=7.1"

        $relatedWorkItem =
            Invoke-RestMethod `
                -Uri $relatedUri `
                -Method Get `
                -Headers $headers

        $workItemType =
            [string]$relatedWorkItem.fields.'System.WorkItemType'

        if ($workItemType -ne "Test Case") {
            continue
        }

        $testCaseTitle =
            [string]$relatedWorkItem.fields.'System.Title'

        if ($testCaseTitle -notmatch "^(TC\d{3}):") {
            throw "Related Test Case $relatedWorkItemId does not use the TCxxx title convention."
        }

        $testCaseId =
            [string]$Matches[1]

        $relatedTestCases +=
            [PSCustomObject]@{
                testCaseId =
                    $testCaseId

                azureTestCaseId =
                    $relatedWorkItemId

                testCaseTitle =
                    $testCaseTitle
            }
    }

    # -----------------------------------------------------
    # Exactly one Test Case must be related to each Bug.
    # Never guess when traceability is ambiguous.
    # -----------------------------------------------------

    if ($relatedTestCases.Count -eq 0) {
        throw "Resolved Bug $bugCode ($bugId) has no Related Test Case."
    }

    if ($relatedTestCases.Count -gt 1) {

        Write-Host ""
        Write-Host "Bug $bugCode is related to more than one Test Case."

        foreach ($relatedTestCase in $relatedTestCases) {
            Write-Host (
                "Test Case: {0} | Azure ID: {1}" -f `
                    $relatedTestCase.testCaseId,
                    $relatedTestCase.azureTestCaseId
            )
        }

        throw "Retest discovery stopped because Bug $bugCode has ambiguous Test Case traceability."
    }

    $relatedTestCase =
        $relatedTestCases[0]

    $testCaseId =
        [string]$relatedTestCase.testCaseId

    # -----------------------------------------------------
    # Validate the Test Case tag as a second safeguard.
    # -----------------------------------------------------

    if ($bugTags -notcontains $testCaseId) {
        throw "Bug $bugCode is related to $testCaseId but does not contain the $testCaseId tag."
    }

    # -----------------------------------------------------
    # Add this Bug/Test Case pair to the retest queue
    # -----------------------------------------------------

    $retestQueue +=
        [PSCustomObject]@{
            bugCode =
                $bugCode

            azureBugId =
                $bugId

            bugTitle =
                $bugTitle

            bugState =
                $bugState

            assignedTo =
                $assignedTo

            testCaseId =
                $testCaseId

            azureTestCaseId =
                [int]$relatedTestCase.azureTestCaseId

            testCaseTitle =
                [string]$relatedTestCase.testCaseTitle
        }

    Write-Host "------------------------------------------------------------"
    Write-Host "BUG READY FOR RETEST"
    Write-Host "------------------------------------------------------------"
    Write-Host "Bug Code          : $bugCode"
    Write-Host "Azure Bug ID      : $bugId"
    Write-Host "State             : $bugState"
    Write-Host "Assigned To       : $assignedTo"
    Write-Host "Test Case         : $testCaseId"
    Write-Host "Azure Test Case ID: $($relatedTestCase.azureTestCaseId)"
    Write-Host ""
}

# ---------------------------------------------------------
# No Resolved Automation Bugs awaiting retest
# ---------------------------------------------------------

if ($retestQueue.Count -eq 0) {

    "[]" |
        Set-Content `
            -Path $retestQueueMapPath `
            -Encoding UTF8

    Write-Host ""
    Write-Host "No Resolved Automation Bugs require retesting."

    Write-Host "##vso[task.setvariable variable=RETEST_REQUIRED]false"
    Write-Host "##vso[task.setvariable variable=RETEST_TEST_CASE_IDS]"

    Write-Host ""
    Write-Host "============================================================"
    Write-Host "RETEST QUEUE EMPTY"
    Write-Host "============================================================"

    return
}

# ---------------------------------------------------------
# Determine unique Test Cases that must be executed.
#
# Two Bugs may theoretically point to the same Test Case.
# The Test Case should execute only once.
# ---------------------------------------------------------

$retestTestCaseIds =
    @(
        $retestQueue.testCaseId |
            Sort-Object -Unique
    )

$retestTestCaseIdText =
    $retestTestCaseIds -join ","

# ---------------------------------------------------------
# Save retest queue evidence
# ---------------------------------------------------------

ConvertTo-Json `
    -InputObject @($retestQueue) `
    -Depth 20 |
Set-Content `
    -Path $retestQueueMapPath `
    -Encoding UTF8

# ---------------------------------------------------------
# Pipeline variables for later retest tasks
# ---------------------------------------------------------

Write-Host "##vso[task.setvariable variable=RETEST_REQUIRED]true"
Write-Host "##vso[task.setvariable variable=RETEST_TEST_CASE_IDS]$retestTestCaseIdText"

Write-Host ""
Write-Host "============================================================"
Write-Host "RETEST QUEUE READY"
Write-Host "============================================================"
Write-Host "Resolved Bugs       : $($retestQueue.Count)"
Write-Host "Unique Test Cases   : $($retestTestCaseIds.Count)"
Write-Host "Test Cases to Retest: $retestTestCaseIdText"
Write-Host "Queue Map           : $retestQueueMapPath"
Write-Host "============================================================"
```

### `scripts/azure-devops/Link-BugToTestResult.ps1`

**Purpose:** Associates regression Bugs with the exact Azure Test Results that exposed the failures.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$token =
    $env:AZURE_PAT

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

$bugMapPath =
    Join-Path `
        $artifactRoot `
        "azure-bug-map.json"

if (-not (Test-Path $bugMapPath)) {
    throw "Bug mapping was not found: $bugMapPath"
}

$parsedBugMap =
    Get-Content `
        -Path $bugMapPath `
        -Raw |
    ConvertFrom-Json

$bugMaps =
    @($parsedBugMap)

if ($bugMaps.Count -eq 0) {

    Write-Host ""
    Write-Host "No Bug mappings exist."
    Write-Host "No Test Result Bug associations are required."

    return
}

Write-Host ""
Write-Host "============================================================"
Write-Host "LINKING BUGS TO FAILED TEST RESULTS"
Write-Host "============================================================"
Write-Host "Bug mappings: $($bugMaps.Count)"

foreach ($bugMap in $bugMaps) {

    $bugId =
        [int]$bugMap.bugId

    $bugCode =
        [string]$bugMap.bugCode

    $testCaseId =
        [string]$bugMap.testCaseId

    $testRunId =
        [int]$bugMap.testRunId

    $azureResultId =
        [int]$bugMap.azureResultId

    Write-Host ""
    Write-Host "------------------------------------------------------------"
    Write-Host "LINKING BUG TO TEST RESULT"
    Write-Host "------------------------------------------------------------"
    Write-Host "Test Case      : $testCaseId"
    Write-Host "Bug            : $bugCode ($bugId)"
    Write-Host "Test Run ID    : $testRunId"
    Write-Host "Test Result ID : $azureResultId"

    $resultUri =
        "https://dev.azure.com/$Org/$Project/_apis/test/Runs/${testRunId}/results/${azureResultId}?detailsToInclude=WorkItems&api-version=7.1"

    $currentResult =
        Invoke-RestMethod `
            -Uri $resultUri `
            -Method Get `
            -Headers $headers

    $existingBugIds =
        @()

    $associatedBugsProperty =
        $currentResult.PSObject.Properties["associatedBugs"]

    if ($null -ne $associatedBugsProperty) {

        $existingBugIds =
            @(
                $associatedBugsProperty.Value |
                    ForEach-Object {
                        [int]$_.id
                    }
            )
    }

    if ($existingBugIds -contains $bugId) {

        Write-Host "$bugCode is already associated with the Test Result."
        continue
    }

    $combinedBugIds =
        @(
            $existingBugIds +
            $bugId |
                Select-Object -Unique
        )

    $associatedBugModels =
        @(
            $combinedBugIds |
                ForEach-Object {
                    @{
                        id =
                            [int]$_
                    }
                }
        )

    $updateModel =
        @{
            id =
                $azureResultId

            associatedBugs =
                $associatedBugModels
        }

    # Important for Windows PowerShell 5.1:
    # Azure expects an ARRAY of TestCaseResult objects.
    $updateBody =
        ConvertTo-Json `
            -InputObject @($updateModel) `
            -Depth 20

    $updateUri =
        "https://dev.azure.com/$Org/$Project/_apis/test/Runs/${testRunId}/results?api-version=7.1"

    Invoke-RestMethod `
        -Uri $updateUri `
        -Method Patch `
        -Headers $headers `
        -Body $updateBody |
    Out-Null

    Write-Host "Bug association submitted."

    # -----------------------------------------------------
    # Azure can take a few seconds before the association
    # appears when the Result is read again.
    # -----------------------------------------------------

    $verified =
        $false

    for ($attempt = 1; $attempt -le 6; $attempt++) {

        Write-Host "Verification attempt $attempt of 6..."

        $verifiedResult =
            Invoke-RestMethod `
                -Uri $resultUri `
                -Method Get `
                -Headers $headers

        $verifiedBugIds =
            @()

        $verifiedAssociatedProperty =
            $verifiedResult.PSObject.Properties["associatedBugs"]

        if ($null -ne $verifiedAssociatedProperty) {

            $verifiedBugIds =
                @(
                    $verifiedAssociatedProperty.Value |
                        ForEach-Object {
                            [int]$_.id
                        }
                )
        }

        if ($verifiedBugIds -contains $bugId) {

            $verified =
                $true

            break
        }

        if ($attempt -lt 6) {

            Write-Host "Association not visible yet."
            Write-Host "Waiting 3 seconds..."

            Start-Sleep -Seconds 3
        }
    }

    if (-not $verified) {

        throw "Bug $bugId was not visible on Test Result $azureResultId after verification retries."
    }

    Write-Host "$bugCode successfully linked to $testCaseId Test Result."
}

Write-Host ""
Write-Host "============================================================"
Write-Host "BUG / TEST RESULT LINKS READY"
Write-Host "============================================================"
```

### `scripts/azure-devops/Link-RetestBugsToTestResults.ps1`

**Purpose:** Associates existing Bugs with the exact RT001 Test Results produced during selective verification.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Required environment values
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if (
    $token -eq '$(AZURE_PAT)' -or
    $token -match '^\$\([^)]+\)$'
) {
    throw "AZURE_PAT was not expanded."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

# ---------------------------------------------------------
# Authentication
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

# ---------------------------------------------------------
# Evidence paths
# ---------------------------------------------------------

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

$retestQueueMapPath =
    Join-Path `
        $artifactRoot `
        "azure-retest-queue-map.json"

$testResultMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-result-map.json"

$linkMapPath =
    Join-Path `
        $artifactRoot `
        "azure-retest-bug-result-link-map.json"

# ---------------------------------------------------------
# Validate required maps
# ---------------------------------------------------------

if (-not (Test-Path $retestQueueMapPath)) {
    throw "Retest queue mapping was not found: $retestQueueMapPath"
}

if (-not (Test-Path $testResultMapPath)) {
    throw "Test Result mapping was not found: $testResultMapPath"
}

# ---------------------------------------------------------
# Read retest queue
# ---------------------------------------------------------

$retestQueue =
    Get-Content `
        -Path $retestQueueMapPath `
        -Raw |
    ConvertFrom-Json

$retestQueue =
    @($retestQueue)

# ---------------------------------------------------------
# Nothing to link
# ---------------------------------------------------------

if ($retestQueue.Count -eq 0) {

    "[]" |
        Set-Content `
            -Path $linkMapPath `
            -Encoding UTF8

    Write-Host ""
    Write-Host "No retest Bugs were found."
    Write-Host "No Bug/Test Result links are required."

    return
}

# ---------------------------------------------------------
# Read Test Result mapping created by
# Update-TestRunResults.ps1
# ---------------------------------------------------------

$testResultMap =
    Get-Content `
        -Path $testResultMapPath `
        -Raw |
    ConvertFrom-Json

$testResultMap =
    @($testResultMap)

if ($testResultMap.Count -eq 0) {
    throw "The Test Result mapping contains no Test Results."
}

Write-Host ""
Write-Host "============================================================"
Write-Host "LINKING RETEST BUGS TO AZURE TEST RESULTS"
Write-Host "============================================================"
Write-Host "Retest Bugs  : $($retestQueue.Count)"
Write-Host "Test Results : $($testResultMap.Count)"
Write-Host ""

# ---------------------------------------------------------
# Multiple Resolved Bugs could theoretically relate to the
# same Test Case.
#
# The Test Case executes once, but every qualifying Bug
# should be associated with that Test Result.
# ---------------------------------------------------------

$testCaseGroups =
    @(
        $retestQueue |
            Group-Object testCaseId
    )

$linkMap =
    @()

foreach ($testCaseGroup in $testCaseGroups) {

    $testCaseId =
        [string]$testCaseGroup.Name

    $bugsForTestCase =
        @($testCaseGroup.Group)

    Write-Host "------------------------------------------------------------"
    Write-Host "PROCESSING RETEST RESULT"
    Write-Host "------------------------------------------------------------"
    Write-Host "Test Case : $testCaseId"

    # -----------------------------------------------------
    # Find exactly one Test Result for this Test Case
    # -----------------------------------------------------

    $matchingResults =
        @(
            $testResultMap |
                Where-Object {
                    $_.testCaseId -eq $testCaseId
                }
        )

    if ($matchingResults.Count -eq 0) {
        throw "No Azure Test Result mapping was found for $testCaseId."
    }

    if ($matchingResults.Count -gt 1) {
        throw "More than one Azure Test Result mapping was found for $testCaseId."
    }

    $testResult =
        $matchingResults[0]

    $testRunId =
        [int]$testResult.testRunId

    $azureResultId =
        [int]$testResult.azureResultId

    $outcome =
        [string]$testResult.outcome

    Write-Host "Test Run ID   : $testRunId"
    Write-Host "Test Result ID: $azureResultId"
    Write-Host "Outcome       : $outcome"

    # -----------------------------------------------------
    # Determine all Bugs that belong to this Test Case
    # -----------------------------------------------------

    $targetBugIds =
        @(
            $bugsForTestCase |
                ForEach-Object {
                    [int]$_.azureBugId
                } |
                Sort-Object -Unique
        )

    if ($targetBugIds.Count -eq 0) {
        throw "No Bugs were mapped to $testCaseId."
    }

    Write-Host ""
    Write-Host "Bugs to associate:"

    foreach ($bug in $bugsForTestCase) {

        Write-Host (
            "  {0} - Azure Bug ID {1}" -f `
                $bug.bugCode,
                $bug.azureBugId
        )
    }

    # -----------------------------------------------------
    # Retrieve the Test Result including existing Work Items
    #
    # We preserve any existing Bug associations instead of
    # blindly replacing them.
    # -----------------------------------------------------

    $resultDetailsUri =
        "https://dev.azure.com/$Org/$Project/_apis/test/Runs/${testRunId}/results/${azureResultId}?detailsToInclude=WorkItems&api-version=7.1"

    $currentResult =
        Invoke-RestMethod `
            -Uri $resultDetailsUri `
            -Method Get `
            -Headers $headers

    $existingBugIds =
        @()

    $associatedBugsProperty =
        $currentResult.PSObject.Properties["associatedBugs"]

    if ($null -ne $associatedBugsProperty) {

        $existingBugReferences =
            @($associatedBugsProperty.Value)

        foreach ($existingBugReference in $existingBugReferences) {

            $idProperty =
                $existingBugReference.PSObject.Properties["id"]

            if ($null -ne $idProperty) {

                $existingBugIds +=
                    [int]$idProperty.Value
            }
        }
    }

    # -----------------------------------------------------
    # Merge existing Bug associations with the Bugs from
    # the retest queue.
    # -----------------------------------------------------

    $mergedBugIds =
        @(
            ($existingBugIds + $targetBugIds) |
                Sort-Object -Unique
        )

    $associatedBugReferences =
        @(
            $mergedBugIds |
                ForEach-Object {

                    @{
                        id =
                            [int]$_
                    }
                }
        )

    # -----------------------------------------------------
    # Update this exact Test Result
    # -----------------------------------------------------

    $update =
        @{
            id =
                $azureResultId

            associatedBugs =
                $associatedBugReferences
        }

    $updateBody =
        ConvertTo-Json `
            -InputObject @($update) `
            -Depth 20

    $resultsUri =
        "https://dev.azure.com/$Org/$Project/_apis/test/Runs/${testRunId}/results?api-version=7.1"

    Invoke-RestMethod `
        -Uri $resultsUri `
        -Method Patch `
        -Headers $headers `
        -Body $updateBody |
    Out-Null

    Write-Host ""
    Write-Host "Bug association request sent."

    # -----------------------------------------------------
    # Verify Azure has persisted the Bug associations.
    #
    # Azure can occasionally take a few seconds before the
    # work-item association appears when retrieved again.
    # -----------------------------------------------------

    $associationVerified =
        $false

    for ($attempt = 1; $attempt -le 6; $attempt++) {

        Write-Host "Verification attempt $attempt of 6..."

        $verifiedResult =
            Invoke-RestMethod `
                -Uri $resultDetailsUri `
                -Method Get `
                -Headers $headers

        $verifiedBugIds =
            @()

        $verifiedBugsProperty =
            $verifiedResult.PSObject.Properties["associatedBugs"]

        if ($null -ne $verifiedBugsProperty) {

            $verifiedBugReferences =
                @($verifiedBugsProperty.Value)

            foreach ($verifiedBugReference in $verifiedBugReferences) {

                $verifiedIdProperty =
                    $verifiedBugReference.PSObject.Properties["id"]

                if ($null -ne $verifiedIdProperty) {

                    $verifiedBugIds +=
                        [int]$verifiedIdProperty.Value
                }
            }
        }

        $missingBugIds =
            @(
                $targetBugIds |
                    Where-Object {
                        $verifiedBugIds -notcontains $_
                    }
            )

        if ($missingBugIds.Count -eq 0) {

            $associationVerified =
                $true

            break
        }

        if ($attempt -lt 6) {

            Write-Host "Association is not visible yet."
            Write-Host "Waiting 3 seconds..."

            Start-Sleep -Seconds 3
        }
    }

    if (-not $associationVerified) {

        throw "Azure DevOps did not confirm all Bug associations for $testCaseId."
    }

    Write-Host ""
    Write-Host "Bug association verified."

    # -----------------------------------------------------
    # Save one evidence record per Bug
    # -----------------------------------------------------

    foreach ($bug in $bugsForTestCase) {

        $linkMap +=
            [PSCustomObject]@{
                bugCode =
                    [string]$bug.bugCode

                azureBugId =
                    [int]$bug.azureBugId

                testCaseId =
                    $testCaseId

                testRunId =
                    $testRunId

                azureResultId =
                    $azureResultId

                outcome =
                    $outcome
            }

        Write-Host (
            "Linked {0} -> {1} Test Result {2}" -f `
                $bug.bugCode,
                $testCaseId,
                $azureResultId
        )
    }

    Write-Host ""
}

# ---------------------------------------------------------
# Save linking evidence
# ---------------------------------------------------------

ConvertTo-Json `
    -InputObject @($linkMap) `
    -Depth 20 |
Set-Content `
    -Path $linkMapPath `
    -Encoding UTF8

Write-Host ""
Write-Host "============================================================"
Write-Host "RETEST BUG / RESULT LINKS COMPLETE"
Write-Host "============================================================"
Write-Host "Links created : $($linkMap.Count)"
Write-Host "Evidence map  : $linkMapPath"
Write-Host "============================================================"
```

### `scripts/azure-devops/Process-RetestLifecycle.ps1`

**Purpose:** Processes retest outcomes: Passed closes a Resolved Bug; Failed reactivates it, while recording verification comments and evidence.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Required environment values
# ---------------------------------------------------------

$token =
    $env:AZURE_PAT

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if (
    $token -eq '$(AZURE_PAT)' -or
    $token -match '^\$\([^)]+\)$'
) {
    throw "AZURE_PAT was not expanded."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_BUILDNUMBER)) {
    throw "BUILD_BUILDNUMBER is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_BUILDID)) {
    throw "BUILD_BUILDID is empty."
}

# ---------------------------------------------------------
# Authentication
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$jsonHeaders = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json"
}

$patchHeaders = @{
    Authorization =
        "Basic $base64AuthInfo"

    "Content-Type" =
        "application/json-patch+json"
}

# ---------------------------------------------------------
# Evidence paths
# ---------------------------------------------------------

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

$retestQueueMapPath =
    Join-Path `
        $artifactRoot `
        "azure-retest-queue-map.json"

$testResultMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-result-map.json"

$lifecycleMapPath =
    Join-Path `
        $artifactRoot `
        "azure-retest-lifecycle-map.json"

if (-not (Test-Path $retestQueueMapPath)) {
    throw "Retest queue mapping was not found: $retestQueueMapPath"
}

if (-not (Test-Path $testResultMapPath)) {
    throw "Test Result mapping was not found: $testResultMapPath"
}


function Add-VerifiedWorkItemComment {

    param (
        [Parameter(Mandatory = $true)]
        [int]$WorkItemId,

        [Parameter(Mandatory = $true)]
        [string]$CommentText
    )

    $addCommentUri =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workItems/${WorkItemId}/comments?format=Markdown&api-version=7.1-preview.4"

    $commentBody =
        @{
            text =
                $CommentText
        } |
        ConvertTo-Json -Depth 10

    $commentResponse =
        Invoke-RestMethod `
            -Uri $addCommentUri `
            -Method Post `
            -Headers $jsonHeaders `
            -Body $commentBody

    # Azure API responses have used both id/commentId
    # representations, so handle either defensively.

    $commentId =
        $null

    $idProperty =
        $commentResponse.PSObject.Properties["id"]

    if ($null -ne $idProperty) {

        $commentId =
            [int]$idProperty.Value
    }
    else {

        $commentIdProperty =
            $commentResponse.PSObject.Properties["commentId"]

        if ($null -ne $commentIdProperty) {

            $commentId =
                [int]$commentIdProperty.Value
        }
    }

    if ($null -eq $commentId) {

        throw "Azure DevOps did not return a Comment ID for Work Item $WorkItemId."
    }

    # -----------------------------------------------------
    # Retrieve the exact comment we just created.
    # -----------------------------------------------------

    $verifyCommentUri =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workItems/${WorkItemId}/comments/${commentId}?api-version=7.1-preview.4"

    $verifiedComment =
        Invoke-RestMethod `
            -Uri $verifyCommentUri `
            -Method Get `
            -Headers $jsonHeaders

    # ---------------------------------------------------------
    # Verify that Azure returned the exact comment we created.
    #
    # Do not require character-for-character equality because
    # Azure DevOps may normalize Markdown formatting.
    # Instead verify:
    #   - Comment ID
    #   - Work Item ID
    #   - non-empty text
    # ---------------------------------------------------------

    $verifiedIdProperty =
        $verifiedComment.PSObject.Properties["id"]

    if ($null -eq $verifiedIdProperty) {
        throw "Azure did not return the Comment ID during verification."
    }

    if ([int]$verifiedIdProperty.Value -ne $commentId) {
        throw "Retrieved Comment ID does not match Comment $commentId."
    }

    $verifiedWorkItemIdProperty =
        $verifiedComment.PSObject.Properties["workItemId"]

    if ($null -eq $verifiedWorkItemIdProperty) {
        throw "Azure did not return the Work Item ID for Comment $commentId."
    }

    if ([int]$verifiedWorkItemIdProperty.Value -ne $WorkItemId) {
        throw "Comment $commentId belongs to the wrong Work Item."
    }

    $textProperty =
        $verifiedComment.PSObject.Properties["text"]

    if ($null -eq $textProperty) {
        throw "Comment $commentId was retrieved but Azure returned no comment text."
    }

    $retrievedText =
        [string]$textProperty.Value

    if ([string]::IsNullOrWhiteSpace($retrievedText)) {
        throw "Comment $commentId was retrieved but its text is empty."
    }

    Write-Host (
        "Verified Comment {0} on Work Item {1}." -f `
            $commentId,
            $WorkItemId
    )

    Write-Host (
        "Stored comment length: {0} characters." -f `
            $retrievedText.Length
    )

    return $commentId
}

# ---------------------------------------------------------
# Read queue and Test Results
# ---------------------------------------------------------

$retestQueue =
    Get-Content `
        -Path $retestQueueMapPath `
        -Raw |
    ConvertFrom-Json

$retestQueue =
    @($retestQueue)

$testResultMap =
    Get-Content `
        -Path $testResultMapPath `
        -Raw |
    ConvertFrom-Json

$testResultMap =
    @($testResultMap)

$lifecycleMap =
    @()

Write-Host ""
Write-Host "============================================================"
Write-Host "PROCESSING AUTOMATED BUG RETEST LIFECYCLE"
Write-Host "============================================================"
Write-Host "Retest Bugs  : $($retestQueue.Count)"
Write-Host "Test Results : $($testResultMap.Count)"
Write-Host ""

foreach ($queueEntry in $retestQueue) {

    $bugCode =
        [string]$queueEntry.bugCode

    $bugId =
        [int]$queueEntry.azureBugId

    $testCaseId =
        [string]$queueEntry.testCaseId

    $azureTestCaseId =
        [int]$queueEntry.azureTestCaseId

    # -----------------------------------------------------
    # Find the exact Test Result belonging to this Test Case
    # -----------------------------------------------------

    $matchingResults =
        @(
            $testResultMap |
                Where-Object {
                    $_.testCaseId -eq $testCaseId
                }
        )

    if ($matchingResults.Count -ne 1) {

        throw "Could not uniquely identify the Test Result for $testCaseId."
    }

    $testResult =
        $matchingResults[0]

    $outcome =
        [string]$testResult.outcome

    $testRunId =
        [int]$testResult.testRunId

    $azureResultId =
        [int]$testResult.azureResultId

    # -----------------------------------------------------
    # Determine lifecycle action
    # -----------------------------------------------------

    if ($outcome -eq "Passed") {

        $newBugState =
            "Closed"

        $lifecycleDescription =
            "The automated verification passed. The reported defect condition is no longer reproduced by the selected automated Test Case."

        $stateExplanation =
            "Bug state changed automatically from Resolved to Closed."
    }
    elseif ($outcome -eq "Failed") {

        $newBugState =
            "Active"

        $lifecycleDescription =
            "The automated verification failed. The reported defect condition is still reproducible."

        $stateExplanation =
            "Bug state changed automatically from Resolved to Active."
    }
    else {

        throw "Unsupported retest outcome '$outcome' for $testCaseId."
    }

    Write-Host "------------------------------------------------------------"
    Write-Host "RETEST LIFECYCLE"
    Write-Host "------------------------------------------------------------"
    Write-Host "Bug            : $bugCode ($bugId)"
    Write-Host "Test Case      : $testCaseId ($azureTestCaseId)"
    Write-Host "Test Run ID    : $testRunId"
    Write-Host "Test Result ID : $azureResultId"
    Write-Host "Outcome        : $outcome"
    Write-Host "Target State   : $newBugState"
    Write-Host ""

    # -----------------------------------------------------
    # Re-read Bug immediately before changing it.
    #
    # Safety rule:
    # only Bugs still in Resolved may be processed.
    # -----------------------------------------------------

    $bugUri =
        "https://dev.azure.com/$Org/$Project/_apis/wit/workitems/${bugId}?api-version=7.1"

    $bug =
        Invoke-RestMethod `
            -Uri $bugUri `
            -Method Get `
            -Headers $jsonHeaders

    $currentBugState =
        [string]$bug.fields.'System.State'

    $workItemType =
        [string]$bug.fields.'System.WorkItemType'

    if ($workItemType -ne "Bug") {

        throw "Work Item $bugId is '$workItemType', not Bug."
    }

    if ($currentBugState -ne "Resolved") {

        throw "Bug $bugCode is no longer Resolved. Current state: $currentBugState."
    }

    # -----------------------------------------------------
    # Change state
    # -----------------------------------------------------

    $stateOperations =
        @(
            @{
                op =
                    "replace"

                path =
                    "/fields/System.State"

                value =
                    $newBugState
            }
        )

    $stateBody =
        ConvertTo-Json `
            -InputObject $stateOperations `
            -Depth 20

    $updatedBug =
        Invoke-RestMethod `
            -Uri $bugUri `
            -Method Patch `
            -Headers $patchHeaders `
            -Body $stateBody

    $verifiedState =
        [string]$updatedBug.fields.'System.State'

    if ($verifiedState -ne $newBugState) {

        throw "Bug $bugCode did not change to $newBugState."
    }

    Write-Host "Bug state changed:"
    Write-Host "  Resolved -> $verifiedState"
    Write-Host ""

    # -----------------------------------------------------
    # Human-readable verification record
    # -----------------------------------------------------

    $retestDate =
        (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    $bugCommentText =
@"
---

### AUTOMATED RETEST - $($outcome.ToUpperInvariant())

**Retest date:** $retestDate
**Pipeline build number:** $env:BUILD_BUILDNUMBER
**Pipeline build ID:** $env:BUILD_BUILDID
**Test Run ID:** $testRunId
**Test Result ID:** $azureResultId
**Test Case:** $testCaseId
**Outcome:** $outcome

$lifecycleDescription

**Bug lifecycle:** Resolved -> $newBugState

$stateExplanation

---
"@

    $bugCommentId =
        Add-VerifiedWorkItemComment `
            -WorkItemId $bugId `
            -CommentText $bugCommentText

    # -----------------------------------------------------
    # Add corresponding Test Case verification record
    # -----------------------------------------------------

    $testCaseCommentText =
@"
---

### AUTOMATED DEFECT RETEST - $($outcome.ToUpperInvariant())

**Retest date:** $retestDate
**Bug:** $bugCode
**Pipeline build number:** $env:BUILD_BUILDNUMBER
**Pipeline build ID:** $env:BUILD_BUILDID
**Test Run ID:** $testRunId
**Test Result ID:** $azureResultId
**Test Case:** $testCaseId
**Outcome:** $outcome

$lifecycleDescription

**Bug lifecycle:** $bugCode changed from Resolved to $newBugState.

---
"@

    $testCaseCommentId =
        Add-VerifiedWorkItemComment `
            -WorkItemId $azureTestCaseId `
            -CommentText $testCaseCommentText

    # -----------------------------------------------------
    # Evidence
    # -----------------------------------------------------

    $lifecycleMap +=
        [PSCustomObject]@{
            bugCode =
                $bugCode

            azureBugId =
                $bugId

            testCaseId =
                $testCaseId

            azureTestCaseId =
                $azureTestCaseId

            testRunId =
                $testRunId

            azureResultId =
                $azureResultId

            outcome =
                $outcome

            previousBugState =
                "Resolved"

            newBugState =
                $verifiedState

            bugCommentId =
                [int]$bugCommentId

            testCaseCommentId =
                [int]$testCaseCommentId

            buildNumber =
                [string]$env:BUILD_BUILDNUMBER

            buildId =
                [int]$env:BUILD_BUILDID
        }

    Write-Host ""
    Write-Host "RETEST LIFECYCLE COMPLETE"
    Write-Host "$bugCode : Resolved -> $verifiedState"
    Write-Host ""
}

# ---------------------------------------------------------
# Save evidence
# ---------------------------------------------------------

ConvertTo-Json `
    -InputObject @($lifecycleMap) `
    -Depth 20 |
Set-Content `
    -Path $lifecycleMapPath `
    -Encoding UTF8

Write-Host ""
Write-Host "============================================================"
Write-Host "AUTOMATED RETEST LIFECYCLE COMPLETE"
Write-Host "============================================================"
Write-Host "Bugs Processed : $($lifecycleMap.Count)"
Write-Host "Evidence Map   : $lifecycleMapPath"
Write-Host "============================================================"
```

### `scripts/azure-devops/Update-TestRunResults.ps1`

**Purpose:** Parses Surefire/TestNG XML and updates the corresponding Azure Test Results and Test Run.

```powershell
param (
    [Parameter(Mandatory = $true)]
    [string]$Org,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$SurefireRelativePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------
# Retrieve required pipeline values
# ---------------------------------------------------------

$token = $env:AZURE_PAT

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if ([string]::IsNullOrWhiteSpace($env:TEST_RUN_ID)) {
    throw "TEST_RUN_ID is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_SOURCESDIRECTORY)) {
    throw "BUILD_SOURCESDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_ARTIFACTSTAGINGDIRECTORY)) {
    throw "BUILD_ARTIFACTSTAGINGDIRECTORY is empty."
}

if ([string]::IsNullOrWhiteSpace($env:BUILD_BUILDNUMBER)) {
    throw "BUILD_BUILDNUMBER is empty."
}

$testRunId =
    [int]$env:TEST_RUN_ID

# ---------------------------------------------------------
# Build REST API authorization header
# ---------------------------------------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization = "Basic $base64AuthInfo"
    "Content-Type" = "application/json"
}

# ---------------------------------------------------------
# Locate TestEvidence and Test Point mapping
# ---------------------------------------------------------

$artifactRoot =
    Join-Path `
        $env:BUILD_ARTIFACTSTAGINGDIRECTORY `
        "TestEvidence"

$testPointMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-point-map.json"

if (-not (Test-Path $testPointMapPath)) {
    throw "Test Point mapping file was not found: $testPointMapPath"
}

$testPointMap =
    Get-Content `
        -Path $testPointMapPath `
        -Raw |
    ConvertFrom-Json

$testPointMap =
    @($testPointMap)

if ($testPointMap.Count -eq 0) {
    throw "No Test Point mappings were found."
}

# ---------------------------------------------------------
# Locate Maven Surefire XML files
# ---------------------------------------------------------

$surefirePath =
    Join-Path `
        $env:BUILD_SOURCESDIRECTORY `
        $SurefireRelativePath

$surefireFiles =
    @(
        Get-ChildItem `
            -Path $surefirePath `
            -Filter "TEST-*.xml" `
            -File `
            -ErrorAction SilentlyContinue
    )

# ---------------------------------------------------------
# If no Surefire results exist, abort the Azure Test Run
# ---------------------------------------------------------

if ($surefireFiles.Count -eq 0) {

    Write-Host ""
    Write-Host "No Surefire XML reports were found."

    $abortRunUri =
        "https://dev.azure.com/$Org/$Project/_apis/test/runs/${testRunId}?api-version=7.1"

    $abortBody = @{
        state =
            "Aborted"

        comment =
            "No Maven Surefire XML results were produced by pipeline build $env:BUILD_BUILDNUMBER."
    } | ConvertTo-Json -Depth 10

    Invoke-RestMethod `
        -Uri $abortRunUri `
        -Method Patch `
        -Headers $headers `
        -Body $abortBody |
    Out-Null

    throw "Azure Test Run $testRunId was aborted because no Surefire results were available."
}

Write-Host ""
Write-Host "============================================================"
Write-Host "READING MAVEN SUREFIRE TEST RESULTS"
Write-Host "============================================================"
Write-Host "Organization : $Org"
Write-Host "Project      : $Project"
Write-Host "Test Run ID  : $testRunId"
Write-Host "XML Files    : $($surefireFiles.Count)"
Write-Host ""

# ---------------------------------------------------------
# Parse the Surefire/TestNG XML
# ---------------------------------------------------------

$automationResults = @()

foreach ($surefireFile in $surefireFiles) {

    Write-Host "Reading: $($surefireFile.FullName)"

    [xml]$xml =
        Get-Content `
            -Path $surefireFile.FullName `
            -Raw

    $testCaseNodes =
        @($xml.testsuite.testcase)

    foreach ($testCaseNode in $testCaseNodes) {

        $testName =
            [string]$testCaseNode.name

        # Only process our TCxxx DataProvider tests.
        if ($testName -notmatch "(TC\d{3})") {
            continue
        }

        $localTestCaseId =
            $Matches[1]

        $outcome =
            "Passed"

        $errorMessage =
            ""

        # -------------------------------------------------
        # Safely query optional XML nodes.
        #
        # Under Set-StrictMode, directly requesting
        # $testCaseNode.failure throws an exception when
        # the node does not exist.
        # -------------------------------------------------

        $failureNode =
            $testCaseNode.SelectSingleNode("failure")

        $errorNode =
            $testCaseNode.SelectSingleNode("error")

        $skippedNode =
            $testCaseNode.SelectSingleNode("skipped")

        if ($null -ne $failureNode) {

            $outcome =
                "Failed"

            $errorMessage =
                [string]$failureNode.InnerText
        }
        elseif ($null -ne $errorNode) {

            $outcome =
                "Failed"

            $errorMessage =
                [string]$errorNode.InnerText
        }
        elseif ($null -ne $skippedNode) {

            $outcome =
                "NotExecuted"
        }

        $durationMilliseconds =
            [math]::Round(
                ([double]$testCaseNode.time * 1000)
            )

        $automationResults +=
            [PSCustomObject]@{
                testCaseId =
                    $localTestCaseId

                outcome =
                    $outcome

                durationInMs =
                    $durationMilliseconds

                errorMessage =
                    $errorMessage
            }

        Write-Host "$localTestCaseId -> $outcome ($durationMilliseconds ms)"
    }
}

# ---------------------------------------------------------
# Remove accidental duplicate Test Case records
# ---------------------------------------------------------

$automationResults =
    @(
        $automationResults |
            Sort-Object testCaseId -Unique
    )

if ($automationResults.Count -ne $testPointMap.Count) {

    throw "Expected $($testPointMap.Count) automation results but found $($automationResults.Count)."
}

Write-Host ""
Write-Host "Automation results found: $($automationResults.Count)"

# ---------------------------------------------------------
# Retrieve the Azure Test Results belonging to this run
# ---------------------------------------------------------

$resultsUri =
    "https://dev.azure.com/$Org/$Project/_apis/test/Runs/${testRunId}/results?api-version=7.1"

$azureResultsResponse =
    Invoke-RestMethod `
        -Uri $resultsUri `
        -Method Get `
        -Headers $headers

$azureResults =
    @($azureResultsResponse.value)

Write-Host "Azure Test Results found: $($azureResults.Count)"

if ($azureResults.Count -ne $testPointMap.Count) {

    throw "Expected $($testPointMap.Count) Azure Test Results but found $($azureResults.Count)."
}

# ---------------------------------------------------------
# Map:
#
# Local Test Case
#     ↓
# Test Point
#     ↓
# Azure Test Result
# ---------------------------------------------------------

$resultUpdates =
    @()

$testResultMap =
    @()

foreach ($automationResult in $automationResults) {

    $localTestCaseId =
        [string]$automationResult.testCaseId

    $pointMappings =
        @(
            $testPointMap |
                Where-Object {
                    $_.testCaseId -eq $localTestCaseId
                }
        )

    if ($pointMappings.Count -ne 1) {
        throw "Could not uniquely map $localTestCaseId to a Test Point."
    }

    $testPointId =
        [int]$pointMappings[0].testPointId

    $azureTestCaseId =
        [int]$pointMappings[0].azureTestCaseId

    $testCaseName =
        [string]$pointMappings[0].testCaseName

    $matchingAzureResults =
        @(
            $azureResults |
                Where-Object {

                    $testPointProperty =
                        $_.PSObject.Properties["testPoint"]

                    if ($null -eq $testPointProperty) {
                        return $false
                    }

                    [int]$_.testPoint.id -eq $testPointId
                }
        )

    if ($matchingAzureResults.Count -ne 1) {

        throw "Could not uniquely map Test Point $testPointId to an Azure Test Result."
    }

    $azureResultId =
        [int]$matchingAzureResults[0].id

    # -----------------------------------------------------
    # Azure result text fields should not contain an
    # unlimited Java stack trace.
    # -----------------------------------------------------

    $errorText =
        [string]$automationResult.errorMessage

    if ($errorText.Length -gt 1000) {

        $errorText =
            $errorText.Substring(
                0,
                1000
            )
    }

    $update =
        @{
            id =
                $azureResultId

            state =
                "Completed"

            outcome =
                [string]$automationResult.outcome

            durationInMs =
                [double]$automationResult.durationInMs

            comment =
                "Automated Selenium/TestNG result from pipeline build $env:BUILD_BUILDNUMBER."
        }

    if (-not [string]::IsNullOrWhiteSpace($errorText)) {

        $update.errorMessage =
            $errorText
    }

    $resultUpdates +=
        $update

    # -----------------------------------------------------
    # Save all identifiers required by later Bug and
    # attachment tasks.
    # -----------------------------------------------------

    $testResultMap +=
        [PSCustomObject]@{
            testCaseId =
                $localTestCaseId

            testCaseName =
                $testCaseName

            azureTestCaseId =
                $azureTestCaseId

            testPointId =
                $testPointId

            testRunId =
                $testRunId

            azureResultId =
                $azureResultId

            outcome =
                [string]$automationResult.outcome

            durationInMs =
                [double]$automationResult.durationInMs

            errorMessage =
                $errorText
        }

    Write-Host ""
    Write-Host "Mapped:"
    Write-Host "  $localTestCaseId"
    Write-Host "  Test Point ID : $testPointId"
    Write-Host "  Result ID     : $azureResultId"
    Write-Host "  Outcome       : $($automationResult.outcome)"
}

# ---------------------------------------------------------
# Update all Azure Test Results
# ---------------------------------------------------------

Write-Host ""
Write-Host "============================================================"
Write-Host "UPDATING AZURE DEVOPS TEST RESULTS"
Write-Host "============================================================"

# -InputObject preserves the JSON array structure.
$updateBody =
    ConvertTo-Json `
        -InputObject $resultUpdates `
        -Depth 20

Invoke-RestMethod `
    -Uri $resultsUri `
    -Method Patch `
    -Headers $headers `
    -Body $updateBody |
Out-Null

Write-Host "Azure Test Results successfully updated."

# ---------------------------------------------------------
# Save Test Result mapping for Bug/evidence tasks
# ---------------------------------------------------------

$testResultMapPath =
    Join-Path `
        $artifactRoot `
        "azure-test-result-map.json"

$testResultMap |
    ConvertTo-Json -Depth 10 |
    Set-Content `
        -Path $testResultMapPath `
        -Encoding UTF8

Write-Host "Test Result mapping saved:"
Write-Host $testResultMapPath

# ---------------------------------------------------------
# Complete the Azure DevOps Test Run
# ---------------------------------------------------------

$completeRunUri =
    "https://dev.azure.com/$Org/$Project/_apis/test/runs/${testRunId}?api-version=7.1"

$completeRunBody = @{
    state =
        "Completed"

    completedDate =
        (Get-Date).ToUniversalTime().ToString("o")

    comment =
        "Completed automatically from Selenium/TestNG results for pipeline build $env:BUILD_BUILDNUMBER."
} | ConvertTo-Json -Depth 10

$completedRun =
    Invoke-RestMethod `
        -Uri $completeRunUri `
        -Method Patch `
        -Headers $headers `
        -Body $completeRunBody

# ---------------------------------------------------------
# Retrieve results again and verify final counts
# ---------------------------------------------------------

$finalResultsResponse =
    Invoke-RestMethod `
        -Uri $resultsUri `
        -Method Get `
        -Headers $headers

$finalResults =
    @($finalResultsResponse.value)

$passedCount =
    @(
        $finalResults |
            Where-Object {
                $_.outcome -eq "Passed"
            }
    ).Count

$failedCount =
    @(
        $finalResults |
            Where-Object {
                $_.outcome -eq "Failed"
            }
    ).Count

$notExecutedCount =
    @(
        $finalResults |
            Where-Object {
                $_.outcome -eq "NotExecuted"
            }
    ).Count

Write-Host ""
Write-Host "============================================================"
Write-Host "AZURE DEVOPS TEST RUN COMPLETED"
Write-Host "============================================================"
Write-Host "Test Run ID  : $testRunId"
Write-Host "State        : $($completedRun.state)"
Write-Host "Total Tests  : $($finalResults.Count)"
Write-Host "Passed       : $passedCount"
Write-Host "Failed       : $failedCount"
Write-Host "Not Executed : $notExecutedCount"
Write-Host "============================================================"
```

## Optional maintenance utility

The following two files were present in the final training project and are current utilities, but they are **not required** for the normal Regression or Retest framework. They are included separately so readers do not confuse destructive training-environment cleanup with normal test execution.

### `xScripts/delete_tc_wit.ps1`

**Purpose:** Optional training-environment cleanup utility that deletes Azure Test Case artifacts through the Test Management REST API.

```powershell
# -----------------------------
# Configuration
# -----------------------------

$orgName = "smac567"
$projectName = "FSWEP_567"
$token = $env:AZURE_PAT

# Set to $true to preview only.
# Set to $false to actually delete the Test Cases.
$DryRun = $false

# -----------------------------
# Validate PAT
# -----------------------------

if ([string]::IsNullOrWhiteSpace($token)) {
    throw "AZURE_PAT is empty."
}

if (
    $token -eq '$(AZURE_PAT)' -or
    $token -match '^\$\([^)]+\)$'
) {
    throw "AZURE_PAT was not expanded."
}

# -----------------------------
# Authentication
# -----------------------------

$base64AuthInfo =
    [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes(":$token")
    )

$headers = @{
    Authorization = "Basic $base64AuthInfo"
    "Content-Type" = "application/json"
}

# -----------------------------
# Query all Test Case work items
# -----------------------------

$queryUrl =
    "https://dev.azure.com/$orgName/$projectName/_apis/wit/wiql?api-version=7.1"

Write-Host "Query URL: $queryUrl"

$query =
    "SELECT [System.Id] " +
    "FROM WorkItems " +
    "WHERE [System.TeamProject] = '$projectName' " +
    "AND [System.WorkItemType] = 'Test Case'"

$queryBody =
    @{
        query = $query
    } |
    ConvertTo-Json

Write-Host ""
Write-Host "Fetching all Test Case work items..."

$queryResponse =
    Invoke-RestMethod `
        -Uri $queryUrl `
        -Method Post `
        -Headers $headers `
        -Body $queryBody

$allIds =
    @(
        $queryResponse.workItems |
            Select-Object -ExpandProperty id
    )

if ($allIds.Count -eq 0) {

    Write-Host ""
    Write-Host "No Test Case work items were found."
    return
}

# -----------------------------
# All Test Cases are deletion targets
# -----------------------------

$targetDeleteIds =
    @($allIds)

Write-Host ""
Write-Host "============================================"
Write-Host "TEST CASE DELETE SUMMARY"
Write-Host "============================================"
Write-Host "Total Test Cases found : $($allIds.Count)"
Write-Host "Test Cases to delete   : $($targetDeleteIds.Count)"
Write-Host "Dry Run                : $DryRun"
Write-Host ""

Write-Host "Test Case IDs:"
$targetDeleteIds |
    Sort-Object |
    ForEach-Object {
        Write-Host "  $_"
    }

# -----------------------------
# Dry run
# -----------------------------

if ($DryRun) {

    Write-Host ""
    Write-Host "DRY RUN ONLY."
    Write-Host "No Test Cases were deleted."
    Write-Host ""
    Write-Host "Set:"
    Write-Host '    $DryRun = $false'
    Write-Host "to perform the deletion."

    return
}

# -----------------------------
# Delete all Test Case work items
#
# Normal DELETE sends each work item to the
# Azure DevOps Recycle Bin.
# -----------------------------

Write-Host ""
Write-Host "Deleting Test Case work items..."
Write-Host ""

$deletedCount =
    0

foreach ($testCaseId in $targetDeleteIds) {

    $deleteUrl =
        "https://dev.azure.com/$orgName/$projectName/_apis/test/testcases/${testCaseId}?api-version=7.1"

    Write-Host "Deleting Test Case Work Item ID: $testCaseId"

    try {

        Invoke-RestMethod `
            -Uri $deleteUrl `
            -Method Delete `
            -Headers $headers |
        Out-Null

        $deletedCount++

        Write-Host "  Deleted successfully."
    }
    catch {

        Write-Host "  FAILED to delete Test Case $testCaseId."
        Write-Host "  $($_.Exception.Message)"
        throw
    }
}

# -----------------------------
# Final summary
# -----------------------------

Write-Host ""
Write-Host "============================================"
Write-Host "TEST CASE DELETION COMPLETE"
Write-Host "============================================"
Write-Host "Test Cases found   : $($allIds.Count)"
Write-Host "Test Cases deleted : $deletedCount"
Write-Host "============================================"
```

### `xYaml_files/delete_test_cases.yml`

**Purpose:** Optional pipeline wrapper for the Test Case cleanup utility.

```yaml
trigger: none

pool:
  name: 'Pool_A'

steps:

  - task: PowerShell@2
    displayName: 'Execute Script to delete test cases'
    inputs:
      targetType: 'filePath'
      filePath: 'xScripts/delete_tc_wit.ps1'
    env:
      AZURE_PAT: $(AZURE_PAT)
```

> **Warning:** The optional Test Case cleanup utility deletes Azure Test Case artifacts. Use it only in a disposable/personal training environment after confirming the target Azure DevOps organization and project.

## Files intentionally excluded

The appendix intentionally excludes legacy or experimental files (`run_test_case.yml`, `xMain/Run_Regression_Scripts.ps1`, the older `xScripts` development helpers, `xYaml_files/run_regression.yml`, and the generated sample `src/main/java/org/example/Main.java`) as well as `.git/`, `.idea/`, `target/`, `Screenshots/`, and other generated output. None of those files is required by the final accepted Regression/Retest framework.
