// CTRU
gfxInitDefault :: () -> void #foreign;
gfxExit :: () -> void #foreign;
hidInit :: () -> void #foreign;
hidExit :: () -> void #foreign;
hidScanInput :: () -> void #foreign;
hidKeysDown :: () -> int #foreign;
gfxFlushBuffers :: () -> void #foreign;
gfxSwapBuffers :: () -> void #foreign;
aptMainLoop :: () -> bool #foreign;
consoleInit :: (scren: int, console: ^void) -> void;

// Basic
printf :: (s: ^char, args: ..) -> void #foreign;


main :: () -> int {
  gfxInitDefault();
  consoleInit(0, 0);
  hidInit();
  defer gfxExit();
  defer hidExit();
  printf("Hello world!\n");
  while (aptMainLoop()) {
    hidScanInput();

    gfxFlushBuffers();
    gfxSwapBuffers();
  }

  return 0;
}
