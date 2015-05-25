import 'dart:html';
import 'dart:collection';
import 'dart:web_gl' as webgl;
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart';

class Shader {

  webgl.RenderingContext glContext;

  webgl.Program program;

  Shader(webgl.RenderingContext gl, String vsSource, String fsSource) {
    glContext = gl;

    createShader(vsSource, fsSource);
  }

  void createShader(String vsSource, String fsSource) {
    webgl.Shader vs = glContext.createShader(webgl.RenderingContext.VERTEX_SHADER);
    glContext.shaderSource(vs, vsSource);
    glContext.compileShader(vs);

    webgl.Shader fs = glContext.createShader(webgl.RenderingContext.FRAGMENT_SHADER);
    glContext.shaderSource(fs, fsSource);
    glContext.compileShader(fs);

    program = glContext.createProgram();
    glContext.attachShader(program, vs);
    glContext.attachShader(program, fs);
    glContext.linkProgram(program);
    glContext.useProgram(program);

    if (!glContext.getShaderParameter(vs, webgl.RenderingContext.COMPILE_STATUS)) {
      print(glContext.getShaderInfoLog(vs));
    }

    if (!glContext.getShaderParameter(fs, webgl.RenderingContext.COMPILE_STATUS)) {
      print(glContext.getShaderInfoLog(fs));
    }

    if (!glContext.getProgramParameter(program, webgl.RenderingContext.LINK_STATUS)) {
      print(glContext.getProgramInfoLog(program));
    }
  }

  int getAttributeLocation(String name) {
    return glContext.getAttribLocation(program, name);
  }

  void setUniformMatrix(String name, Matrix4 mat) {
    glContext.uniformMatrix4fv(glContext.getUniformLocation(program, name), false, mat.storage);
  }

  void setUniformInt(String name, int value) {
    glContext.uniform1i(glContext.getUniformLocation(program, name), value);
  }

}