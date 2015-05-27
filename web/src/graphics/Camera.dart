part of Dargine;

class Camera {

  Matrix4 projection;
  Matrix4 transform;

  Camera(Matrix4 projection) {
    this.projection = projection;
    this.transform = new Matrix4.identity();
//  this.transform = makeViewMatrix(new Vector3(5, 5, -5), new Vector3(0, 0, 0), new Vector3(0, 1, 0));
  }

  Matrix4 getViewProjection() {
    Matrix4 pr = projection.clone();
    Matrix4 view = transform.clone();
    return pr.multiply(view);
  }

  void lookAt(Vector3 point) {
    transform = makeViewMatrix(transform.getTranslation(), point, new Vector3(0.0, 1.0, 0.0));
  }
}