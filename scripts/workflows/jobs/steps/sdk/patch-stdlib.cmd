setlocal

set SW_PUSHDIR=%CD%

set SW_LOG_PATCH_INFO=%SW_LOG_INFO% --scope patch-stdlib
set SW_LOG_PATCH_ERROR=%SW_LOG_ERROR% --scope patch-stdlib

set SW_PATCH_PRINT_FLUSH=%SW_WORKSPACE%\patch\swift\stdlib\print-flush-%SW_SWIFT_BRANCH_SPEC%.patch
set SW_PATCH_INSTALL_PDB=%SW_WORKSPACE%\patch\swift\stdlib\install-pdb.patch
set SW_PATCH_PRINT_BACKTRACE=%SW_WORKSPACE%\patch\swift\stdlib\print-backtrace.patch
set SW_PATCH_CONDITIONAL_EXPLCIT=%SW_WORKSPACE%\patch\swift\stdlib\21a4b135529dc83efb4065333e12328c1b77054a.patch

if [%SW_STDLIB_PATCH_ENABLED%]==[YES] (
  %SW_LOG_PATCH_INFO% --message="Will apply %SW_PATCH_PRINT_FLUSH%"
  set SW_PATCH_PRINT_FLUSH=git apply --verbose %SW_PATCH_PRINT_FLUSH%
) else (
  %SW_LOG_PATCH_INFO% --message="Will NOT apply %SW_PATCH_PRINT_FLUSH%"
  set SW_PATCH_PRINT_FLUSH=echo .
)

if [%SW_SWIFT_SDK_SPEC%]==[readdle] (
  %SW_LOG_PATCH_INFO% --message="Will apply %SW_PATCH_INSTALL_PDB%"
  set SW_PATCH_INSTALL_PDB=git apply --verbose %SW_PATCH_INSTALL_PDB%
  %SW_LOG_PATCH_INFO% --message="Will apply %SW_PATCH_PRINT_BACKTRACE%"
  set SW_PATCH_PRINT_BACKTRACE=git apply --verbose %SW_PATCH_PRINT_BACKTRACE%
) else (
  %SW_LOG_PATCH_INFO% --message="Will NOT apply %SW_PATCH_INSTALL_PDB%"
  set SW_PATCH_INSTALL_PDB=echo.
  %SW_LOG_PATCH_INFO% --message="Will NOT apply %SW_PATCH_PRINT_BACKTRACE%"
  set SW_PATCH_PRINT_BACKTRACE=echo.
)

if [%SW_SWIFT_BRANCH_SPEC%]==[5.2] (
  %SW_LOG_PATCH_INFO% --message="Will apply %SW_PATCH_CONDITIONAL_EXPLCIT%"
  set SW_PATCH_CONDITIONAL_EXPLCIT=git apply %SW_PATCH_CONDITIONAL_EXPLCIT%
) else (
  %SW_LOG_PATCH_INFO% --message="Will NOT apply %SW_PATCH_CONDITIONAL_EXPLCIT%"
  set SW_PATCH_CONDITIONAL_EXPLCIT=echo.
)

%SW_LOG_PATCH_INFO% --message="Working in %SW_SWIFT_SOURCES_DIR%"

cd /d %SW_SWIFT_SOURCES_DIR%^
 && git config user.name 'builder'^
 && git config user.email 'builder@lxbndr.org'^
 && %SW_PATCH_PRINT_FLUSH%^
 && %SW_PATCH_INSTALL_PDB%^
 && %SW_PATCH_PRINT_BACKTRACE%^
 && %SW_PATCH_CONDITIONAL_EXPLCIT%

set SW_ERROR=%ERRORLEVEL%

%SW_LOG_PATCH_INFO% --message="Restoring original working directory %SW_PUSHDIR%"
cd /d %SW_PUSHDIR%

if not %SW_ERROR% equ 0 %SW_LOG_PATCH_ERROR% --message="Patch failed"

endlocal & exit /b %SW_ERROR%