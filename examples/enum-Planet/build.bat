@echo off
setlocal enabledelayedexpansion

rem only for interactive debugging !
set _DEBUG=0

rem ##########################################################################
rem ## Environment setup

set _EXITCODE=0

set _BASENAME=%~n0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

call :env
if not %_EXITCODE%==0 goto end

call :props
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_COMPILE%==1 (
    call :compile
    if not !_EXITCODE!==0 goto end
)
if %_DOC%==1 (
    call :doc
    if not !_EXITCODE!==0 goto end
)
if %_RUN%==1 (
    call :run
    if not !_EXITCODE!==0 goto end
)
if %_TEST%==1 (
    call :test
    if not !_EXITCODE!==0 goto end
)
goto end

rem ##########################################################################
rem ## Subroutines

rem output parameters: _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
rem                    _TARGET_DIR, _CLASSES_DIR, _TASTY_CLASSES_DIR
:env
rem ANSI colors in standard Windows 10 shell
rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _DEBUG_LABEL=[46m[%_BASENAME%][0m
set _ERROR_LABEL=[91mError[0m:
set _WARNING_LABEL=[93mWarning[0m:

set _SOURCE_DIR=%_ROOT_DIR%src
set _TARGET_DIR=%_ROOT_DIR%target
set _CLASSES_DIR=%_TARGET_DIR%\classes
set _TASTY_CLASSES_DIR=%_TARGET_DIR%\tasty-classes
set _TEST_CLASSES_DIR=%_TARGET_DIR%\test-classes
set _DOCS_DIR=%_TARGET_DIR%\docs
goto :eof

rem output parameters: _MAIN_CLASS_DEFAULT, _MAIN_ARGS_DEFAULT
:props
set _MAIN_CLASS_DEFAULT=Main
set _MAIN_ARGS_DEFAULT=

set __PROPS_FILE=%_ROOT_DIR%project\build.properties
if exist "%__PROPS_FILE%" (
    for /f "tokens=1,* delims==" %%i in (%__PROPS_FILE%) do (
        set _NAME=%%~i
        set _VALUE=%%~j
        set _NAME=!_NAME:.=_!
        if not "!_NAME!"=="" (
            rem trim value
            for /f "tokens=*" %%v in ("!_VALUE!") do set _VALUE=%%v
            set _!_NAME: =!=!_VALUE!
        )
    )
    if defined _main_class set _MAIN_CLASS_DEFAULT=!_main_class!
    if defined _main_args set _MAIN_ARGS_DEFAULT=!_main_args!
)
goto :eof

rem input parameter: %*
:args
set _CLEAN=0
set _COMPILE=0
set _COMPILE_TIME=0
set _DOC=0
set _DOTTY=1
set _HELP=0
set _MAIN_CLASS=%_MAIN_CLASS_DEFAULT%
set _MAIN_ARGS=%_MAIN_ARGS_DEFAULT%
set _RUN=0
set _SCALAC_OPTS=-deprecation -feature
set _SCALAC_OPTS_EXPLAIN=0
set _SCALAC_OPTS_EXPLAIN_TYPES=0
set _TASTY=0
set _TEST=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _HELP=1
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    rem option
    if /i "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if /i "%__ARG%"=="-dotty" ( set _DOTTY=1
    ) else if /i "%__ARG%"=="-explain" ( set _SCALAC_OPTS_EXPLAIN=1
    ) else if /i "%__ARG%"=="-explain-types" ( set _SCALAC_OPTS_EXPLAIN_TYPES=1
    ) else if /i "%__ARG%"=="-help" ( set _HELP=1
    ) else if /i "%__ARG%"=="-scala" ( set _DOTTY=0
    ) else if /i "%__ARG%"=="-tasty" ( set _TASTY=1
    ) else if /i "%__ARG%"=="-timer" ( set _COMPILE_TIME=1
    ) else if /i "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else if /i "%__ARG:~0,6%"=="-main:" (
        call :set_main "!__ARG:~6!"
        if not !_EXITCODE!== 0 goto :eof
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    rem subcommand
    set /a __N+=1
    if /i "%__ARG%"=="clean" ( set _CLEAN=1
    ) else if /i "%__ARG%"=="compile" ( set _COMPILE=1
    ) else if /i "%__ARG%"=="doc" ( set _DOC=1
    ) else if /i "%__ARG%"=="help" ( set _HELP=1
    ) else if /i "%__ARG%"=="run" ( set _COMPILE=1& set _RUN=1
    ) else if /i "%__ARG%"=="test" ( set _COMPILE=1& set _TEST=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
)
shift
goto :args_loop
:args_done
if %_SCALAC_OPTS_EXPLAIN%==1 set _SCALAC_OPTS=%_SCALAC_OPTS% -explain
if %_SCALAC_OPTS_EXPLAIN_TYPES%==1 (
    if !_DOTTY!==1 ( set _SCALAC_OPTS=%_SCALAC_OPTS% -explain-types
    ) else ( set _SCALAC_OPTS=%_SCALAC_OPTS% -explaintypes
    )
)
if %_DEBUG%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TOTAL_TIME_START=%%i
    echo %_DEBUG_LABEL% _CLEAN=%_CLEAN% _COMPILE=%_COMPILE% _DOC=%_DOC% _DOTTY=%_DOTTY% _RUN=%_RUN% 1>&2
)
goto :eof

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug           show commands executed by this script
echo     -dotty           use Scala 3 tools ^(default^)
echo     -explain         set compiler option -explain
echo     -explain-types   set compiler option -explain-types
echo     -main:^<name^>     define main class name
echo     -scala           use Scala 2 tools
echo     -tasty           compile both from source and TASTy files
echo     -timer           display compile time
echo     -verbose         display progress messages
echo.
echo   Subcommands:
echo     clean            delete generated class files
echo     compile          compile source files ^(Java and Scala^)
echo     doc              generate documentation
echo     help             display this help message
echo     run              execute main class
echo     test             execute tests
echo.
echo   Properties:
echo   ^(to be defined in SBT configuration file project\build.properties^)
echo     compiler.cmd     alternative to option -compiler
echo     main.class       alternative to option -main
echo     main.args        list of arguments to be passed to main class
goto :eof

rem output parameter: _MAIN_CLASS
:set_main
set __ARG=%~1
set __VALID=0
for /f %%i in ('powershell -C "$s='%__ARG%'; if($s -match '^[\w$]+(\.[\w$]+)*$'){1}else{0}"') do set __VALID=%%i
rem if %_DEBUG%==1 echo %_DEBUG_LABEL% __ARG=%__ARG% __VALID=%__VALID%
if %__VALID%==0 (
    echo %_ERROR_LABEL% Invalid class name passed to option "-main" ^(%__ARG%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set _MAIN_CLASS=%__ARG%
goto :eof

:clean
call :rmdir "%_ROOT_DIR%out"
call :rmdir "%_TARGET_DIR%"
goto :eof

rem input parameter(s): %1=directory path
:rmdir
set __DIR=%~1
if not exist "%__DIR%\" goto :eof
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% rmdir /s /q "%__DIR%" 1>&2
) else if %_VERBOSE%==1 ( echo Delete directory !__DIR:%_ROOT_DIR%=! 1>&2
)
rmdir /s /q "%__DIR%"
if not %ERRORLEVEL%==0 (
    set _EXITCODE=1
    goto :eof
)
goto :eof

:compile
if %_COMPILE_TIME%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __COMPILE_TIME_START=%%i
)
if not exist "%_CLASSES_DIR%" mkdir "%_CLASSES_DIR%" 1>NUL

set "__TIMESTAMP_FILE=%_CLASSES_DIR%\.latest-build"

call :compile_required "%__TIMESTAMP_FILE%" "%_SOURCE_DIR%\main\java\*.java"
if %_COMPILE_REQUIRED%==1 (
    call :compile_java
    if not !_EXITCODE!==0 goto :eof
)
call :compile_required "%__TIMESTAMP_FILE%" "%_SOURCE_DIR%\main\scala\*.scala"
if %_COMPILE_REQUIRED%==1 (
    call :compile_scala
    if not !_EXITCODE!==0 goto :eof
)
for /f %%i in ('powershell -C "Get-Date -uformat %%Y%%m%%d%%H%%M%%S"') do (
    echo %%i> "%__TIMESTAMP_FILE%"
)
if %_COMPILE_TIME%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set __COMPILE_TIME_END=%%i
    call :duration "%__COMPILE_TIME_START%" "!__COMPILE_TIME_END!"
    echo Compile time: !_DURATION! 1>&2
)
goto :eof

:init_java
if defined _JAVAC_CMD goto :eof
set __JAVA_BIN_DIR=
for /f %%i in ('where javac.exe 2^>NUL') do set "__JAVA_BIN_DIR=%%~dpi"
if defined __JAVA_BIN_DIR (
    set "_JAVA_CMD=%__JAVA_BIN_DIR%\java.exe"
    set "_JAVAC_CMD=%__JAVA_BIN_DIR%\javac.exe"
    set "_JAVADOC_CMD=%__JAVA_BIN_DIR%\javadoc.exe"
) else if defined JAVA_HOME (
    set "_JAVA_CMD=%JAVA_HOME%\bin\java.exe"
    set "_JAVAC_CMD=%JAVA_HOME%\bin\javac.exe"
    set "_JAVADOC_CMD=%JAVA_HOME%\bin\javadoc.exe"
) else (
   echo %_ERROR_LABEL% Command javac.exe not found 1>&2
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile_java
call :init_java
if not %_EXITCODE%==0 goto :eof

set __LIST_FILE=%_TARGET_DIR%\java_files.txt
if exist "%__LIST_FILE%" del "%__LIST_FILE%" 1>NUL
for /f %%i in ('dir /s /b "%_SOURCE_DIR%\main\java\*.java" 2^>NUL') do (
    echo %%i >> "%__LIST_FILE%"
)
call :libs_cpath
set __JAVAC_OPTS=-classpath "%_LIBS_CPATH%%_CLASSES_DIR%" -d %_CLASSES_DIR%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_JAVAC_CMD% %__JAVAC_OPTS% @"%__LIST_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile Java source files to directory !_CLASSES_DIR:%_ROOT_DIR%=! 1>&2
)
%_JAVAC_CMD% %__JAVAC_OPTS% @"%__LIST_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Compilation of main Java source files failed 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:init_scala
if defined _SCALAC_CMD goto :eof
set __SCALA[0]=scala.bat
set __SCALA[1]=dotr.bat
set __SCALAC[0]=scalac.bat
set __SCALAC[1]=dotc.bat
set __SCALADOC[0]=scaladoc.bat
set __SCALADOC[1]=dotd.bat

set __SCALA_BIN_DIR=
for /f %%i in ('where "!__SCALAC[%_DOTTY%]!" 2^>NUL') do set "__SCALA_BIN_DIR=%%~dpi"
if defined __SCALA_BIN_DIR (
    set "_SCALA_CMD=%__SCALA_BIN_DIR%\!__SCALA[%_DOTTY%]!"
    set "_SCALAC_CMD=%__SCALA_BIN_DIR%\!__SCALAC[%_DOTTY%]!"
    set "_SCALADOC_CMD=%__SCALA_BIN_DIR%\!__SCALADOC[%_DOTTY%]!"
) else if defined SCALA_HOME (
    set "_SCALA_CMD=%SCALA_HOME%\bin\!__SCALA[%_DOTTY%]!"
    set "_SCALAC_CMD=%SCALA_HOME%\bin\!__SCALAC[%_DOTTY%]!"
    set "_SCALADOC_CMD=%SCALA_HOME%\bin\!__SCALADOC[%_DOTTY%]!"
) else (
   echo %_ERROR_LABEL% Command !__SCALAC[%_DOTTY%]! not found 1>&2
   set _EXITCODE=1
   goto :eof
)
goto :eof

:compile_scala
call :init_scala
if not %_EXITCODE%==0 goto :eof

set __LIST_FILE=%_TARGET_DIR%\scala_files.txt
if exist "%__LIST_FILE%" del "%__LIST_FILE%" 1>NUL
for /f %%i in ('dir /s /b "%_SOURCE_DIR%\main\scala\*.scala" 2^>NUL') do (
    echo %%i >> "%__LIST_FILE%"
)
set __SCALAC_OPTS=%_SCALAC_OPTS% -classpath "%_CLASSES_DIR%" -d %_CLASSES_DIR%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_SCALAC_CMD% %__SCALAC_OPTS% "@%__LIST_FILE%" 1>&2
) else if %_VERBOSE%==1 ( echo Compile Scala source files to directory !_CLASSES_DIR:%_ROOT_DIR%=! 1>&2
)
call %_SCALAC_CMD% %__SCALAC_OPTS% "@%__LIST_FILE%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Compilation of Scala source files failed 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_TASTY%==1 (
    if not exist "%_TASTY_CLASSES_DIR%\" mkdir "%_TASTY_CLASSES_DIR%"
    set __CLASS_NAMES=
    for %%f in (%_CLASSES_DIR%\*.tasty) do (
        set __CLASS_NAME=%%f
        set __CLASS_NAMES=!__CLASS_NAMES! !__CLASS_NAME:~0,-6!
    )
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_SCALAC_CMD% -from-tasty !__CLASS_NAMES! -classpath %_CLASSES_DIR% -d %_TASTY_CLASSES_DIR% 1>&2
    ) else if %_VERBOSE%==1 ( echo Compile TASTy files to !_TASTY_CLASSES_DIR:%_ROOT_DIR%=! 1>&2
    )
    call %_SCALAC_CMD% -from-tasty !__CLASS_NAMES! -classpath %_CLASSES_DIR% -d %_TASTY_CLASSES_DIR%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Scala compilation from TASTy files failed 1>&2
        set _EXITCODE=1
    )
    if not !_EXITCODE!==0 goto :eof
)
goto :eof

rem input parameter: 1=timestamp file 2=path (wildcards accepted)
rem output parameter: _COMPILE_REQUIRED
:compile_required
set __TIMESTAMP_FILE=%~1
set __PATH=%~2

set __SOURCE_TIMESTAMP=00000000000000
for /f "usebackq" %%i in (`powershell -c "gci -recurse '%__PATH%' | sort LastWriteTime | select -last 1 -expandProperty LastWriteTime | Get-Date -uformat %%Y%%m%%d%%H%%M%%S"`) do (
    set __SOURCE_TIMESTAMP=%%i
)
if exist "%__TIMESTAMP_FILE%" ( set /p __GENERATED_TIMESTAMP=<%__TIMESTAMP_FILE%
) else ( set __GENERATED_TIMESTAMP=00000000000000
)
if %_DEBUG%==1 echo %_DEBUG_LABEL% %__GENERATED_TIMESTAMP% %__TIMESTAMP_FILE% 1>&2

call :newer %__SOURCE_TIMESTAMP% %__GENERATED_TIMESTAMP%
set _COMPILE_REQUIRED=%_NEWER%
if %_VERBOSE%==1 if %_COMPILE_REQUIRED%==0 if %__SOURCE_TIMESTAMP% gtr 0 (
    echo No compilation needed ^("%__PATH%"^) 1>&2
)
goto :eof

rem output parameter: _NEWER
:newer
set __TIMESTAMP1=%~1
set __TIMESTAMP2=%~2

set __TIMESTAMP1_DATE=%__TIMESTAMP1:~0,8%
set __TIMESTAMP1_TIME=%__TIMESTAMP1:~-6%

set __TIMESTAMP2_DATE=%__TIMESTAMP2:~0,8%
set __TIMESTAMP2_TIME=%__TIMESTAMP2:~-6%

if %__TIMESTAMP1_DATE% gtr %__TIMESTAMP2_DATE% ( set _NEWER=1
) else if %__TIMESTAMP1_DATE% lss %__TIMESTAMP2_DATE% ( set _NEWER=0
) else if %__TIMESTAMP1_TIME% gtr %__TIMESTAMP2_TIME% ( set _NEWER=1
) else ( set _NEWER=0
)
goto :eof

rem input parameter: %1=include Dotty libs
rem output parameter: _LIBS_CPATH
:libs_cpath
set __INCLUDE_DOTTY=%~1

set _LIBS_CPATH=

if defined __INCLUDE_DOTTY if exist "%DOTTY_HOME%\lib\" (
    for %%i in (%DOTTY_HOME%\lib\*.jar) do (
        set _LIBS_CPATH=!_LIBS_CPATH!%%i;
    )
)
for %%f in ("%~dp0\..") do set __PARENT_DIR=%%~sf
if exist "%__PARENT_DIR%\lib\" (
    for %%i in (%__PARENT_DIR%\lib\*.jar) do (
        set _LIBS_CPATH=!_LIBS_CPATH!%%i;
    )
)
if exist "%_ROOT_DIR%\lib\" (
    for %%i in (%_ROOT_DIR%\lib\*.jar) do (
        set _LIBS_CPATH=!_LIBS_CPATH!%%i;
    )
)
goto :eof

:doc
call :init_scala
if not %_EXITCODE%==0 goto :eof

if not exist "%_DOCS_DIR%" mkdir "%_DOCS_DIR%" 1>NUL

set __DOC_TIMESTAMP_FILE=%_DOCS_DIR%\.latest-build

call :compile_required "%__DOC_TIMESTAMP_FILE%" "%_SOURCE_DIR%\main\scala\*.scala"
if %_COMPILE_REQUIRED%==0 goto :eof

set __SCALA_SOURCE_FILES=
for %%i in (%_SOURCE_DIR%\main\scala\*.scala) do (
    set __SCALA_SOURCE_FILES=!__SCALA_SOURCE_FILES! %%i
)

for %%i in ("%~dp0\.") do set __PROJECT=%%~ni
set __SCALADOC_OPTS=-siteroot %_DOCS_DIR% -project %__PROJECT% -project-version 0.1-SNAPSHOT

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_SCALADOC_CMD% %__SCALADOC_OPTS% %__SCALA_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Generate Dotty documentation into directory !_DOCS_DIR:%_ROOT_DIR%=! 1>&2
)
call %_SCALADOC_CMD% %__SCALADOC_OPTS% %__SCALA_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Scala documentation generation failed 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f %%i in ('powershell -C "Get-Date -uformat %%Y%%m%%d%%H%%M%%S"') do (
    echo %%i> "%__DOC_TIMESTAMP_FILE%"
)
goto :eof

:run
call :init_scala
if not %_EXITCODE%==0 goto :eof

set __MAIN_CLASS_FILE=%_CLASSES_DIR%\%_MAIN_CLASS:.=\%.class
if not exist "%__MAIN_CLASS_FILE%" (
    echo %_ERROR_LABEL% Main class '%_MAIN_CLASS%' not found ^(%__MAIN_CLASS_FILE%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
call :libs_cpath
set __SCALA_OPTS=%_SCALA_OPTS% -classpath "%_LIBS_CPATH%%_CLASSES_DIR%"

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_SCALA_CMD% %__SCALA_OPTS% %_MAIN_CLASS% %_MAIN_ARGS% 1>&2
) else if %_VERBOSE%==1 ( echo Execute Scala main class %_MAIN_CLASS% 1>&2
)
call %_SCALA_CMD% %__SCALA_OPTS% %_MAIN_CLASS% %_MAIN_ARGS%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Execution failed ^(%_MAIN_CLASS%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if %_TASTY%==1 (
    if not exist "%_TASTY_CLASSES_DIR%" (
        echo %_WARNING_LABEL% TASTy output directory not found 1>&2
        set _EXITCODE=1
        goto :eof
    )
    set __SCALA_OPTS=-classpath "%_LIBS_CPATH%%_TASTY_CLASSES_DIR%;%_CLASSES_DIR%"

    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_SCALA_CMD% !__SCALA_OPTS! %_MAIN_CLASS% %_MAIN_ARGS% 1>&2
    ) else if %_VERBOSE%==1 ( echo Execute Scala main class %_MAIN_CLASS% ^(compiled from TASTy^) 1>&2
    )
    call %_SCALA_CMD% !__SCALA_OPTS! %_MAIN_CLASS% %_MAIN_ARGS%
    if not !ERRORLEVEL!==0 (
        echo %_ERROR_LABEL% Execution failed ^(%_MAIN_CLASS%^) 1>&2
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

:compile_test
if not exist "%_TEST_CLASSES_DIR%" mkdir "%_TEST_CLASSES_DIR%" 1>NUL

set "__TEST_TIMESTAMP_FILE=%_TEST_CLASSES_DIR%\.latest-build"

call :compile_required "%__TEST_TIMESTAMP_FILE%" "%__TEST_SOURCE_FILES%"
if %_COMPILE_REQUIRED%==0 goto :eof

set __TEST_SOURCE_FILES=
for %%i in (%_SOURCE_DIR%\test\scala\*.scala) do (
    set __TEST_SOURCE_FILES=!__TEST_SOURCE_FILES! %%i
)

call :libs_cpath 1
set __TEST_SCALAC_OPTS=%_SCALAC_OPTS% -classpath "%_LIBS_CPATH%%_CLASSES_DIR%;%_TEST_CLASSES_DIR%" -d %_TEST_CLASSES_DIR%

if %_DEBUG%==1 ( echo %_DEBUG_LABEL% %_SCALAC_CMD% %__TEST_SCALAC_OPTS% %__TEST_SOURCE_FILES% 1>&2
) else if %_VERBOSE%==1 ( echo Compile Scala test sources to !_TEST_CLASSES_DIR:%_ROOT_DIR%=! 1>&2
)
call %_SCALAC_CMD% %__TEST_SCALAC_OPTS% %__TEST_SOURCE_FILES%
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Compilation of test Scala sources failed 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f %%i in ('powershell -C "Get-Date -uformat %%Y%%m%%d%%H%%M%%S"') do (
    echo %%i> "%__TEST_TIMESTAMP_FILE%"
)
goto :eof

:test
call :compile_test
if not %_EXITCODE%==0 goto :eof

where /q java.exe
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% Java executable not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set __JAVA_CMD=java.exe

call :libs_cpath 1
set __TEST_RUN_OPTS=-classpath "%_LIBS_CPATH%%_CLASSES_DIR%;%_TEST_CLASSES_DIR%"

rem see https://github.com/junit-team/junit4/wiki/Getting-started
for %%i in (%_TEST_CLASSES_DIR%\*Test.class) do (
    set __MAIN_CLASS=%%~ni
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% java %__TEST_RUN_OPTS% org.junit.runner.JUnitCore !__MAIN_CLASS! 1>&2
	) else if %_VERBOSE%==1 ( echo Execute test !__MAIN_CLASS! 1>&2
	)
    %__JAVA_CMD% %__TEST_RUN_OPTS% org.junit.runner.JUnitCore !__MAIN_CLASS!
    if not !ERRORLEVEL!==0 (
        set _EXITCODE=1
        goto :eof
    )
)
goto :eof

rem output parameter: _DURATION
:duration
set __START=%~1
set __END=%~2

for /f "delims=" %%i in ('powershell -c "$interval = New-TimeSpan -Start '%__START%' -End '%__END%'; Write-Host $interval"') do set _DURATION=%%i
goto :eof

rem ##########################################################################
rem ## Cleanups

:end
if %_DEBUG%==1 (
    for /f "delims=" %%i in ('powershell -c "(Get-Date)"') do set _TOTAL_TIME_END=%%i
    call :duration "%_TOTAL_TIME_START%" "!_TOTAL_TIME_END!"
    echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% _DURATION=!_DURATION! 1>&2
)
exit /b %_EXITCODE%
endlocal
