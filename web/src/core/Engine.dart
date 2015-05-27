library Dargine;

import 'dart:html';
import 'dart:web_gl' as webgl;
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart';
import 'dart:typed_data';

part '../core/ModelInstance.dart';
part '../graphics/Shader.dart';
part '../graphics/Camera.dart';
part '../graphics/Texture.dart';
part '../graphics/Mesh.dart';

class Engine {
  static Shader basicShader;

  CanvasElement canvas;
  webgl.RenderingContext glContext;
  webgl.Program shaderProgram;

  int get width => canvas.width;
  int get height => canvas.height;

  List<ModelInstance> instances;

  Camera mainCamera;

  double xRot = 0.0,
  xSpeed = 20.0,
  yRot = 0.0,
  ySpeed = 10.0,
  zPos = -5.0;

  int filter = 0;
  double lastTime = 0.0;

  bool get isFullscreen => canvas == document.fullscreenElement;

  var requestAnimationFrame;

  Engine(CanvasElement canvas) {
    this.canvas = canvas;

    canvas.width = canvas.parent.client.width;
    canvas.height = canvas.parent.client.height;

    glContext = canvas.getContext("experimental-webgl");

    basicShader = new Shader(glContext, "./res/shaders/basic.vs", "./res/shaders/basic.fs");

    mainCamera = new Camera(makePerspectiveMatrix(radians(90.0), width / height, 0.1, 1000.0));
    mainCamera.transform.translate(0, 10.0, -15.0);
    bind();

    var random = new math.Random();
    instances = new List<ModelInstance>();
    for(int i = 0; i < 10; i++) {
      ModelInstance m = new ModelInstance(new Mesh(glContext), new Texture(glContext, "./res/textures/crate.gif"));
      m.transform.translate(random.nextDouble() * 10, random.nextDouble() * 10, random.nextDouble() * 10);

      instances.add(m);
    }

    mainCamera.lookAt(instances[random.nextInt(10)].transform.getTranslation());


    glContext.enable(webgl.RenderingContext.CULL_FACE);
    glContext.enable(webgl.RenderingContext.DEPTH_TEST);
  }

  double renderTime;

  void render(double time) {
    var t = new DateTime.now().millisecondsSinceEpoch;

    if (renderTime != null) {
      showFps((1000 / (t - renderTime)).round());
    }

    renderTime = t.toDouble();

    glContext.viewport(0, 0, width, height);
    glContext.clearColor(0.1, 0.1, 0.1, 1.0);
    glContext.clearDepth(1.0);
    glContext.clear(webgl.RenderingContext.COLOR_BUFFER_BIT |
    webgl.RenderingContext.DEPTH_BUFFER_BIT);

    /** Add active shader == instance.shader check if using */
    if (!basicShader.isUsing) basicShader.use();

    basicShader.setUniformInt("uSampler", 0);
    basicShader.setUniformMatrix("uPMatrix", mainCamera.getViewProjection());

    for (var instance in instances) {
      basicShader.setUniformMatrix("uMVMatrix", instance.transform);

      instance.draw();
    }

    if (basicShader.isUsing) basicShader.stopUsing();

    animate(time);

    window.requestAnimationFrame(this.render);
  }

  void animate(double timeNow) {
    if (lastTime != 0) {
      double elapsed = timeNow - lastTime;

      xRot += (xSpeed * elapsed) / 1000.0;
      yRot += (ySpeed * elapsed) / 1000.0;
    }
    lastTime = timeNow;
  }

  double degToRad(double degrees) {
    return degrees * math.PI / 180;
  }

  void toggleFullscreen() {
    if (isFullscreen) {
      document.exitFullscreen();
    } else {
      canvas.requestFullscreen();
    }
  }

  void fullscreenChange(Event event) {
    canvas.width = canvas.parent.client.width;
    canvas.height = canvas.parent.client.height;
  }

  double fpsAverage;

  void showFps(int fps) {
    if (fpsAverage == null) {
      fpsAverage = fps.toDouble();
    }

    fpsAverage = fps * 0.05 + fpsAverage * 0.95;

    querySelector("#notes").text = "${fpsAverage.round()} fps";
  }

  void bind() {
    document.onFullscreenChange.listen(fullscreenChange);
  }

  void start() {
    DateTime d;
    lastTime = (new DateTime.now()).millisecondsSinceEpoch * 1.0;
    window.requestAnimationFrame(this.render);
  }
}

void main() {
  Engine engine = new Engine(document.query('#container'));
  engine.start();
}
