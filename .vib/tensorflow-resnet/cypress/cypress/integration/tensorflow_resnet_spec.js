/// <reference types="cypress" />

it('classifies sample image', () => {
  cy.fixture('persian_cat.jpeg').then((base64Img) => {
    cy.loadB64Image(base64Img).then((loadedImg) => {
      const img = loadedImg.get()[0];
      let inputImgWidth = img.width;
      let inputImgHeight = img.height;

      // Convert the image to an array of RGB values
      // Based on the tutorial:
      // https://developers.google.com/codelabs/classify-images-tensorflow-serving#6
      let canvas = document.createElement('canvas');
      let context = canvas.getContext('2d');
      canvas.width = inputImgWidth;
      canvas.height = inputImgHeight;

      let imgTensor = new Array();
      let pixelArray = new Array();
      context.drawImage(img, 0, 0);
      for (let i = 0; i < inputImgHeight; i++) {
        pixelArray[i] = new Array();
        for (let j = 0; j < inputImgWidth; j++) {
          pixelArray[i][j] = new Array();
          pixelArray[i][j].push(context.getImageData(i, j, 1, 1).data[0] / 255);
          pixelArray[i][j].push(context.getImageData(i, j, 1, 1).data[1] / 255);
          pixelArray[i][j].push(context.getImageData(i, j, 1, 1).data[2] / 255);
        }
      }
      imgTensor.push(pixelArray);
      let data = JSON.stringify({
        instances: imgTensor,
      });

      cy.request({
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=utf-8' },
        url: `v1/models/resnet:predict`,
        body: data,
      }).then((response) => {
        expect(response.status).to.eq(200);;
        let predictionByCategory = response.body.predictions[0];
        const guessedCategory = predictionByCategory.indexOf(Math.max(...predictionByCategory));
        // 281 to 285 are different breeds of cats the model is able to identify.
        // 283 --> Persian Cat
        // From: https://gist.githubusercontent.com/yrevar/942d3a0ac09ec9e5eb3a/raw/238f720ff059c1f82f368259d1ca4ffa5dd8f9f5/imagenet1000_clsidx_to_labels.txt
        expect(guessedCategory).to.equal(283);
      });
    });
  });
});
