import 'dart:html';
import 'dart:collection';
import 'dart:web_gl' as webgl;
import 'dart:math' as math;
import '../graphics/Mesh.dart';
import '../graphics/Texture.dart';
import '../graphics/Shader.dart';
import 'package:vector_math/vector_math.dart';

class Engine {

  CanvasElement canvas;
  webgl.RenderingContext glContext;
  webgl.Program shaderProgram;

  int get width => canvas.width;
  int get height => canvas.height;

  Mesh mesh;
  Texture texture;
  Shader shader;

  Matrix4 pMatrix;
  Matrix4 mvMatrix;
  Queue<Matrix4> mvMatrixStack;

  int aVertexPosition;
  int aTextureCoord;
  webgl.UniformLocation uPMatrix;
  webgl.UniformLocation uMVMatrix;
  webgl.UniformLocation samplerUniform;

  double xRot = 0.0, xSpeed = 20.0,
  yRot = 0.0, ySpeed = 10.0,
  zPos = -5.0;

  int filter = 0;
  double lastTime = 0.0;

  List<bool> currentlyPressedKeys;
  bool get isFullscreen => canvas == document.fullscreenElement;

  var requestAnimationFrame;

  Engine(CanvasElement canvasElement) {
    canvas = canvasElement;
    canvas.width = canvas.parent.client.width;
    canvas.height = canvas.parent.client.height;
    currentlyPressedKeys = new List<bool>(128);
    glContext = canvas.getContext("experimental-webgl");

    mvMatrix = new Matrix4.identity();
    pMatrix = new Matrix4.identity();
    bind();

    String vsSource = """
    attribute vec3 aVertexPosition;
    attribute vec2 aTextureCoord;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    varying vec2 vTextureCoord;

    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      vTextureCoord = aTextureCoord;
    }
    """;

    // fragment shader source code. uColor is our variable that we'll
    // use to animate color
    String fsSource = """
    precision mediump float;
    varying vec2 vTextureCoord;
    uniform sampler2D uSampler;
    void main(void) {
      gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));
    }
    """;

    shader = new Shader(glContext, vsSource, fsSource);
    aVertexPosition = shader.getAttributeLocation("aVertexPosition");
    aTextureCoord =   shader.getAttributeLocation("aTextureCoord");
    texture = new Texture(glContext, "./crate.gif");
    mesh = new Mesh(glContext);

    glContext.enable(webgl.RenderingContext.CULL_FACE);
    glContext.enable(webgl.RenderingContext.DEPTH_TEST);
  }

  void setMatrixUniforms() {
    shader.setUniformMatrix("uPMatrix", pMatrix);
    shader.setUniformMatrix("uMVMatrix", mvMatrix);
  }

  double renderTime;

  void render(double time) {
    var t = new DateTime.now().millisecondsSinceEpoch;

    if (renderTime != null) {
      showFps((1000 / (t - renderTime)).round());
    }

    renderTime = t.toDouble();

    glContext.viewport(0, 0, width, height);
    glContext.clearColor(0.0, 0.0, 0.0, 1.0);
    glContext.clearDepth(1.0);
    glContext.clear(webgl.RenderingContext.COLOR_BUFFER_BIT | webgl.RenderingContext.DEPTH_BUFFER_BIT);

    pMatrix = makePerspectiveMatrix(radians(90.0), width / height, 0.1, 100.0);

    // draw triangle
    mvMatrix = new Matrix4.identity();

    mvMatrix.translate(new Vector3(0.0, 0.0, zPos));

    mvMatrix.rotate(new Vector3(1.0, 0.0, 0.0), degToRad(xRot));
    mvMatrix.rotate(new Vector3(0.0, 1.0, 0.0), degToRad(yRot));
    //_mvMatrix.rotate(_degToRad(_zRot), new Vector3.fromList([0, 0, 1]));

    texture.bind(0);
    shader.setUniformInt("uSampler", 0);
    setMatrixUniforms();

    mesh.draw(aVertexPosition, aTextureCoord);

    // rotate
    animate(time);

    // keep drawing
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
