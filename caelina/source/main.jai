// CTRU
gfxInitDefault :: () -> void #foreign;
gfxExit :: () -> void #foreign;
hidInit :: () -> void #foreign;
hidExit :: () -> void #foreign;
hidScanInput :: () -> void #foreign;
hidKeysDown :: () -> int #foreign;
gfxFlushBuffers :: () -> void #foreign;
gfxSwapBuffersGpu :: () -> void #foreign;
gspWaitForEvent :: (id: int, next: bool) -> void #foreign;
gfxSwapBuffers :: () -> void #foreign;
gfxGetFramebuffer :: (screen: int, side: int, unk: int, unk0: int) -> ^void #foreign;
aptMainLoop :: () -> bool #foreign;

GSPGPU_EVENT_VBlank0:= 2;
GX_TRANSFER_FMT_RGB8:= 1;

// Basic
printf :: (s: ^char, args: ..) -> void #foreign;
tan :: (x: double) -> double #foreign;

// Caelina
gfxCreateDevice :: (w: int, h:int, flags:int) -> ^void #foreign;
gfxDestroyDevice :: (dev: ^void) -> void #foreign;
gfxMakeCurrent :: (context: ^void) -> ^void #foreign;
gfxFlush :: (fb : ^void, w: int, h: int, format: int) -> void #foreign;

// GL
glClear :: (flags: int) -> void #foreign;
glLoadIdentity :: () -> void #foreign;
glTranslatef :: (x: float, y: float, z: float) -> void #foreign;
glColor3f :: (r: float, g: float, b: float) -> void #foreign;
glBegin :: (gl_enum: int) -> void #foreign;
glEnd :: () -> void #foreign;
glVertex3f :: (x: float, y: float, z: float) -> void #foreign;
glMatrixMode :: (gl_enum: int) -> void #foreign;
glViewport :: (x: int, y: int, w: int, h: int) -> void #foreign;
glFrustum :: (l: double, r: double, b: double, t: double, n: double, f: double) -> void #foreign;
glRotatef :: (rad: float, x: float, y: float, z: float) -> void #foreign;
glClearColor :: (r: float, g: float, b: float, a: float) -> void #foreign;
glEnable :: (gl_enum: int) -> void #foreign;

GL_COLOR_BUFFER_BIT:= 0x00004000;
GL_DEPTH_BUFFER_BIT:= 0x00000100;

GL_TRIANGLES:= 0x0004;

GL_MODELVIEW:= 0x1700;
GL_PROJECTION:= 0x1701;

GL_DEPTH_TEST:= 0x0B71;

DrawGLScene :: () -> void {
  glClear(GL_COLOR_BUFFER_BIT);
  glClear(GL_DEPTH_BUFFER_BIT);

  glLoadIdentity();
  glTranslatef(-1.5,0.0,-6.0);
  glColor3f(1.0, 1.0, 1.0);
  glBegin(GL_TRIANGLES);                      // Drawing Using Triangles
      glVertex3f( 0.0, 1.0, 0.0);              // Top
      glVertex3f(-1.0,-1.0, 0.0);              // Bottom Left
      glVertex3f( 1.0,-1.0, 0.0);              // Bottom Right
  glEnd();                            // Finished Drawing The Triangle
}

gspWaitForVBlank :: () -> void {
  gspWaitForEvent(GSPGPU_EVENT_VBlank0, true);
}

main :: () -> int {
  gfxInitDefault();
  hidInit();
  defer gfxExit();
  defer hidExit();
  gfx_handle:= gfxCreateDevice(240, 400, 0);
  gfxMakeCurrent(gfx_handle);
  defer gfxDestroyDevice(gfx_handle);

  glViewport(0, 0, 240, 400);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  near: float = 0.1;
  far: float = 100.0;
  fov: float = 90.0;
  aspect: float = 240.0 / 400.0;
  t: float = tan(fov * 3.14159 / 360.0) * near;
  b: float = -t;
  l: float = aspect * b;
  r: float = aspect * t;
  glFrustum(xx l, xx r, xx b, xx t, xx near, xx far);
  //3DS' framebuffers are sideways
  glRotatef(-90.0, 0.0, 0.0, 1.0);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  glClearColor(1.0, 0.0, 0.0, 1.0);
  glEnable(GL_DEPTH_TEST);

  while (aptMainLoop()) {
    hidScanInput();

    DrawGLScene();

    gfxFlush(gfxGetFramebuffer(0, 0, 0, 0), 240, 400, GX_TRANSFER_FMT_RGB8);
    gfxFlushBuffers();
    gfxSwapBuffersGpu();
    gspWaitForVBlank();
  }

  return 0;
}
