/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(7);

export const getBasicAuthHeader = (
  username = Cypress.env("username"),
  password = Cypress.env("password")
) => {
  return "Basic ".concat(btoa(`${username}:${password}`));
};
