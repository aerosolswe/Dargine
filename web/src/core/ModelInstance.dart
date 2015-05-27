part of Dargine;

class ModelInstance {

  Mesh mesh;
  Texture texture;
  Matrix4 transform;

  ModelInstance(Mesh mesh, Texture texture) {
    this.mesh = mesh;
    this.transform = new Matrix4.identity();
    this.texture = texture;
  }

  void draw() {
    texture.bind(0);
    mesh.draw();
  }

}