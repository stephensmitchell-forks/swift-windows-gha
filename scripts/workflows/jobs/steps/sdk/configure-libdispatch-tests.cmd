if [%SW_DISPATCH_TEST_ENABLED%]==[NO] (
    echo Skipping Dispatch tests configuration
    goto :eof
)

cmake^
 -G Ninja^
 -S %SW_DISPATCH_SOURCES_DIR%^
 -B %SW_DISPATCH_BUILD_DIR%^
 -C %SW_WORKSPACE%\cmake\caches\windows-x86_64-clang.cmake^
 -D SWIFT_STDLIB_DIR=%SW_STDLIB_BUILD_DIR%^
 -C %SW_WORKSPACE%\cmake\caches\windows-x86_64-swift-flags.cmake^
 -D CMAKE_BUILD_TYPE=Release^
 -D CMAKE_INSTALL_PREFIX=%SW_SDK_INSTALL_DIR%^
 -D BUILD_TESTING=YES^
 -D ENABLE_SWIFT=YES
