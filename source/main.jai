
gfxInitDefault :: () -> void #foreign;
gfxExit :: () -> void #foreign;
gfxFlushBuffers :: () -> void #foreign;
gfxSwapBuffers :: () -> void #foreign;
aptMainLoop :: () -> bool #foreign;
consoleInit :: (screen : int, console : ^void) -> void;
printf :: (s: ^char, args: ..) -> void #foreign;

main :: () -> int {
  gfxInitDefault();
  defer gfxExit();
  consoleInit(0, 0);
  printf("Hello world!\n");
  while (aptMainLoop()) {
    gfxFlushBuffers();
    gfxSwapBuffers();
  }

  return 0;
}
