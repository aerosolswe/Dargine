
import 'dart:html';
import 'dart:collection';
import 'dart:web_gl' as webgl;
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart';


class Mesh {

  webgl.RenderingContext glContext;

  webgl.Buffer cubeVertexTextureCoordBuffer;
  webgl.Buffer cubeVertexPositionBuffer;
  webgl.Buffer cubeVertexIndexBuffer;

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
    List<int> _cubeVertexIndices = [
        0, 1, 2, 0, 2, 3, // Front face
        4, 5, 6, 4, 6, 7, // Back face
        8, 9, 10, 8, 10, 11, // Top face
        12, 13, 14, 12, 14, 15, // Bottom face
        16, 17, 18, 16, 18, 19, // Right face
        20, 21, 22, 20, 22, 23 // Left face
    ];
    glContext.bufferData(webgl.RenderingContext.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(_cubeVertexIndices), webgl.RenderingContext.STATIC_DRAW);
  }

  void draw(int vertexPos, int textureCoord) {
    glContext.enableVertexAttribArray(vertexPos);
    glContext.enableVertexAttribArray(textureCoord);

    // verticies
    glContext.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, cubeVertexPositionBuffer);
    glContext.vertexAttribPointer(0, 3, webgl.RenderingContext.FLOAT, false, 0, 0);

    // texture
    glContext.bindBuffer(webgl.RenderingContext.ARRAY_BUFFER, cubeVertexTextureCoordBuffer);
    glContext.vertexAttribPointer(1, 2, webgl.RenderingContext.FLOAT, false, 0, 0);

    glContext.bindBuffer(webgl.RenderingContext.ELEMENT_ARRAY_BUFFER, cubeVertexIndexBuffer);
    glContext.drawElements(webgl.RenderingContext.TRIANGLES, 36, webgl.RenderingContext.UNSIGNED_SHORT, 0);

    glContext.disableVertexAttribArray(vertexPos);
    glContext.disableVertexAttribArray(textureCoord);
  }
}
