/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(7);

export const checkErrors = (selector, allowedList) => {
  cy.get(selector).then(($errors) => {
    const errorMessages = [];
    for (let index = 0; index < $errors.length; index++) {
      const errorMsg = $errors[index].outerText;
      const visible = Cypress.$($errors[index]).is(':visible');
      if (visible && !allowedList.includes(errorMsg)) {
        cy.log(
          `The following misconfiguration message appears in the UI: ${errorMsg}`
        );
        errorMessages.push(errorMsg);
      }
    }
    expect(errorMessages).to.be.empty;
  });
};
