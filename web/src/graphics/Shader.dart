part of Dargine;

class Shader {

  webgl.RenderingContext glContext;
  webgl.Program program;

  String vsSource;
  String fsSource;

  bool isUsing;
  bool complete;

  Shader(webgl.RenderingContext glContext, var vsPath, var fsPath) {
    this.glContext = glContext;
    isUsing = false;

    HttpRequest.getString(vsPath)
    .then((String fileContents) {
      vsSource = fileContents;

      if(complete)
        createShader(vsSource, fsSource);
      else
        complete = true;

    })
    .catchError((Error error) {
      print(error.toString());
    });

    HttpRequest.getString(fsPath)
    .then((String fileContents) {
      fsSource = fileContents;

      if(complete)
        createShader(vsSource, fsSource);
      else
        complete = true;
    })
    .catchError((Error error) {
      print(error.toString());
    });

  }

  void createShader(String vsSource, String fsSource) {
    webgl.Shader vs =
        glContext.createShader(webgl.RenderingContext.VERTEX_SHADER);
    glContext.shaderSource(vs, vsSource);
    glContext.compileShader(vs);

    webgl.Shader fs =
        glContext.createShader(webgl.RenderingContext.FRAGMENT_SHADER);
    glContext.shaderSource(fs, fsSource);
    glContext.compileShader(fs);

    program = glContext.createProgram();
    glContext.attachShader(program, vs);
    glContext.attachShader(program, fs);
    glContext.linkProgram(program);

    if (!glContext.getShaderParameter(
        vs, webgl.RenderingContext.COMPILE_STATUS)) {
      print(glContext.getShaderInfoLog(vs));
    }

    if (!glContext.getShaderParameter(
        fs, webgl.RenderingContext.COMPILE_STATUS)) {
      print(glContext.getShaderInfoLog(fs));
    }

    if (!glContext.getProgramParameter(
        program, webgl.RenderingContext.LINK_STATUS)) {
      print(glContext.getProgramInfoLog(program));
    }
  }

  int getAttributeLocation(String name) {
    return glContext.getAttribLocation(program, name);
  }

  void setUniformMatrix(String name, Matrix4 mat) {
    glContext.uniformMatrix4fv(
        glContext.getUniformLocation(program, name), false, mat.storage);
  }

  void setUniformInt(String name, int value) {
    glContext.uniform1i(glContext.getUniformLocation(program, name), value);
  }

  void use() {
    isUsing = true;
    glContext.useProgram(program);
  }

  void stopUsing() {
    isUsing = false;
  }
}
