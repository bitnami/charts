/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

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
        expect(response.status).to.eq(200);

        const predictionByCategory = response.body.predictions[0];
        expect(
          Array.isArray(predictionByCategory) &&
            !predictionByCategory.includes('') &&
            !predictionByCategory.includes(null)
        ).to.be.true;

        const maxValue = Math.max(...predictionByCategory);
        expect(maxValue !== -Infinity && !isNaN(maxValue)).to.be.true;
      });
    });
  });
});
