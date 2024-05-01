/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

Cypress.Commands.add('loadB64Image', (base64) => {
  const loadImage = () => {
    const img = new Image();
    return new Promise((resolve) => {
      img.onload = () => {
        resolve(img);
      };
      img.src = 'data:image/jpeg;base64,' + base64;
    });
  };
  return loadImage();
});
