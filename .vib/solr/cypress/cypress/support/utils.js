/// <reference types="cypress" />

export const getBasicAuthHeader = (
  username = Cypress.env("username"),
  password = Cypress.env("password")
) => {
  return "Basic ".concat(btoa(`${username}:${password}`));
};
