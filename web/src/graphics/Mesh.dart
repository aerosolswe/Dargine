part of Dargine;

class Mesh {

  webgl.RenderingContext glContext;

  webgl.Buffer cubeVertexTextureCoordBuffer;
  webgl.Buffer cubeVertexPositionBuffer;
  webgl.Buffer cubeVertexIndexBuffer;

  int size;

  Mesh(webgl.RenderingContext gl) {
    glContext = gl;

    // variables to store verticies, tecture coordinates and colors
    List<double> vertices, textureCoords, colors;

    // create square
    cubeVertexPositionBuffer = glContext.createBuffer();
    glContext.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, cubeVertexPositionBuffer);
    // fill "current buffer" with triangle verticies
    vertices = [
        // Front face
        -1.0, -1.0, 1.0,
        1.0, -1.0, 1.0,
        1.0, 1.0, 1.0,
        -1.0, 1.0, 1.0,

        // Back face
        -1.0, -1.0, -1.0,
        -1.0, 1.0, -1.0,
        1.0, 1.0, -1.0,
        1.0, -1.0, -1.0,

        // Top face
        -1.0, 1.0, -1.0,
        -1.0, 1.0, 1.0,
        1.0, 1.0, 1.0,
        1.0, 1.0, -1.0,

        // Bottom face
        -1.0, -1.0, -1.0,
        1.0, -1.0, -1.0,
        1.0, -1.0, 1.0,
        -1.0, -1.0, 1.0,

        // Right face
        1.0, -1.0, -1.0,
        1.0, 1.0, -1.0,
        1.0, 1.0, 1.0,
        1.0, -1.0, 1.0,

        // Left face
        -1.0, -1.0, -1.0,
        -1.0, -1.0, 1.0,
        -1.0, 1.0, 1.0,
        -1.0, 1.0, -1.0,
    ];
    glContext.bufferData(webgl.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(vertices), webgl.RenderingContext.STATIC_DRAW);

    cubeVertexTextureCoordBuffer = glContext.createBuffer();
    glContext.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, cubeVertexTextureCoordBuffer);
    textureCoords = [
        // Front face
        0.0, 0.0,
        1.0, 0.0,
        1.0, 1.0,
        0.0, 1.0,

        // Back face
        1.0, 0.0,
        1.0, 1.0,
        0.0, 1.0,
        0.0, 0.0,

        // Top face
        0.0, 1.0,
        0.0, 0.0,
        1.0, 0.0,
        1.0, 1.0,

        // Bottom face
        1.0, 1.0,
        0.0, 1.0,
        0.0, 0.0,
        1.0, 0.0,

        // Right face
        1.0, 0.0,
        1.0, 1.0,
        0.0, 1.0,
        0.0, 0.0,

        // Left face
        0.0, 0.0,
        1.0, 0.0,
        1.0, 1.0,
        0.0, 1.0,
    ];
    glContext.bufferData(webgl.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(textureCoords), webgl.RenderingContext.STATIC_DRAW);

    cubeVertexIndexBuffer = glContext.createBuffer();
    glContext.bindBuffer(webgl.RenderingContext.ELEMENT_ARRAY_BUFFER, cubeVertexIndexBuffer);
    List<int> cubeVertexIndices = [
        0, 1, 2, 0, 2, 3, // Front face
        4, 5, 6, 4, 6, 7, // Back face
        8, 9, 10, 8, 10, 11, // Top face
        12, 13, 14, 12, 14, 15, // Bottom face
        16, 17, 18, 16, 18, 19, // Right face
        20, 21, 22, 20, 22, 23 // Left face
    ];
    glContext.bufferData(webgl.RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(cubeVertexIndices), webgl.RenderingContext.STATIC_DRAW);
    size = cubeVertexIndices.length;
  }

  void draw() {
    glContext.enableVertexAttribArray(0);
    glContext.enableVertexAttribArray(1);

    // verticies
    glContext.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, cubeVertexPositionBuffer);
    glContext.vertexAttribPointer(0, 3, webgl.RenderingContext.FLOAT, false, 0, 0);

    // texture
    glContext.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, cubeVertexTextureCoordBuffer);
    glContext.vertexAttribPointer(1, 2, webgl.RenderingContext.FLOAT, false, 0, 0);

    glContext.bindBuffer(webgl.RenderingContext.ELEMENT_ARRAY_BUFFER, cubeVertexIndexBuffer);
    glContext.drawElements(webgl.RenderingContext.TRIANGLES, size, webgl.RenderingContext.UNSIGNED_SHORT, 0);

    glContext.disableVertexAttribArray(0);
    glContext.disableVertexAttribArray(1);
  }
}
