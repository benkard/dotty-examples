# Running Dotty on Windows

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This repository gathers code examples coming from various websites - mostly from the <a href="http://dotty.epfl.ch/">Dotty project</a> - or written by myself.<br/>
    In particular it includes several <a href="https://en.wikipedia.org/wiki/Batch_file">batch scripts</a> for experimenting with the Dotty language (aka <a href="https://www.scala-lang.org/blog/2018/04/19/scala-3.html">Scala 3.0</a>) on a Windows machine.
  </td>
  </tr>
</table>


> **NB.** We also decided to take a further step towards building the [Dotty software](https://github.com/lampepfl/dotty/releases) on Microsoft Windows; read our [***work report***](DRONE.md) to learn more !


## Project dependencies

This project repository depends on two external software for the **Microsoft Windows** platform:

- [Oracle Java 8 SDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) ([*release notes*](http://www.oracle.com/technetwork/java/javase/8u-relnotes-2225394.html))
- [Dotty 0.10](https://github.com/lampepfl/dotty/releases) (Java 9+ is supported) 

<!--
*Reminder*: Dotty 0.9 requires Java 8 <sup id="anchor_01">[[1]](#footnote_01)</sup>)
-->

Optionally you may also install the following software:

- [Scala 2.12](https://www.scala-lang.org/download/) (requires Java 8) ([*release notes*](https://github.com/scala/scala/releases/tag/v2.12.7))
- [SBT 1.2.6](https://www.scala-sbt.org/download.html) (with Scala 2.12.17 preloaded) ([*release notes*](https://github.com/sbt/sbt/releases/tag/v1.2.6))
- [Apache Ant 1.10](https://ant.apache.org/) (requires Java 8) ([*release notes*](https://archive.apache.org/dist/ant/RELEASE-NOTES-1.10.5.html))
- [Gradle 4.10](https://gradle.org/install/) (requires Java 7 or newer) ([*release notes*](https://docs.gradle.org/current/release-notes.html))
- [Apache Maven 3.6](http://maven.apache.org/download.cgi) ([*release notes*](http://maven.apache.org/docs/3.6.0/release-notes.html))
- [CFR 0.13](http://www.benf.org/other/cfr/) (Java decompiler)
- [Git 2.19](https://git-scm.com/download/win) ([*release notes*](https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.19.2.txt))

> ***Installation policy***<br/>
> Whenever possible software is installed via a [Zip archive](https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/) rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in memory of* the [`/opt/`](http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) directory on Unix).

For instance our development environment looks as follows (*November 2018*):

<pre style="font-size:80%;">
C:\Program Files\Java\jdk1.8.0_191\
C:\opt\scala-2.12.7\
C:\opt\dotty-0.10.0\
C:\opt\apache-ant-1.10.5\
c:\opt\gradle-4.10.2\
C:\opt\apache-maven-3.6.0\
C:\opt\sbt-1.2.6\
C:\opt\cfr-0.136\
C:\opt\Git-2.19.2\
</pre>

> **NB.** Git for Windows provides a BASH emulation used to run [**`git`**](https://git-scm.com/docs/git) from the command line (as well as over 250 Unix commands like **`awk`**, **`diff`**, **`mv`**, **`rmdir`**, **`sed`** and **`wc`**).

We further recommand using an advanced console emulator such as [ComEmu](https://conemu.github.io/) (or [Cmdr](http://cmder.net/)) which features [Unicode support](https://conemu.github.io/en/UnicodeSupport.html).

## Directory structure

This repository is organized as follows:
<pre style="font-size:80%;">
bin\*.bat
bin\0.10\*.bat
bin\cfr-0.136.zip
docs\
examples\{dotty-example-project, ..}
myexamples\{00_AutoParamTupling, ..}
README.md
setenv.bat
</pre>

where

- directory [**`bin\`**](bin/) provides several utility batch commands.
- directory [**`bin\0.10\`**](bin/0.10/) contains the batch commands for Dotty 0.10.
- file [**`bin\cfr-0.136.zip`**](bin/cfr-0.136.zip) contains a zipped distribution of [CFR](http://www.benf.org/other/cfr/).
- directory [**`docs\`**](docs/) contains several Dotty related papers/articles.
- directory [**`examples\`**](examples/) contains Dotty examples grabbed from various websites.
- directory [**`myexamples\`**](myexamples/) contains self-written Dotty examples.
- file [**`README.md`**](README.md) is the Markdown document for this page.
- file [**`setenv.bat`**](setenv.bat) is the batch script for setting up our environment.

> **NB.** We also define a virtual drive **`W:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"](https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation) from Microsoft Support).<br/>We use the Windows external command [**`subst`**](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst) to create virtual drives; for instance: **`subst W: %USERPROFILE%\workspace`**.

In the next section we give a brief description of the batch files present in this repository.

## Batch commands

We distinguish different sets of batch commands:

1. [**`setenv.bat`**](setenv.bat) - This batch command makes external tools such as **`javac.exe`**, **`scalac.bat`**, [**`dotc.bat`**](bin/0.10/dotc.bat), etc. directly available from the command prompt.

    <pre style="font-size:80%;">
    &gt; javac -version
    javac 1.8.0_191

    &gt; scalac -version
    Scala compiler version 2.12.7 -- Copyright 2002-2018, LAMP/EPFL and Lightbend, Inc.

    &gt; dotc -version
    Dotty compiler version 0.10.0 -- Copyright 2002-2018, LAMP/EPFL
    </pre>

2. Directory [**`bin\`**](bin/) - This directory contains several utility batch files:
   - **`cleanup.bat`** removes the generated class files from every example directory (both in [**`examples\`**](examples/) and [**`myexamples\`**](myexamples/) directories).
   - **`dirsize.bat <dir_path_1> ..`** prints the size in Kb/Mb/Gb of the specified directory paths.
   - **`getnightly.bat`** downloads/installs the library files from the latest [Dotty nightly build](https://search.maven.org/search?q=g:ch.epfl.lamp).
   - **`searchjars.bat <class_name>`** searches for the given class name into all Dotty/Scala JAR files.
   - **`timeit.bat <cmd_1> { & <cmd_2> }`** prints the execution time of the specified commands.
   - **`touch.bat <file_path>`** updates the modification date of an existing file or creates a new one.<div style="font-size:8px;">&nbsp;</div>

3. Directory [**`bin\0.10\`**](bin/0.10/) - This directory contains batch files to be copied to the **`bin\`** directory of the Dotty installation (eg. **`C:\opt\dotty-0.10.0\bin\`**) in order to use the [**`dot`**](bin/0.10/dot.bat), [**`dotc`**](bin/0.10/dotc.bat), [**`dotd`**](bin/0.10/dotd.bat) and [**`dotr`**](bin/0.10/dotr.bat) commands on **Microsoft Windows**.
    > **NB.** We wrote (and do maintain) those batch files based on the bash scripts available from the standard [Dotty](http://dotty.epfl.ch/) distribution.

    <pre style="font-size:80%;">
    &gt; dir /b c:\opt\dotty-0.10.0\bin
    common
    common.bat
    dot.bat
    dotc
    dotc.bat
    dotd
    dotd.bat
    dotr
    dotr.bat
    </pre>

<!-- ## removed on 2018-10-05 ##
    > **NB.** Prior to version 0.9-RC1 the [**`dotr`**](bin/0.9/dotr.bat) command did hang on Windows due to implementation issues with the Dotty [REPL](https://en.wikipedia.org/wiki/Read–eval–print_loop). This [issue](https://github.com/lampepfl/dotty/pull/4680) has been fixed by using [JLine 3](https://github.com/jline/jline3) in the REPL.
-->

4. [**`build.bat`**](examples/dotty-example-project/build.bat) - Finally each example can be built/run using the **`build`** command.<br/>
    > **NB.** We prefer the **`build`** command here since our code examples are simple and don't require the [**`sbt`** ](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html)machinery (eg. [library dependencies](https://www.scala-sbt.org/1.x/docs/Library-Dependencies.html), [sbt server](https://www.scala-sbt.org/1.x/docs/sbt-server.html)).

    <pre style="font-size:80%;">
    &gt; build
    Usage: build { options | subcommands }
      Options:
        -debug           show commands executed by this script
        -deprecation     set compiler option -deprecation
        -explain         set compiler option -explain
        -explain-types   set compiler option -explain-types
        -compiler:&lt;name&gt; select compiler (scala|scalac|dotc|dotty), default:dotc
        -main:&lt;name&gt;     define main class name
        -timer           display the compile time
      Subcommands:
        clean            delete generated class files
        compile          compile source files (Java and Scala)
        help             display this help message
        run              execute main class
      Properties:
      (to be defined in SBT configuration file project\build.properties)
        compiler.cmd     alternative to option -compiler
        main.class       alternative to option -main
        main.args        list of arguments to be passed to main class
    </pre>

## Optional tools

1. Build tools

    Projects in [**`examples\`**](examples/) and [**`myexamples\`**](myexamples/) directories can also be built using [**`sbt`**](https://www.scala-sbt.org/), [**`ant`**](https://ant.apache.org/manual/running.html), [**`gradle`**](https://docs.gradle.org/current/userguide/command_line_interface.html) or [**`mvn`**](http://maven.apache.org/ref/3.6.0/maven-embedder/cli.html) as an alternative to the **`build`** tool:

    <pre style="font-size:80%;">
    > sbt clean compile run
    ...
    > ant clean compile run
    ...
    > gradle clean compileDotty run
    ...
    > mvn clean compile exec:java
    </pre>
    
    > ***Gradle Wrappers***<br/>
    > We don't rely on them even if using [Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html) is the  recommended way to execute a Gradle build.<br/>
    > Simply execute the **`gradle wrapper`** command to generate the wrapper files; you can then run **`gradlew`** instead of [**`gradle`**](https://docs.gradle.org/current/userguide/command_line_interface.html).

2. Decompiler tools

    As an alternative to the standard [**`javap`**](https://docs.oracle.com/javase/7/docs/technotes/tools/windows/javap.html) class decompiler one may use **`cfr.bat`** (simply extract [**`bin\cfr-0.136.zip`**](bin/cfr-0.136.zip) to **`c:\opt\`**) which prints [Java source code](https://docs.oracle.com/javase/specs/jls/se8/html/index.html) instead of just [Java bytecode](https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-6.html):

    <pre style="font-size:80%;">
    &gt; cfr myexamples\00_AutoParamTupling\target\classes\Main.class
    /*
     * Decompiled with CFR 0.136.
     */
    public final class Main {
        public static void test01() {
            Main$.MODULE$.test01();
        }
    
        public static void main(String[] arrstring) {
            Main$.MODULE$.main(arrstring);
        }
    
        public static void test02() {
            Main$.MODULE$.test02();
        }
    }
    </pre>

    Here is the console output from [**`javap`**](https://docs.oracle.com/javase/7/docs/technotes/tools/windows/javap.html) (with option **`-c`**) for the same class file:

    <pre style="font-size:80%;">
    &gt; javap -c myexamples\00_AutoParamTupling\target\classes\Main.class
    Compiled from "Main.scala"
    public final class Main {
      public static void test01();
        Code:
           0: getstatic     #13                 // Field Main$.MODULE$:LMain$;
           3: invokevirtual #15                 // Method Main$.test01:()V
           6: return
    
      public static void main(java.lang.String[]);
        Code:
           0: getstatic     #13                 // Field Main$.MODULE$:LMain$;
           3: aload_0
           4: invokevirtual #19                 // Method Main$.main:([Ljava/lang/String;)V
           7: return
    
      public static void test02();
        Code:
           0: getstatic     #13                 // Field Main$.MODULE$:LMain$;
           3: invokevirtual #22                 // Method Main$.test02:()V
           6: return
    }
    </pre>

## Session examples

#### `setenv.bat`

The [**`setenv`**](setenv.bat) command is executed once to setup our development environment; it makes external tools such as **`javac.exe`**, **`sbt.bat`** and [**`git.exe`**](https://git-scm.com/docs/git) directly available from the command prompt:

<pre style="margin:10px 0 0 30px;font-size:80%;">
> setenv
Tool versions:
   javac 1.8.0_191, java 1.8.0_191, scalac 2.12.7, dotc 0.10.0,
   ant 1.10.5, gradle 4.10.2, mvn 3.6.0, sbt 1.2.6/2.12.17,
   cfr 0.136, git 2.19.2.windows.1, diff 3.6

> where sbt
C:\opt\sbt-1.2.6\bin\sbt
C:\opt\sbt-1.2.6\bin\sbt.bat
</pre>

> **NB.** Execute **`setenv help`** to display the help message.

With option **`-verbose`** the [**`setenv`**](setenv.bat) command also displays the path of the tools:

<pre style="margin:10px 0 0 30px;font-size:80%;">
> setenv -verbose
Tool versions:
   javac 1.8.0_191, java 1.8.0_191, scalac 2.12.7, dotc 0.10.0,
   ant 1.10.5, gradle 4.10.2, mvn 3.6.0, sbt 1.2.6/2.12.17,
   cfr 0.136, git 2.19.2.windows.1, diff 3.6
Tool paths:
   C:\Program Files\Java\jdk1.8.0_191\bin\javac.exe
   C:\Program Files\Java\jdk1.8.0_191\bin\java.exe
   C:\Program Files (x86)\Common Files\Oracle\Java\javapath\java.exe
   C:\ProgramData\Oracle\Java\javapath\java.exe
   C:\opt\scala-2.12.7\bin\scalac.bat
   C:\opt\dotty-0.10.0\bin\dotc.bat
   C:\opt\apache-ant-1.10.5\bin\ant.bat
   C:\opt\gradle-4.10.2\bin\gradle.bat
   C:\opt\apache-maven-3.6.0\bin\mvn.cmd
   C:\opt\sbt-1.2.6\bin\sbt.bat
   C:\opt\cfr-0.136\bin\cfr.bat
   C:\opt\Git-2.19.2\bin\git.exe
   C:\opt\Git-2.19.2\usr\bin\diff.exe
</pre>

#### `cleanup.bat`

The [**`cleanup`**](bin/cleanup.bat) command removes the output directories (ie. **`target\`**) from the example projets: 

<pre style="margin:10px 0 0 30px;font-size:80%;">
> cleanup
Finished to clean up 16 subdirectories in W:\dotty\examples
Finished to clean up 12 subdirectories in W:\dotty\myexamples
</pre>

#### `dirsize.bat {<dir_name>}`

The [**`dirsize`**](bin/dirsize.bat) command returns the size (in Kb, Mb or Gb) of the specified directory paths:

<pre style="margin:10px 0 0 30px;font-size:80%;">
> dirsize examples myexamples c:\opt\dotty-0.10.0
Size of directory "examples" is 3.9 Mb
Size of directory "myexamples" is 1.2 Mb
Size of directory "c:\opt\dotty-0.10.0" is 22.4 Mb
</pre>

#### `getnightly.bat`

By default the [**`getnightly`**](bin/getnightly.bat) command downloads the library files of the latest Dotty nightly build available from the [Maven Central Repository](https://search.maven.org/search?q=g:ch.epfl.lamp) and saves them into directory **`nightly-jars\`**.

<pre style="margin:10px 0 0 30px;font-size:80%;">
> getnightly

> dir /b nightly-jars
dotty-compiler_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar
dotty-doc_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar
dotty-interfaces-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar
dotty-language-server_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar
dotty-library_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar
dotty_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar
</pre>

> **NB.** Execute **`getnightly help`** to display the help message.

With option **`-verbose`** the [**`getnightly`**](bin/getnightly.bat) command also displays the download progress:

<pre style="margin:10px 0 0 30px;font-size:80%">
> getnightly -verbose
Downloading file dotty-language-server_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar ... 101.6 Kb
Downloading file dotty-doc_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar ... 997.4 Kb
Downloading file dotty-compiler_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar ... 9.1 Mb
Downloading file dotty_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar ... 0.3 Kb
Downloading file dotty-library_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar ... 555.1 Kb
Downloading file dotty-interfaces-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar ... 3.4 Kb
Finished to download 6 files to directory W:\dotty\nightly-jars
</pre>

We can now replace the library files from the original [Dotty distribution](https://github.com/lampepfl/dotty/releases) (installed in directory **`C:\opt\dotty-0.10.0\`** in our case) with library files from the latest nightly build.

Concretely, we specify the **`activate`** subcommand to switch to the nightly build version and the **`reset`** subcommand to restore the original library files in the Dotty installation directory.
<pre style="margin:10px 0 0 30px;font-size:80%;">
> getnightly activate
Finished to download 6 files to directory W:\dotty\nightly-jars
Local nightly version has changed from unknown to 0.11.0-bin-20181109-a9029dc-NIGHTLY
Activate nightly build libraries: 0.11.0-bin-20181109-a9029dc-NIGHTLY

> dotc -version
Dotty compiler version 0.11.0-bin-20181109-a9029dc-NIGHTLY-git-a9029dc -- Copyright 2002-2018, LAMP/EPFL

> getnightly reset
Activate default Dotty libraries: 0.10.0

> dotc -version
Dotty compiler version 0.10.0 -- Copyright 2002-2018, LAMP/EPFL
</pre>

> **NB.** You need to have *write access* to the Dotty installation directory (e.g. **`C:\opt\dotty-0.10.0\`** in our case) in order to run the **`activate/reset`** subcommands.<br/> Internally the [**`getnightly`**](bin/getnightly.bat) command manages two sets of libraries files which are organized as follows:
> <pre style="margin:10px 0 0 30px;font-size:80%;">
> > pushd c:\opt\dotty-0.10.0&dir/b/a-d&for /f %i in ('dir/s/b/ad lib') do @(echo lib\%~nxi\&dir/b %i)&popd
> VERSION
> VERSION-NIGHTLY
> lib\0.10.0\
> &nbsp;&nbsp;dist_0.10-0.10.0.jar
> &nbsp;&nbsp;dotty-compiler_0.10-0.10.0.jar
> &nbsp;&nbsp;dotty-doc_0.10-0.10.0.jar
> &nbsp;&nbsp;dotty-interfaces-0.10.0.jar
> &nbsp;&nbsp;dotty-library_0.10-0.10.0.jar
> lib\0.11.0-bin-20181109-a9029dc-NIGHTLY\
> &nbsp;&nbsp;dotty-compiler_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar
> &nbsp;&nbsp;dotty-doc_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar
> &nbsp;&nbsp;dotty-interfaces-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar
> &nbsp;&nbsp;dotty-language-server_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar
> &nbsp;&nbsp;dotty-library_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar
> &nbsp;&nbsp;dotty_0.11-0.11.0-bin-20181109-a9029dc-NIGHTLY.jar
> </pre>
> In the above output the file **`VERSION-NIGHTLY`** contains the signature of the managed nightly build and the **`lib\`** directory contains two backup directories with copies of the library files from the original Dotty installation respectively from the latest nightly build.

#### `searchjars.bat <class_name>`

Passing argument **`System`** to the [**`searchjars`**](bin/searchjars.bat) command prints the following output (classfile names are printed with full path and are prefixed with their containing [JAR file](https://docs.oracle.com/javase/8/docs/technotes/guides/jar/jarGuide.html)):
<pre style="margin:10px 0 0 30px;font-size:80%;">
> searchjars System
Search for class System in library files C:\opt\dotty-0.10.0\lib\*.jar
  scala-library-2.12.7.jar:scala/sys/SystemProperties$.class
  scala-library-2.12.7.jar:scala/sys/SystemProperties.class
  scala-xml_2.12-1.1.0.jar:scala/xml/dtd/SystemID$.class
  scala-xml_2.12-1.1.0.jar:scala/xml/dtd/SystemID.class
Search for class System in library files C:\opt\scala-2.12.7\lib\*.jar
  scala-library.jar:scala/sys/SystemProperties$.class
  scala-library.jar:scala/sys/SysctemProperties.class
  scala-xml_2.12-1.0.6.jar:scala/xml/dtd/SystemID$.class
  scala-xml_2.12-1.0.6.jar:scala/xml/dtd/SystemID.class
</pre>

Searching for an unknown class - e.g. **`BinarySearch`** - produces the following output:
<pre style="margin:10px 0 0 30px;font-size:80%;">
> searchjars BinarySearch
Search for class BinarySearch in library files C:\opt\dotty-0.10.0\lib\*.jar
Search for class BinarySearch in library files C:\opt\scala-2.12.7\lib\*.jar
</pre>

#### `timeit.bat <cmd_1> { & <cmd_i> }`

The [**`timeit`**](bin/timeit.bat) command prints the execution time (`hh:MM:ss`) of the specified command (possibly given with options and parameters):
<pre style="margin:10px 0 0 30px;font-size:80%;">
> timeit dir /b
.gitignore
.gradle
build.bat
build.gradle
build.sbt
build.xml
pom.xml
project
settings.gradle
src
target
Execution time: 00:00:01
> timeit build clean compile
Execution time: 00:00:08
</pre>

Chaining of commands is also possible. Note that the command separator (either **`&&`** or **`&`**) must be escaped if the command chain is not quoted. For instance:

<pre style="margin:10px 0 0 30px;font-size:80%;">
> timeit build clean compile ^&^& ant run
...
Execution time: 00:00:11
> timeit "build clean compile && ant run"
...
Execution time: 00:00:11
</pre>

> **NB.** The **`&&`** command separator performs error checking - that is, the commands to the right of the **`&&`** command run ***if and only if*** the command to the left of **`&&`** succeeds. The **`&`** command ***does not*** perform error checking - that is, all commands run.

<!--
#### `touch.bat`

The [**`touch.bat`**](bin/touch.bat) command
-->

#### `build.bat`

The [**`build`**](examples/enum-Planet/build.bat) command is a basic build tool consisting of ~350 lines of batch/[Powershell ](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) code <sup id="anchor_01">[[1]](#footnote_01)</sup>. 

- Running the **`build`** command with no build option in project [**`examples\enum-Planet`**](examples/enum-Planet/) generates the following output:
<pre style="margin:10px 0 0 30px;font-size:80%;">
> build clean compile run
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
</pre>

- Running the [**`build`**](examples/enum-Planet/build.bat) command with build option **`-debug`** in project [**`examples\enum-Planet`**](examples/enum-Planet/) also displays internal steps of the build process:
<pre style="margin:10px 0 0 30px;font-size:80%;">
> build -debug clean compile run
[build] _CLEAN=1 _COMPILE=1 _COMPILE_CMD=dotc _RUN=1
[build] del /s /q W:\dotty\examples\ENUM-P~1\target\classes\*.class W:\dotty\examples\ENUM-P~1\target\classes\*.hasTasty W:\dotty\examples\ENUM-P~1\target\classes\.latest-build
[build] 20180322224754 W:\dotty\examples\ENUM-P~1\src\main\scala\Planet.scala
[build] 00000000000000 W:\dotty\examples\ENUM-P~1\target\classes\.latest-build
[build] dotc  -classpath W:\dotty\examples\ENUM-P~1\target\classes -d C:\dotty\examples\ENUM-P~1\target\classes  W:\dotty\examples\ENUM-P~1\src\main\scala\Planet.scala
[build] dot -classpath W:\dotty\examples\ENUM-P~1\target\classes Planet 1
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
[build] _EXITCODE=0
</pre>

- Compilation of the Java/Scala source files is performed only if needed during the build process:

<pre style="margin:10px 0 0 30px;font-size:80%;">
> build clean

> build compile

> build compile
No compilation needed (1 source files)
</pre>

> **NB.** The above `enum-Planet` example expects 1 argument at execution time.<br/>
> For simplicity the [**`build`**](examples/enum-Planet/build.bat) command currently relies on the property `main.args` defined in file [**`project\build.properties`**](examples/enum-Planet/project/build.properties) (part of the SBT configuration) to specify program arguments.<br/>
> <pre style="margin:10px 0 0 30px;font-size:80%;">
> > type project\build.properties
> sbt.version=1.2.6
> main.class=Planet
> main.args=1
> </pre>
> With SBT you have to run the example as follows:<br/>
> <pre style="margin:10px 0 0 30px;font-size:80%;">
> > sbt clean compile "run 1"
> > sbt "run 1"
> </pre>

#### `dotr.bat`

[Dotty REPL](https://docs.scala-lang.org/overviews/repl/overview.html) is an interactive tool for evaluating Scala expressions. Internally, it executes a source script by wrapping it in a template and then compiling and executing the resulting program.
   > **NB.** The batch file [**`dotr.bat`**](bin/0.9/dotr.bat) is based on the bash script [**`dotr`**](https://github.com/lampepfl/dotty/blob/master/dist/bin/dotr) available from the standard [Dotty distribution](https://github.com/lampepfl/dotty/releases).
<pre style="margin:10px 0 0 30px;font-size:80%;">
> where dotr
C:\opt\dotty-0.10.0\bin\dotr
C:\opt\dotty-0.10.0\bin\dotr.bat

> dotr -version
java version "1.8.0_191"
Java(TM) SE Runtime Environment (build 1.8.0_191-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.191-b12, mixed mode)

> dotr
Starting dotty REPL...
scala> :help
The REPL has several commands available:

:help                    print this summary
:load &lt;path&gt;             interpret lines in a file
:quit                    exit the interpreter
:type &lt;expression&gt;       evaluate the type of the given expression
:imports                 show import history
:reset                   reset the repl to its initial state, forgetting all session entries

scala> System.getenv().get("JAVA_HOME")
val res0: String = C:\Progra~1\Java\jdk1.8.0_191

scala> System.getenv().get("DOTTY_HOME")
val res1: String = C:\opt\dotty-0.10.0

scala> :load myexamples/HelloWorld/src/main/scala/HelloWorld.scala
// defined object HelloWorld

scala> HelloWorld.main(Array())
Hello world!

scala>:quit
</pre>

## Footnotes

<!-- ## removed on 2018-11-23 ##
<a name="footnote_01">[1]</a> ***2018-07-07*** [↩](#anchor_01)

<div style="margin:0 0 0 20px;">
Version 0.9 of the Dotty compiler is not compatible with versions 9 and 10 of <a href="https://docs.oracle.com/javase/9/install/overview-jdk-9-and-jre-9-installation.htm">Java JRE</a>; a <strong><code>java.lang.IncompatibleClassChangeError</code></strong> exception is thrown when starting the <strong><code>dotc</code></strong> command:
</div>
-->

<!--
C:\Progra~1\Java\jre-10.0.2\bin\java.exe -Xmx768m -Xms768m -classpath C:\opt\dotty-0.9.0\lib\scala-library-2.12.6.jar;C:\opt\dotty-0.9.0\lib\scala-xml_2.12-1.1.0.jar;C:\opt\dotty-0.9.0\lib\scala-asm-6.0.0-scala-1.jar;C:\opt\dotty-0.9.0\lib\compiler-interface-1.1.6.jar;C:\opt\dotty-0.9.0\lib\dotty-interfaces-0.9.0.jar;C:\opt\dotty-0.9.0\lib\dotty-library_0.9-0.9.0.jar;C:\opt\dotty-0.9.0\lib\dotty-compiler_0.9-0.9.0.jar -Dscala.usejavacp=true dotty.tools.dotc.Main

C:\Progra~1\Java\jre-10.0.2\bin\java.exe -Xmx768m -Xms768m -classpath C:\opt\dotty-0.10.0\lib\scala-library-2.12.7.jar;C:\opt\dotty-0.10.0\lib\scala-xml_2.12-1.1.0.jar;C:\opt\dotty-0.10.0\lib\scala-asm-6.0.0-scala-1.jar;C:\opt\dotty-0.10.0\lib\compiler-interface-1.2.2.jar;C:\opt\dotty-0.10.0\lib\dotty-interfaces-0.10.0.jar;C:\opt\dotty-0.10.0\lib\dotty-library_0.10-0.10.0.jar;C:\opt\dotty-0.10.0\lib\dotty-compiler_0.10-0.10.0.jar -Dscala.usejavacp=true dotty.tools.dotc.Main
-->

<!--
<pre style="margin:10px 0 0 20px;font-size:80%;">
> C:\Progra~1\Java\jre-10.0.2\bin\java.exe -Xmx768m -Xms768m \
-classpath C:\opt\dotty-0.9.0\lib\scala-library-2.12.6.jar; \
C:\opt\dotty-0.9.0\lib\scala-xml_2.12-1.1.0.jar; \
C:\opt\dotty-0.9.0\lib\scala-asm-6.0.0-scala-1.jar; \
C:\opt\dotty-0.9.0\lib\compiler-interface-1.1.6.jar; \
C:\opt\dotty-0.9.0\lib\dotty-interfaces-0.9.0.jar; \
C:\opt\dotty-0.9.0\lib\dotty-library_0.9-0.9.0.jar; \
C:\opt\dotty-0.9.0\lib\dotty-compiler_0.9-0.9.0.jar \
-Dscala.usejavacp=true dotty.tools.dotc.Main
Exception in thread "main" java.lang.IncompatibleClassChangeError: Method dotty.tools.dotc.core.Phases$PhasesBase.dotty$tools$dotc$core$Phases$PhasesBase$$initial$myTyperPhase()Ldotty/tools/dotc/core/Phases$Phase; must be InterfaceMethodref constant
        at dotty.tools.dotc.core.Contexts$ContextBase.<init>(Contexts.scala:544)
        at dotty.tools.dotc.Driver.initCtx(Driver.scala:41)
        at dotty.tools.dotc.Driver.process(Driver.scala:98)
        at dotty.tools.dotc.Driver.process(Driver.scala:115)
        at dotty.tools.dotc.Driver.main(Driver.scala:142)
        at dotty.tools.dotc.Main.main(Main.scala)
</pre>

> [***Oracle Java SE Support Roadmap***](http://www.oracle.com/technetwork/java/eol-135779.html)<br/>
> Oracle will not post further updates of Java SE 8 to its public download sites for commercial use after January 2019.
-->

<a name="footnote_01">[1]</a> ***2018-05-09*** [↩](#anchor_01)

<div style="margin:0 0 1em 20px;"> 
Command Prompt has been around for as long as we can remember, but starting with Windows 10 build 14971, Microsoft is trying to make PowerShell the <a href="https://support.microsoft.com/en-us/help/4027690/windows-powershell-is-replacing-command-prompt">main command shell</a> in the operating system.
</div>

<hr style="margin:2em 0 0 0;" />

*[mics](http://lampwww.epfl.ch/~michelou/)/November 2018*

