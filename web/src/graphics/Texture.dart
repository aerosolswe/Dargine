part of Dargine;

class Texture {
  webgl.RenderingContext glContext;
  webgl.Texture id;

  Texture(webgl.RenderingContext glContext, String src) {
    this.glContext = glContext;
    id = glContext.createTexture();

    ImageElement image = new Element.tag('img');
    image.onLoad.listen((e) {
      handleLoadedTexture(image);
    });
    image.src = src;
  }

  void handleLoadedTexture(ImageElement img) {
    glContext.pixelStorei(webgl.RenderingContext.UNPACK_FLIP_Y_WEBGL, 1); // second argument must be an int (no boolean)

    glContext.bindTexture(webgl.RenderingContext.TEXTURE_2D, id);
    glContext.texImage2D(webgl.RenderingContext.TEXTURE_2D, 0, webgl.RenderingContext.RGBA, webgl.RenderingContext.RGBA, webgl.RenderingContext.UNSIGNED_BYTE, img);
    glContext.texParameteri(webgl.RenderingContext.TEXTURE_2D, webgl.RenderingContext.TEXTURE_MAG_FILTER, webgl.RenderingContext.LINEAR);
    glContext.texParameteri(webgl.RenderingContext.TEXTURE_2D, webgl.RenderingContext.TEXTURE_MIN_FILTER, webgl.RenderingContext.LINEAR_MIPMAP_NEAREST);
    glContext.generateMipmap(webgl.RenderingContext.TEXTURE_2D);

    glContext.bindTexture(webgl.RenderingContext.TEXTURE_2D, null);
  }

  void bind(int slot) {
    glContext.activeTexture(webgl.RenderingContext.TEXTURE0 + slot);
    glContext.bindTexture(webgl.RenderingContext.TEXTURE_2D, id);
  }

}