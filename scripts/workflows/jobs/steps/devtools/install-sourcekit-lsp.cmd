setlocal enabledelayedexpansion

%SW_PRE_STEP% --scope="devtools" --name="Install sourcekit-lsp" --flag=SW_SKIP_DEVTOOLS_SOURCEKIT
if errorlevel 1 exit /b 0

cmake --build %SW_SOURCEKIT_BUILD_DIR% --target install

endlocal
