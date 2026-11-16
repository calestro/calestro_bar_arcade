#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  // 1. Obtém a resolução real da tela do seu Arcade
  int screen_width = GetSystemMetrics(SM_CXSCREEN);
  int screen_height = GetSystemMetrics(SM_CYSCREEN);

  FlutterWindow window(project);
  Win32Window::Point origin(0, 0);
  Win32Window::Size size(screen_width, screen_height);
  
  if (!window.Create(L"arcade_calestro_bar", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  // --- CONFIGURAÇÃO ARCADE (FULLSCREEN E MOUSE OCULTO) ---
  HWND hwnd = window.GetHandle();

  // Remove a barra de título e as bordas (Borderless Fullscreen)
  LONG_PTR style = GetWindowLongPtr(hwnd, GWL_STYLE);
  style &= ~(WS_CAPTION | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_SYSMENU);
  SetWindowLongPtr(hwnd, GWL_STYLE, style | WS_POPUP);

  // Aplica a nova dimensão cobrindo a tela toda e traz para a frente
  SetWindowPos(hwnd, HWND_TOP, 0, 0, screen_width, screen_height, 
               SWP_FRAMECHANGED | SWP_SHOWWINDOW);

  // Oculta a setinha do mouse do Windows
  ShowCursor(FALSE);
  // --------------------------------------------------------

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}